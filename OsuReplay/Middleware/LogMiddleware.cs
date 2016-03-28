using OsuReplay.Http;
using OsuReplay.Log;
using System.Diagnostics;

namespace OsuReplay.Middleware
{
    public class LogMiddleware : HttpMiddlewareBase
    {
        public LogMiddleware(ILogManager manager)
        {
            log_ = manager.Get("OsuReplay.Http");
        }

        public override void Handle(IHttpRequest request, IHttpResponse response)
        {
            var watch = new Stopwatch();

            response.Sent += () =>
            {
                watch.Stop();

                log_.Info(request.Method + " " + request.Uri + " " + watch.Elapsed.Milliseconds + "ms");
            };

            watch.Start();
        }

        private ILog log_;
    }
}
