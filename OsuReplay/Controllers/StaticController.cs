using OsuReplay.Http;

namespace OsuReplay.Controllers
{
    internal class StaticController : IController
    {
        public void Install(IServer server)
        {
            server.Get("/js/(.+)", Handle("public/js/"));
            server.Get("/css/(.+)", Handle("public/css/"));
            server.Get("/fonts/(.+)", Handle("public/fonts/"));
            server.Get("/img/(.+)", Handle("public/img/"));
        }

        private RequestHandlerDelegate Handle(string directory)
        {
            return (request, response, next) =>
            {
                response.SendFile(directory + "/" + request.Parameters[1]);
            };
        }
    }
}
