using Newtonsoft.Json;
using OsuReplay.Configuration;
using StackExchange.Redis;
using System.Collections.Generic;
using System.Linq;

namespace OsuReplay.Store
{
    internal class RedisStore<T> : IStore<T>
    {
        public RedisStore(IConfiguration configuration)
        {
            if (connection_ == null)
            {
                Initialize(configuration);
            }

            client_ = connection_.GetDatabase(database_);
            name_ = typeof(T).Name.ToLower() + "s";
        }

        public IEnumerable<T> All()
        {
            var values = client_.HashGetAll(name_);

            if (values.Length == 0)
                return Enumerable.Empty<T>();

            return values.Select(hash => JsonConvert.DeserializeObject<T>(hash.Value));
        }

        public void Delete(string key)
        {
            if (!client_.HashDelete(name_, key))
                throw new StoreException("Could not delete entry '" + name_ + ":" + key + "'");
        }

        public T Find(string key)
        {
            var json = client_.HashGet(name_, key);

            if (string.IsNullOrEmpty(json))
                throw new StoreException("Entry with key '" + name_ + ":" + key + "' does not exist");

            return JsonConvert.DeserializeObject<T>(json);
        }

        public void Save(string key, T value)
        {
            client_.HashSet(name_, key, JsonConvert.SerializeObject(value));
        }

        public void Update(string key, T value)
        {
            client_.HashSet(name_, key, JsonConvert.SerializeObject(value));
        }

        private static void Initialize(IConfiguration configuration)
        {
            var host = configuration.Get<string>("Store.Redis.Host");
            var port = configuration.Get<int>("Store.Redis.Port");
            var url = string.Format("{0}:{1}", host, port);

            database_ = configuration.Get<int>("Store.Redis.Database");
            connection_ = ConnectionMultiplexer.Connect(url);
        }

        private static ConnectionMultiplexer connection_;
        private static int database_;
        private IDatabase client_;
        private string name_;
    }
}
