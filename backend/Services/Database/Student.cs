using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Database
{
    public class Student : User
    {
        public ICollection<StudentLanguage> StudentLanguages { get; set; } = new List<StudentLanguage>();

    }
}
