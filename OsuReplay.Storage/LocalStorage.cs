using OsuReplay.Configuration;
using OsuReplay.Utils;
using System.IO;

namespace OsuReplay.Storage
{
    internal class LocalStorage : IStorage
    {
        public LocalStorage(IConfiguration configuration)
        {
            directory_ = configuration.Get<string>("Storage.Local.Directory");
        }

        public void Delete(string key)
        {
            File.Delete(directory_ + "/" + key + ".osr");
        }

        public string GetLink(string key)
        {
            return "/" + directory_ + "/" + key + ".osr";
        }

        public void Upload(string key, Stream stream)
        {
            var path = directory_ + "/" + key + ".osr";

            if (File.Exists(path))
                throw new StorageException("File '" + path + "' already exists");

            IO.EnsureDirectory(path);

            using (var writer = new StreamWriter(path))
            {
                stream.CopyTo(writer.BaseStream);
            }
        }

        private string directory_;
    }
}
