using Castle.MicroKernel.Registration;
using Castle.MicroKernel.SubSystems.Configuration;
using Castle.Windsor;

namespace OsuReplay.Utils.Logging
{
    public class LoggingInstaller : IWindsorInstaller
    {
        public void Install(IWindsorContainer container, IConfigurationStore store)
        {
            container.Register(Component.For<ILogManager>()
                .ImplementedBy<LogManagerImpl>()
                .LifeStyle.Singleton);
        }
    }
}
