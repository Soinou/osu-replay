using OsuReplay.Configuration;
using OsuReplay.Http;
using OsuReplay.Log;
using System;

namespace OsuReplay
{
    internal class Application
    {
        public Application(IConfiguration configuration, ILogManager manager, IHttpServer server)
        {
            log_ = manager.Get("OsuReplay.Application");
            server_ = server;
            server_.Port = (ushort)configuration.Get<int>("Server.Port");
            server_.Error += (error, request, response) =>
            {
                log_.Fatal("Uncaught exception", error);
                response.Send(500, "Unexpected server error");
                Stop();
            };
        }

        public void Install(IHttpController controller)
        {
            server_.Install(controller);
        }

        public void Start()
        {
            Console.CancelKeyPress += (object sender, ConsoleCancelEventArgs e) =>
            {
                e.Cancel = true;
                log_.Info("Server interrupted, stopping");
                server_.Stop();
            };

            log_.Info("Server starting on port " + server_.Port);

            server_.Start();
        }

        public void Stop()
        {
            server_.Stop();
            log_.Info("Server stopped");
        }

        public void Use(IMiddleware middleware)
        {
            server_.Use(middleware);
        }

        private ILog log_;
        private IHttpServer server_;
    }
}
