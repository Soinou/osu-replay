using System;

namespace OsuReplay.Store
{
    public class StoreException : Exception
    {
        public StoreException(string message)
            : base(message)
        { }
    }
}
