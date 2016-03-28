namespace OsuReplay.Configuration
{
    public interface IConfiguration
    {
        T Get<T>(string key);
    }
}
