using System.Security.Cryptography;
using System.Text;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Model.Responses;
using Models.Requests;
using Models.Responses;
using Models.SearchObjects;
using Services.Database;
using Services.Interfaces;

namespace Services.Services
{
    public class UserService
        : BaseCRUDService<
            UserResponse,
            UserSearchObject,
            User,
            UserInsertRequest,
            UserUpdateRequest
        >,
            IUserService
    {
        private const int SaltSize = 16;
        private const int KeySize = 32;
        private const int Iterations = 10000;
        private readonly ITokenService _tokenService;

        public UserService(
            ApplicationDbContext context,
            IUserContextService userContextService,
            IMapper mapper,
            ITokenService tokenService
        )
            : base(context, mapper)
        {
            _tokenService = tokenService;
        }

        public override async Task<PagedResult<UserResponse>> GetAsync(UserSearchObject search)
        {
            var query = _context.Users.AsQueryable();

            if (!string.IsNullOrEmpty(search.Email))
            {
                query = query.Where(u => u.Email.Contains(search.Email));
            }

            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(u =>
                    u.FirstName.Contains(search.FTS)
                    || u.LastName.Contains(search.FTS)
                    || u.Email.Contains(search.FTS)
                );
            }

            var users = await query.ToListAsync();
            return new PagedResult<UserResponse>
            {
                Items = users.Select(_mapper.Map<UserResponse>).ToList(),
                TotalCount = users.Count,
            };
        }

        public override async Task<UserResponse?> GetByIdAsync(int id)
        {
            var user = await _context.Users.FindAsync(id);
            return user != null ? _mapper.Map<UserResponse>(user) : null;
        }

