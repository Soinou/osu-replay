using OsuReplay.Configuration;
using System.IO;

namespace OsuReplay.Storage
{
    public class StorageProxy : IStorage
    {
        public StorageProxy(IConfiguration configuration)
        {
            if (configuration.Get<bool>("Storage.UseS3"))
                internal_ = new S3Storage(configuration);
            else
                internal_ = new LocalStorage(configuration);
        }

        public void Delete(string key)
        {
            internal_.Delete(key);
        }

        public string GetLink(string key)
        {
            return internal_.GetLink(key);
        }

        public void Upload(string key, Stream stream)
        {
            internal_.Upload(key, stream);
        }

        /// <summary>
        /// The internal storage
        /// </summary>
        private IStorage internal_;
    }
}
