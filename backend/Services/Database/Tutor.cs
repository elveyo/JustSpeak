using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Database
{
    public class Tutor : User
    {
        public ICollection<TutorLanguage> TutorLanguages { get; set; } = new List<TutorLanguage>();
        public ICollection<Certificate> Certificates  { get; set; } = new List<Certificate>();
    }
}
