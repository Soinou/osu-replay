namespace OsuReplay.Http
{
    public interface IHttpRequestHandler
    {
        void Handle(IHttpRequest request, IHttpResponse response);
    }
}
