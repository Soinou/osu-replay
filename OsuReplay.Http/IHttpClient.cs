using System.Threading.Tasks;

namespace OsuReplay.Http
{
    public interface IHttpClient
    {
        Task<string> Get(string url);
    }
}
