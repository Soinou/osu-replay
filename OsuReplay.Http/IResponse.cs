namespace OsuReplay.Http
{
    public interface IResponse
    {
        void Send(int code, string message);

        void Send(string message);

        void Send<T>(int code, T value);

        void Send<T>(T value);

        void SendFile(int code, string path);

        void SendFile(string path);
    }
}
