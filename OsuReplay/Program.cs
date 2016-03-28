using OsuReplay.Configuration;
using OsuReplay.Controllers;
using OsuReplay.Log;
using OsuReplay.Middleware;
using System;

namespace OsuReplay
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            try
            {
                var configuration = new XmlConfiguration();
                var bootstrapper = new Bootstrapper(configuration);
                var log = bootstrapper.Resolve<ILogManager>().Get("OsuReplay.Application");

                try
                {
                    var application = bootstrapper.Resolve<Application>();

                    application.Use(bootstrapper.Resolve<LogMiddleware>());

                    application.Install(bootstrapper.Resolve<MainController>());
                    application.Install(bootstrapper.Resolve<ReplaysApiController>());

                    if (configuration.Get<bool>("Server.UseStatic"))
                    {
                        application.Install(bootstrapper.Resolve<StaticController>());
                    }

                    application.Start();
                }
                // Log the exceptions we can log
                catch (Exception e)
                {
                    while (e.InnerException != null)
                        e = e.InnerException;

                    log.Fatal("Unexpected application error", e);
                }
            }
            catch (Exception e)
            {
                while (e.InnerException != null)
                    e = e.InnerException;

                Console.WriteLine("Unexpected application exception");
                Console.WriteLine(e);
            }
        }
    }
}
