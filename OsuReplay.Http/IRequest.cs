using System.Collections.Generic;

namespace OsuReplay.Http
{
    public interface IRequest
    {
        string Method
        {
            get;
        }

        List<string> Parameters
        {
            get;
        }

        string Uri
        {
            get;
        }
    }
}
