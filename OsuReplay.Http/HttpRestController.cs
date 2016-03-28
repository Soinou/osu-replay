namespace OsuReplay.Http
{
    public abstract class HttpRestController : IHttpController
    {
        public HttpRestController(string name)
        {
            name_ = name;
        }

        public void Install(IHttpServer server)
        {
            server.Get("/" + name_ + "/(.+)", (request, response) =>
            {
                Find(request.Parameters[1], request, response);
            });

            server.Update("/" + name_ + "/(.+)", (request, response) =>
            {
                Update(request.Parameters[1], request, response);
            });

            server.Delete("/" + name_ + "/(.+)", (request, response) =>
            {
                Delete(request.Parameters[1], request, response);
            });

            server.Get("/" + name_, All);

            server.Post("/" + name_, Store);
        }

        protected abstract void All(IHttpRequest request, IHttpResponse response);

        protected abstract void Delete(string id, IHttpRequest request, IHttpResponse response);

        protected abstract void Find(string id, IHttpRequest request, IHttpResponse response);

        protected abstract void Store(IHttpRequest request, IHttpResponse response);

        protected abstract void Update(string id, IHttpRequest request, IHttpResponse response);

        private string name_;
    }
}
