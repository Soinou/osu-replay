namespace OsuReplay.Http.Impl
{
    public abstract class LayerBase : ILayer
    {
        public LayerBase()
        {
            method_ = null;
            route_ = null;
        }

        public LayerBase(string method, string pattern)
        {
            method_ = method;
            route_ = new Route(pattern);
        }

        public string Method
        {
            get
            {
                return method_;
            }
        }

        public Route Route
        {
            get
            {
                return route_;
            }
        }

        public abstract void Handle(IRequest request, IResponse response, NextDelegate next);

        private string method_;
        private Route route_;
    }
}
