using System.Collections.Generic;

namespace OsuReplay.Http
{
    public interface IHttpRequest
    {
        string Method
        {
            get;
        }

        IList<string> Parameters
        {
            get;
        }

        string Uri
        {
            get;
        }

        T As<T>();

        string GetBody();
    }
}
