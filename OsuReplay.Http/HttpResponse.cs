using Newtonsoft.Json;
using OsuReplay.Utils;
using System.IO;
using System.Net;

namespace OsuReplay.Http
{
    internal class HttpResponse : IHttpResponse
    {
        public HttpResponse(HttpListenerResponse response)
        {
            response_ = response;
        }

        public void Json<T>(int code, T value)
        {
            Send(code, JsonConvert.SerializeObject(value));
        }

        public void Json<T>(T value)
        {
            Json(200, value);
        }

        public void Send(int code, string message)
        {
            response_.StatusCode = code;
            using (var stream = response_.OutputStream)
            using (var writer = new StreamWriter(stream))
            {
                writer.Write(message);
            }
            if (Sent != null)
                Sent();
        }

        public void Send(string message)
        {
            Send(200, message);
        }

        public void SendFile(int code, string path)
        {
            response_.StatusCode = code;
            response_.ContentType = Mime.Get(Path.GetExtension(path));
            using (var stream = response_.OutputStream)
            {
                File.OpenRead(path).CopyTo(stream);
            }
            if (Sent != null)
                Sent();
        }

        public void SendFile(string path)
        {
            SendFile(200, path);
        }

        public event HttpResponseSentHandler Sent;

        private HttpListenerResponse response_;
    }
}
