using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Echo.Core
{
    public interface IHasInput<in TInput>
    {
        TInput Input { set; }
    }
}
