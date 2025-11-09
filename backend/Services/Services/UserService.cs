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

            query = ApplyFilter(query, search);
            var totalCount = await query.CountAsync();
            query = ApplyPagination(query, search);

            var users = await query.ToListAsync();
            return new PagedResult<UserResponse>
            {
                Items = users.Select(_mapper.Map<UserResponse>).ToList(),
                TotalCount = totalCount,
            };
        }

        protected override IQueryable<User> ApplyFilter(
            IQueryable<User> query,
            UserSearchObject search
        )
        {
            if (!string.IsNullOrEmpty(search.FTS))
            {
                query = query.Where(u =>
                    u.FirstName.Contains(search.FTS)
                    || u.LastName.Contains(search.FTS)
                    || u.Email.Contains(search.FTS)
                );
            }
            if (!string.IsNullOrEmpty(search.Role))
            {
                query = query.Where(u => u.Discriminator.ToLower() == search.Role.ToLower());
            }

            if (search.LanguageId.HasValue)
            {
                query = query.Where(u =>
                    (
                        u is Tutor
                        && ((Tutor)u).TutorLanguages.Any(tl =>
                            tl.LanguageId == search.LanguageId.Value
                        )
                    )
                    || (
                        u is Student
                        && ((Student)u).StudentLanguages.Any(sl =>
                            sl.LanguageId == search.LanguageId.Value
                        )
                    )
                );
            }
            if (search.LevelId.HasValue)
            {
                query = query.Where(u =>
                    (
                        u is Tutor
                        && ((Tutor)u).TutorLanguages.Any(tl => tl.LevelId == search.LevelId.Value)
                    )
                    || (
                        u is Student
                        && ((Student)u).StudentLanguages.Any(sl =>
                            sl.LevelId == search.LevelId.Value
                        )
                    )
                );
            }

            return query;
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

            if (request.Role == "Tutor")
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
            else if (request.Role == "Student")
            {
                user = new Student();

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
            else if (request.Role == "Admin")
            {
                user = new Admin();
            }
            else
            {
                throw new ArgumentException(
                    $"Invalid role: {request.Role}. Valid roles are: Student, Tutor, Admin"
                );
            }

            _mapper.Map(request, user);

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

            if (await _context.Users.AnyAsync(u => u.Email == request.Email && u.Id != id))
            {
                throw new InvalidOperationException("A user with this email already exists.");
            }

            user = _mapper.Map(request, user);

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
            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == request.Email);

            if (user == null)
                return null;

            if (!VerifyPassword(request.Password!, user.PasswordHash, user.PasswordSalt))
                return null;
            var token = _tokenService.GetToken(user);

            var response = _mapper.Map<UserResponse>(user);

            response.Token = token;

            Console.WriteLine(response.Token);
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
                        Role = u.Role.ToString(),
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

        public async Task<StatisticsResponse> GetStatisticsAsync()
        {
            var stats = new StatisticsResponse();

            // Count students and tutors based on Discriminator or Type
            stats.StudentsNum = await _context.Users.CountAsync(u => u.Discriminator == "Student");
            stats.TutorsNum = await _context.Users.CountAsync(u => u.Discriminator == "Tutor");

            // Count sessions
            stats.SessionsNum = await _context.StudentTutorSessions.CountAsync();

            // Prepare users registered per month (grouped by Month/Year)
            stats.Users = await _context
                .Users.GroupBy(u => new { u.CreatedAt.Year, u.CreatedAt.Month })
                .OrderBy(g => g.Key.Year)
                .ThenBy(g => g.Key.Month)
                .Select(g => new Dictionary<int, int>
                {
                    { g.Key.Year * 100 + g.Key.Month, g.Count() },
                })
                .ToListAsync();

            // Prepare sessions per month (grouped by Month/Year)
            stats.Sessions = await _context
                .Sessions.GroupBy(s => new { s.CreatedAt.Year, s.CreatedAt.Month })
                .OrderBy(g => g.Key.Year)
                .ThenBy(g => g.Key.Month)
                .Select(g => new Dictionary<int, int>
                {
                    { g.Key.Year * 100 + g.Key.Month, g.Count() },
                })
                .ToListAsync();

            return stats;
        }
    }
}
