using Castle.Facilities.TypedFactory;
using Castle.MicroKernel.Registration;
using Castle.Windsor;
using OsuReplay.Configuration;
using OsuReplay.Http;
using OsuReplay.Log;
using OsuReplay.Osu;
using OsuReplay.Storage;
using OsuReplay.Store;
using OsuReplay.Stores;
using OsuReplay.Utils;

namespace OsuReplay
{
    public class Bootstrapper
    {
        public Bootstrapper(IConfiguration configuration)
        {
            container_ = new WindsorContainer();

            // Register configuration
            container_.RegisterInstance(configuration);

            // Facilities
            container_.AddFacility<TypedFactoryFacility>();

            // Http
            container_.RegisterSingleton<IHttpServer, HttpServer>();
            container_.RegisterSingleton<IHttpClient, HttpClient>();

            // Log
            container_.RegisterSingleton<ILogManager, SimpleLogManager>();

            // Osu
            container_.RegisterSingleton<IApi, Api>();

            // Storage
            container_.RegisterSingleton<IStorage, StorageProxy>();

            // Stores
            container_.RegisterGenericSingleton(typeof(IStore<>), typeof(StoreProxy<>));

            // Stores
            container_.RegisterSingleton<BeatmapStore>();
            container_.RegisterSingleton<PlayerStore>();
            container_.RegisterSingleton<ReplayStore>();

            // Middlewares
            container_.RegisterClasses<IMiddleware>(Classes.FromThisAssembly());

            // Controllers
            container_.RegisterClasses<IHttpController>(Classes.FromThisAssembly());

            // Application
            container_.RegisterSingleton<Application>();
        }

        public T Resolve<T>()
        {
            return container_.Resolve<T>();
        }

        private IWindsorContainer container_;
    }
}
