using OsuReplay.Http;
using OsuReplay.Http.Impl;
using System;

namespace OsuReplay.Middleware
{
    internal class LogMiddleware : LayerBase
    {
        public override void Handle(IRequest request, IResponse response, NextDelegate next)
        {
            Console.WriteLine("Request started: " + request.Uri);

            next();

            Console.WriteLine("Request finished: " + request.Uri);
        }
    }
}
