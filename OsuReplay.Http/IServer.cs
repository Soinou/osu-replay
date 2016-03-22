using System;

namespace OsuReplay.Http
{
    public interface IServer
    {
        void Get(string pattern, RequestHandlerDelegate handler);

        void Post(string pattern, RequestHandlerDelegate handler);

        void Start();

        void Stop();

        void Use(IController controller);

        void Use(RequestHandlerDelegate handler);

        void Use(ILayer layer);

        event ErrorHandlerDelegate Error;
    }

    public delegate void ErrorHandlerDelegate(Exception error, IRequest request, IResponse response);

    public delegate void NextDelegate();

    public delegate void RequestHandlerDelegate(IRequest request, IResponse response, NextDelegate next);
}
