using System;
using System.Collections.Generic;
using System.Net;
using System.Threading;
using System.Threading.Tasks;

namespace OsuReplay.Http
{
    public class HttpServer : IHttpServer
    {
        public HttpServer()
        {
            listener_ = new HttpListener();
            middlewares_ = new List<IHttpRequestHandler>();
            Port = 80;
            routes_ = new List<HttpRouteRequestHandler>();
            thread_ = new Thread(Run);
        }

        public ushort Port
        {
            get
            {
                return port_;
            }
            set
            {
                port_ = value;
                listener_.Prefixes.Clear();
                listener_.Prefixes.Add("http://+:" + port_ + "/");
            }
        }

        public void Delete(string pattern, HttpRequestHandlerDelegate handler)
        {
            routes_.Add(new HttpRouteRequestHandler("DELETE", pattern, handler));
        }

        public void Get(string pattern, HttpRequestHandlerDelegate handler)
        {
            routes_.Add(new HttpRouteRequestHandler("GET", pattern, handler));
        }

        public void Install(IHttpController controller)
        {
            controller.Install(this);
        }

        public void Listen()
        {
            var context = listener_.GetContext();

            Task.Run(() =>
            {
                var request = new HttpRequest(context.Request);
                var response = new HttpResponse(context.Response);

                try
                {
                    foreach (var middleware in middlewares_)
                    {
                        middleware.Handle(request, response);
                    }

                    foreach (var route in routes_)
                    {
                        if (route.CanHandle(request))
                        {
                            request.SetParameters(route.Parameters);
                            route.Handle(request, response);
                            break;
                        }
                    }
                }
                catch (Exception e)
                {
                    if (Error != null)
                        Error(e, request, response);
                }
            });
        }

        public void Post(string pattern, HttpRequestHandlerDelegate handler)
        {
            routes_.Add(new HttpRouteRequestHandler("POST", pattern, handler));
        }

        public void Run()
        {
            while (running_)
            {
                try
                {
                    Listen();
                }
                catch (ObjectDisposedException)
                { }
                catch (HttpListenerException)
                { }
            }
        }

        public void StartListening()
        {
            if (routes_.Count <= 0)
                throw new InvalidOperationException("Can't start an HttpServer without routes");

            if (!running_)
            {
                running_ = true;
                listener_.Start();
                thread_.Start();
            }
        }

        public void StopListening()
        {
            if (running_)
            {
                running_ = false;
                listener_.Stop();
                thread_.Join();
            }
        }

        public void Update(string pattern, HttpRequestHandlerDelegate handler)
        {
            routes_.Add(new HttpRouteRequestHandler("UPDATE", pattern, handler));
        }

        public void Use(HttpRequestHandlerDelegate handler)
        {
            middlewares_.Add(new HttpMiddlewareRequestHandler(handler));
        }

        public void Use(IHttpRequestHandler handler)
        {
            middlewares_.Add(handler);
        }

        public event HttpErrorHandlerDelegate Error;

        private HttpListener listener_;
        private List<IHttpRequestHandler> middlewares_;
        private ushort port_;
        private List<HttpRouteRequestHandler> routes_;
        private bool running_;
        private Thread thread_;
    }
}
