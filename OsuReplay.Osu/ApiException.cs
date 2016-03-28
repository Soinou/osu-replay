using System;

namespace OsuReplay.Osu
{
    public class ApiException : Exception
    {
        public ApiException(string message)
            : base(message)
        { }
    }
}
