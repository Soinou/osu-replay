using OsuReplay.Http;
using System.IO;

namespace OsuReplay.Controllers
{
    public class StaticController : IHttpController
    {
        public void Install(IHttpServer server)
        {
            // Match everything
            server.Get("/(.*)", (request, response) =>
            {
                // Try to find a matching file in the public directory
                var path = "public/" + request.Parameters[1];

                if (File.Exists(path))
                    // And send it
                    response.SendFile(path);
                else
                    // Or send the index
                    response.SendFile("public/index.html");
            });
        }
    }
}
