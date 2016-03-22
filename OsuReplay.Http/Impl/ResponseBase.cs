using Newtonsoft.Json;
using System.IO;
using System.Net;

namespace OsuReplay.Http.Impl
{
    internal class ResponseBase : IResponse
    {
        public ResponseBase(HttpListenerResponse response)
        {
            response_ = response;
        }

        public void Send(int code, string message)
        {
            response_.StatusCode = code;
            using (var stream = response_.OutputStream)
            using (var writer = new StreamWriter(stream))
            {
                writer.Write(message);
            }
        }

        public void Send(string message)
        {
            Send(200, message);
        }

        public void Send<T>(T value)
        {
            Send(200, value);
        }

        public void Send<T>(int code, T value)
        {
            Send(code, JsonConvert.SerializeObject(value));
        }

        public void SendFile(int code, string path)
        {
            response_.StatusCode = code;
            using (var stream = response_.OutputStream)
            {
                File.OpenRead(path).CopyTo(stream);
            }
        }

        public void SendFile(string path)
        {
            SendFile(200, path);
        }

        private HttpListenerResponse response_;
    }
}
