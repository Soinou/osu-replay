using Castle.Facilities.TypedFactory;
using Castle.MicroKernel.Registration;
using Castle.Windsor;
using System;

namespace OsuReplay.Utils
{
    public static class WindsorExtensions
    {
        public static void RegisterClasses<T>(this IWindsorContainer container, FromAssemblyDescriptor descriptor)
        {
            container.Register(descriptor.BasedOn<T>().LifestyleTransient());
        }

        public static void RegisterFactory<F, C>(this IWindsorContainer container)
            where F : class
            where C : class
        {
            container.Register(Component.For<F>().AsFactory().LifeStyle.Singleton);
            container.Register(Component.For<C>().LifeStyle.Transient);
        }

        public static void RegisterGenericSingleton(this IWindsorContainer container, Type generic,
            Type implementation)
        {
            container.Register(Component.For(generic).ImplementedBy(implementation)
                .LifeStyle.Singleton);
        }

        public static void RegisterInstance<T>(this IWindsorContainer container, T instance)
                                    where T : class
        {
            container.Register(Component.For<T>().Instance(instance).LifeStyle.Singleton);
        }

        public static void RegisterSingleton<T>(this IWindsorContainer container)
            where T : class
        {
            container.Register(Component.For<T>().LifeStyle.Singleton);
        }

        public static void RegisterSingleton<T, I>(this IWindsorContainer container)
            where T : class
            where I : T
        {
            container.Register(Component.For<T>().ImplementedBy<I>().LifeStyle.Singleton);
        }

        public static void RegisterTransient<T>(this IWindsorContainer container)
            where T : class
        {
            container.Register(Component.For<T>().LifeStyle.Transient);
        }

        public static void RegisterTransient<T, I>(this IWindsorContainer container)
            where T : class
            where I : T
        {
            container.Register(Component.For<T>().ImplementedBy<I>().LifeStyle.Transient);
        }
    }
}
