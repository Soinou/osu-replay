using Mono.Unix;
using Mono.Unix.Native;
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
            log_.Info("Server starting on port " + server_.Port);

            server_.StartListening();

            if (Type.GetType("Mono.Runtime") != null)
            {
                UnixSignal.WaitAny(new[] {
                    new UnixSignal(Signum.SIGINT),
                    new UnixSignal(Signum.SIGTERM),
                    new UnixSignal(Signum.SIGQUIT),
                    new UnixSignal(Signum.SIGHUP)
                });
            }
            else
            {
                Console.ReadKey();
            }

            Stop();
        }

        public void Stop()
        {
            server_.StopListening();
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
