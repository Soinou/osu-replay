using Castle.MicroKernel.Registration;
using OsuReplay.Http;
using OsuReplay.Utils;

namespace OsuReplay
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            var container = new WindsorContainer();

            container.Register(Component.For<IServer>().ImplementedBy<Server>().LifeStyle.Singleton);

            var server = container.Resolve<IServer>();

            server.Start();
        }
    }
}
