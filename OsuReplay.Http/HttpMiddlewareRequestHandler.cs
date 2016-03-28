namespace OsuReplay.Http
{
    internal class HttpMiddlewareRequestHandler : HttpMiddlewareBase
    {
        public HttpMiddlewareRequestHandler(HttpRequestHandlerDelegate handler)
        {
            handler_ = handler;
        }

        public override void Handle(IHttpRequest request, IHttpResponse response)
        {
            handler_(request, response);
        }

        private HttpRequestHandlerDelegate handler_;
    }
}
