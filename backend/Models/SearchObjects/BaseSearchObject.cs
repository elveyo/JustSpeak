using System;
using System.Collections.Generic;
using System.Text;

namespace Model.SearchObjects
{
    public class BaseSearchObject
    {
        public string? FTS { get; set; }
        public int? UserId { get; set; }
        public int? Page { get; set; } = 0;
        public int? PageSize { get; set; } = 10;
    }
}
