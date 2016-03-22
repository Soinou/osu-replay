using Castle.Core;
using OsuReplay.Controllers;
using OsuReplay.Http.Impl;
using OsuReplay.Middleware;
using OsuReplay.Utils.Logging;
using System;

namespace OsuReplay
{
    internal class Server : ServerBase, IInitializable
    {
        public Server()
            : base(25001)
        { }

        public ILog Log
        {
            get;
            private set;
        }

        public ILogManager LogManager
        {
            get;
            set;
        }

        public void Initialize()
        {
            Log = LogManager.Get("OsuReplay");

            Error += (error, request, response) =>
            {
                try
                {
                    Log.Error("Uncaught error", error);
                    response.SendFile("public/error.html");
                }
                catch (Exception e)
                {
                    Log.Fatal("Fatal error when trying to send error page", e);
                    Stop();
                }
            };

            Use(new StaticController());
            Use(new LogMiddleware());
            Use(new MainController());
        }

        protected override void OnStart()
        {
            Console.CancelKeyPress += (object sender, ConsoleCancelEventArgs e) =>
            {
                Log.Info("Server interrupted, stopping");
                Stop();
            };

            Log.Info("Server starting on port 80");
        }

        protected override void OnStop()
        {
            Log.Info("Server stopped");
            LogManager.Dispose();
        }
    }
}
