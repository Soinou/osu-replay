namespace OsuReplay.Http
{
    public interface IHttpResponse
    {
        void Json<T>(int code, T value);

        void Json<T>(T value);

        void Send(int code, string message);

        void Send(string message);

        void SendFile(int code, string path);

        void SendFile(string path);

        event HttpResponseSentHandler Sent;
    }
}
