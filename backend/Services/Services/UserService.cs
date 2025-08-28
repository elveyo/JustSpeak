using System.Security.Cryptography;
using System.Text;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
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

        public async Task<List<UserResponse>> GetAsync(UserSearchObject search)
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
            return users.Select(_mapper.Map<UserResponse>).ToList();
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
            }
            else if (role.Name == "Student")
            {
                user = new Student();
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
            return _mapper.Map<UserResponse>(user);
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
                })
                .FirstOrDefaultAsync();

            return tutor;
        }

        public async Task<bool> InsertTutorDataAsync(TutorUpsertRequest request)
        {
            var userResponse = await CreateAsync(request.User);
            var tutor = await _context.Tutors.FirstOrDefaultAsync(t => t.Id == userResponse.Id);

            if (request.Certificates != null)
            {
                foreach (var certReq in request.Certificates)
                {
                    var certificate = new Certificate
                    {
                        Name = certReq.Name,
                        ImageUrl = certReq.ImageUrl,
                        LanguageId = certReq.LanguageId,
                        TutorId = tutor.Id,
                    };
                    tutor.Certificates.Add(certificate);
                }
            }

            // 5. Add languages if provided
            if (request.Languages != null)
            {
                foreach (var langReq in request.Languages)
                {
                    var tutorLanguage = new TutorLanguage
                    {
                        TutorId = tutor.Id,
                        LanguageId = langReq.LanguageId,
                        LevelId = langReq.LevelId,
                    };
                    tutor.TutorLanguages.Add(tutorLanguage);
                }
            }

            await _context.SaveChangesAsync();
            return true;
        }

        public async Task<bool> InsertStudentDataAsync(StudentUpsertRequest request)
        {
            var userResponse = await CreateAsync(request.User);
            var student = await _context.Students.FirstOrDefaultAsync(s => s.Id == userResponse.Id);

            foreach (var langReq in request.Languages)
            {
                var studentLanguage = new StudentLanguage
                {
                    StudentId = student.Id,
                    LanguageId = langReq.LanguageId,
                    LevelId = langReq.LevelId,
                };
                student.StudentLanguages.Add(studentLanguage);
            }

            await _context.SaveChangesAsync();
            return true;
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
        }
    }
}
