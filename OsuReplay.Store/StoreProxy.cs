using OsuReplay.Configuration;
using System.Collections.Generic;

namespace OsuReplay.Store
{
    public class StoreProxy<T> : IStore<T>
    {
        public StoreProxy(IConfiguration configuration)
        {
            if (configuration.Get<bool>("Store.UseRedis"))
                internal_ = new RedisStore<T>(configuration);
            else
                internal_ = new LocalStore<T>();
        }

        public IEnumerable<T> All()
        {
            return internal_.All();
        }

        public void Delete(string key)
        {
            internal_.Delete(key);
        }

        public T Find(string key)
        {
            return internal_.Find(key);
        }

        public void Save(string key, T value)
        {
            internal_.Save(key, value);
        }

        public void Update(string key, T value)
        {
            internal_.Update(key, value);
        }

        private readonly IStore<T> internal_;
    }
}
