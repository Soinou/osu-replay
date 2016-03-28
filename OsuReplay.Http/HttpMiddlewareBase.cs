namespace OsuReplay.Http
{
    public abstract class HttpMiddlewareBase : IMiddleware
    {
        public abstract void Handle(IHttpRequest request, IHttpResponse response);
    }
}
