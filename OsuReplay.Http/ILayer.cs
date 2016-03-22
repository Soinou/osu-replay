namespace OsuReplay.Http
{
    public interface ILayer
    {
        string Method
        {
            get;
        }

        Route Route
        {
            get;
        }

        void Handle(IRequest request, IResponse response, NextDelegate next);
    }
}
