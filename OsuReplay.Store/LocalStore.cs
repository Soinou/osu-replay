using System.Collections.Generic;

namespace OsuReplay.Store
{
    internal class LocalStore<T> : IStore<T>
    {
        public LocalStore()
        {
            store_ = new Dictionary<string, T>();
        }

        public IEnumerable<T> All()
        {
            return store_.Values;
        }

        public void Delete(string key)
        {
            if (!store_.Remove(key))
                throw new StoreException("Could not delete entry '" + key + "'");
        }

        public T Find(string key)
        {
            var value = default(T);
            if (!store_.TryGetValue(key, out value))
                throw new StoreException("Could not find entry '" + key + "'");
            else
                return value;
        }

        public void Save(string key, T value)
        {
            if (store_.ContainsKey(key))
                throw new StoreException("Entry '" + key + "' already exists in the store");
            else
                store_.Add(key, value);
        }

        public void Update(string key, T value)
        {
            if (!store_.ContainsKey(key))
                throw new StoreException("Entry '" + key + "' does not exist in the store");
            else
                store_[key] = value;
        }

        private Dictionary<string, T> store_;
    }
}
