namespace OsuReplay.Http
{
    public interface IHttpServer
    {
        ushort Port
        {
            get;
            set;
        }

        void Delete(string pattern, HttpRequestHandlerDelegate handler);

        void Get(string pattern, HttpRequestHandlerDelegate handler);

        void Install(IHttpController controller);

        void Post(string pattern, HttpRequestHandlerDelegate handler);

        void Start();

        void Stop();

        void Update(string pattern, HttpRequestHandlerDelegate handler);

        void Use(HttpRequestHandlerDelegate handler);

        void Use(IHttpRequestHandler handler);

        event HttpErrorHandlerDelegate Error;
    }
}
