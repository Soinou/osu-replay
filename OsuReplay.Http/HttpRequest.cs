using Newtonsoft.Json;
using System.Collections.Generic;
using System.IO;
using System.Net;

namespace OsuReplay.Http
{
    internal class HttpRequest : IHttpRequest
    {
        public HttpRequest(HttpListenerRequest request)
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

        public IList<string> Parameters
        {
            get
            {
                return parameters_;
            }
        }

        public string Uri
        {
            get
            {
                return request_.Url.AbsolutePath;
            }
        }

        public T As<T>()
        {
            return JsonConvert.DeserializeObject<T>(GetBody());
        }

        public string GetBody()
        {
            if (request_.HasEntityBody)
            {
                using (var reader = new StreamReader(request_.InputStream,
                    request_.ContentEncoding))
                {
                    return reader.ReadToEnd();
                }
            }
            else
            {
                return null;
            }
        }

        public void SetParameters(List<string> parameters)
        {
            parameters_ = parameters;
        }

        private List<string> parameters_;
        private HttpListenerRequest request_;
    }
}
