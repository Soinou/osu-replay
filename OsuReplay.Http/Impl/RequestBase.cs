using System.Collections.Generic;
using System.Net;

namespace OsuReplay.Http.Impl
{
    internal class RequestBase : IRequest
    {
        public RequestBase(HttpListenerRequest request)
        {
            request_ = request;
            parameters_ = null;
        }

        public string Method
        {
            get
            {
                return request_.HttpMethod;
            }
        }

        public List<string> Parameters
        {
            get
            {
                return parameters_;
            }
            set
            {
                parameters_ = value;
            }
        }

        public string Uri
        {
            get
            {
                return request_.Url.AbsolutePath;
            }
        }

        private List<string> parameters_;
        private HttpListenerRequest request_;
    }
}
