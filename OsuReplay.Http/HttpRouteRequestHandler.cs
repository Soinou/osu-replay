using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace OsuReplay.Http
{
    internal class HttpRouteRequestHandler : IHttpRequestHandler
    {
        public HttpRouteRequestHandler(string method, string pattern, HttpRequestHandlerDelegate handler)
        {
            handler_ = handler;
            method_ = method;
            parameters_ = null;
            regex_ = new Regex(pattern, RegexOptions.Compiled);
        }

        public List<string> Parameters
        {
            get
            {
                return parameters_;
            }
        }

        public bool CanHandle(IHttpRequest request)
        {
            if (!method_.Equals(request.Method))
                return false;

            var match = regex_.Match(request.Uri);

            if (match.Success)
            {
                parameters_ = new List<string>();

                for (int i = 0; i < match.Groups.Count; i++)
                {
                    parameters_.Add(match.Groups[i].Value);
                }

                return true;
            }

            return false;
        }

        public void Handle(IHttpRequest request, IHttpResponse response)
        {
            handler_(request, response);
        }

        private HttpRequestHandlerDelegate handler_;
        private string method_;
        private List<string> parameters_;
        private Regex regex_;
    }
}
