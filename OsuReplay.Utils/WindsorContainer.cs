using Castle.Facilities.TypedFactory;
using Castle.Windsor.Installer;

namespace OsuReplay.Utils
{
    public class WindsorContainer : Castle.Windsor.WindsorContainer
    {
        public WindsorContainer()
        {
            AddFacility<TypedFactoryFacility>();

            Install(FromAssembly.This());
        }
    }
}
