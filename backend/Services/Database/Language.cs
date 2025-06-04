using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Services.Database
{
    public class Language
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public ICollection<StudentLanguage> StudentLanguages { get; set; } = new List<StudentLanguage>();
    }
}
