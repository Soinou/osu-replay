using OsuReplay.Http;
using OsuReplay.Models;

namespace OsuReplay.Controllers
{
    public class MainController : IController
    {
        public void Install(IServer server)
        {
            server.Get("/object", (request, response, next) =>
            {
                var replay = new Replay("Something", "Something else");

                response.Send(replay);
            });
            server.Get("/ping", (request, response, next) => response.Send("PONG"));
            server.Get("/teapot", (request, response, next) => response.Send(418, "I'm a teapot"));
            server.Get("/.+", (request, response, next) => response.SendFile("public/index.html"));
        }
    }
}
