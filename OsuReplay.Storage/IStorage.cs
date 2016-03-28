using System.IO;

namespace OsuReplay.Storage
{
    public interface IStorage
    {
        void Delete(string key);

        string GetLink(string key);

        void Upload(string key, Stream stream);
    }
}
