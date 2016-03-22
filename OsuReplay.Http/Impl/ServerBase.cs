using System;
using System.Collections.Generic;
using System.Net;

namespace OsuReplay.Http.Impl
{
    public abstract class ServerBase : IServer
    {
        public ServerBase(ushort port)
        {
            listener_ = new HttpListener();

            listener_.Prefixes.Add("http://+:" + port + "/");

            stack_ = new List<ILayer>();
        }

        public void Get(string pattern, RequestHandlerDelegate handler)
        {
            stack_.Add(new Layer("GET", pattern, handler));
        }

        public void Listen()
        {
            while (listener_.IsListening)
            {
                try
                {
                    var context = listener_.GetContext();
                    var request = new RequestBase(context.Request);
                    var response = new ResponseBase(context.Response);
                    var current = 0;
                    NextDelegate next = null;

                    next = () =>
                    {
                        try
                        {
                            var layer = stack_[current];

                            current++;

                            if (current > stack_.Count)
                                throw new Exception("No layer matching '" + request.Uri + "'");

                            // Skip wrong methods
                            if (layer.Method != null && layer.Method != request.Method)
                                next();

                            // Check routes
                            if (layer.Route != null)
                            {
                                var parameters = layer.Route.Match(request.Uri);

                                // Route doesn't match, continue
                                if (parameters == null)
                                    next();
                                else
                                {
                                    request.Parameters = parameters;
                                    layer.Handle(request, response, next);
                                }
                            }
                            else
                            {
                                layer.Handle(request, response, next);
                            }
                        }
                        catch (Exception e)
                        {
                            if (Error != null)
                                Error(e, request, response);
                        }
                    };

                    next();
                }
                catch (ObjectDisposedException)
                { }
                catch (HttpListenerException)
                { }
            }
        }

        public void Post(string pattern, RequestHandlerDelegate handler)
        {
            stack_.Add(new Layer("POST", pattern, handler));
        }

        public void Start()
        {
            OnStart();

            listener_.Start();

            Listen();
        }

        public void Stop()
        {
            listener_.Stop();

            OnStop();
        }

        public void Use(IController controller)
        {
            controller.Install(this);
        }

        public void Use(RequestHandlerDelegate handler)
        {
            stack_.Add(new Layer(handler));
        }

        public void Use(ILayer layer)
        {
            stack_.Add(layer);
        }

        public event ErrorHandlerDelegate Error;

        protected abstract void OnStart();

        protected abstract void OnStop();

        private class Layer : LayerBase
        {
            public Layer(RequestHandlerDelegate handler)
                : base()
            { }

            public Layer(string method, string pattern, RequestHandlerDelegate handler)
                : base(method, pattern)
            {
                handler_ = handler;
            }

            public override void Handle(IRequest request, IResponse response, NextDelegate next)
            {
                handler_(request, response, next);
            }

            private RequestHandlerDelegate handler_;
        }

        private HttpListener listener_;
        private List<ILayer> stack_;
    }
}
