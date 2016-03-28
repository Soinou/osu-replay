using OsuReplay.Http;

namespace OsuReplay.Controllers
{
    public class MainController : IHttpController
    {
        public void Install(IHttpServer server)
        {
            server.Get("/ping", (request, response) => response.Send("PONG"));
            server.Get("/teapot", (request, response) => response.Send(418, "I'm a teapot"));
        }
    }
}