        private string HashPassword(string password, out byte[] salt)
        {
            salt = new byte[SaltSize];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(salt);
            }

            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, Iterations))
            {
                return Convert.ToBase64String(pbkdf2.GetBytes(KeySize));
            }
        }

        public async Task<UserResponse> CreateAsync(UserInsertRequest request)
        {
            if (await _context.Users.AnyAsync(u => u.Email == request.Email))
            {
                throw new InvalidOperationException("A user with this email already exists.");
            }

            // Determine the user type based on the role discriminator
            User user;
            var role = await _context.Roles.FindAsync(request.RoleId);
            if (role == null)
            {
                throw new InvalidOperationException("Invalid role specified.");
            }

            if (role.Name == "Tutor")
            {
                user = new Tutor();

                var tutor = user as Tutor;
                tutor.TutorLanguages = new List<TutorLanguage>();
                foreach (var langReq in request.Languages)
                {
                    var tutorLanguage = new TutorLanguage
                    {
                        LanguageId = langReq.LanguageId,
                        LevelId = langReq.LevelId,
                        PricePerHour = 0,
                        Experience = 0,
                    };
                    tutor.TutorLanguages.Add(tutorLanguage);
                }
            }
            else if (role.Name == "Student")
            {
                user = new Student();

                // Add languages for the student if provided

                var student = user as Student;
                student.StudentLanguages = new List<StudentLanguage>();
                foreach (var langReq in request.Languages)
                {
                    var studentLanguage = new StudentLanguage
                    {
                        LanguageId = langReq.LanguageId,
                        LevelId = langReq.LevelId,
                    };
                    student.StudentLanguages.Add(studentLanguage);
                }
            }
            else
            {
                user = new User();
            }

            // Map properties from request to user
            _mapper.Map(request, user);

            // Set the role id
            user.RoleId = request.RoleId;

            // Handle password if provided
            if (!string.IsNullOrEmpty(request.Password))
            {
                byte[] salt;
                user.PasswordHash = HashPassword(request.Password, out salt);
                user.PasswordSalt = Convert.ToBase64String(salt);
            }

            _context.Users.Add(user);

            await _context.SaveChangesAsync();
            UserResponse response = _mapper.Map<UserResponse>(user);
            response.Token = _tokenService.GetToken(user);
            return response;
        }

        public override async Task<UserResponse?> UpdateAsync(int id, UserUpdateRequest request)
        {
            var user = await _context.Users.FindAsync(id);
            if (user == null)
                return null;

            // Check for duplicate email and username (excluding current user)
            if (await _context.Users.AnyAsync(u => u.Email == request.Email && u.Id != id))
            {
                throw new InvalidOperationException("A user with this email already exists.");
            }

            user = _mapper.Map(request, user);

            // Handle password if provided
            if (!string.IsNullOrEmpty(request.Password))
            {
                byte[] salt;
                user.PasswordHash = HashPassword(request.Password, out salt);
                user.PasswordSalt = Convert.ToBase64String(salt);
            }

            await _context.SaveChangesAsync();
            return _mapper.Map<UserResponse>(user);
        }

        public async Task<UserResponse?> AuthenticateAsync(UserLoginRequest request)
        {
            var user = await _context
                .Users.Include(ur => ur.Role)
                .FirstOrDefaultAsync(u => u.Email == request.Email);

            if (user == null)
                return null;

            if (!VerifyPassword(request.Password!, user.PasswordHash, user.PasswordSalt))
                return null;
            var token = _tokenService.GetToken(user);

            var response = _mapper.Map<UserResponse>(user);
            response.Token = token;
            return response;
        }

        private bool VerifyPassword(string password, string passwordHash, string passwordSalt)
        {
            var salt = Convert.FromBase64String(passwordSalt);
            var hash = Convert.FromBase64String(passwordHash);
            var hashBytes = new Rfc2898DeriveBytes(password, salt, Iterations).GetBytes(KeySize);
            return hash.SequenceEqual(hashBytes);
        }

        public async Task<TutorResponse?> GetTutorDataAsync(int id)
        {
            var tutor = await _context
                .Tutors.Where(t => t.Id == id)
                .Select(t => new TutorResponse
                {
                    User = new UserResponse
                    {
                        Id = t.Id,
                        FirstName = t.FirstName,
                        LastName = t.LastName,
                        Bio = t.Bio,
                    },
                    Certificates = t
                        .Certificates.Select(c => new CertificateResponse
                        {
                            Id = c.Id,
                            Name = c.Name,
                            ImageUrl = c.ImageUrl,
                        })
                        .ToList(),
                    Languages = t
                        .TutorLanguages.Select(tl => new LanguageResponse
                        {
                            Id = tl.Language.Id,
                            Name = tl.Language.Name,
                        })
                        .ToList(),
                })
                .FirstOrDefaultAsync();

            return tutor;
        }

        public async Task<StudentResponse?> GetStudentDataAsync(int id)
        {
            var student = await _context
                .Students.Where(u => u.Id == id)
                .Select(u => new StudentResponse
                {
                    User = new UserResponse
                    {
                        Id = u.Id,
                        FirstName = u.FirstName,
                        LastName = u.LastName,
                        Bio = u.Bio,
                        Role = u.Role.Name,
                        ImageUrl = u.ImageUrl,
                    },
                    Languages = u
                        .StudentLanguages.Select(sl => new LanguageLevelResponse
                        {
                            Language = sl.Language.Name,
                            Level = sl.Level.Name,
                            Points = sl.Points,
                            MaxPoints = sl.Level.MaxPoints,
                        })
                        .ToList(),
                })
                .FirstOrDefaultAsync();

            return student;
        } /*

        public async Task<PagedResult<User>> GetUsersAsync(UserSearchObject request)
        {
            var query = _context.Users.AsQueryable();

            // Filter by RoleId if provided
            if (request.RoleId.HasValue)
            {
                query = query.Where(u => u.RoleId == request.RoleId.Value);
            }

            // Filter by LanguageId and LevelId based on role
            if (request.LanguageId.HasValue)
            {
                if (
                    request.RoleId.HasValue
                    && _context.Roles.Any(r =>
                        r.Id == request.RoleId && r.Name.ToLower() == "tutor"
                    )
                )
                {
                    // Tutor: filter by TutorLanguages
                    query = query.Where(u =>
                        (u as Tutor).TutorLanguages.Any(tl =>
                            tl.LanguageId == request.LanguageId.Value
                        )
                    );
                }
                else
                {
                    // Student: filter by StudentLanguages
                    query = query.Where(u =>
                        (u as Student).StudentLanguages.Any(sl =>
                            sl.LanguageId == request.LanguageId.Value
                        )
                    );
                }
            }

            // FTS (Full Text Search) on FirstName, LastName, Email
            if (!string.IsNullOrWhiteSpace(request.FTS))
            {
                query = query.Where(u =>
                    u.FirstName.Contains(request.FTS)
                    || u.LastName.Contains(request.FTS)
                    || u.Email.Contains(request.FTS)
                );
            }

            // Paging
            var page = request.Page ?? 0;
            var pageSize = request.PageSize ?? 10;
            var totalCount = await query.CountAsync();
            var items = await query.Skip(page * pageSize).Take(pageSize).ToListAsync();

            return new PagedResult<User>
            {
                Items = items,
                TotalCount = totalCount,
                Page = page,
                PageSize = pageSize,
            };
        } */
    }
}
