using System;

namespace OsuReplay.Configuration
{
    public class ConfigurationException : Exception
    {
        public ConfigurationException(string message)
            : base(message)
        { }
    }
}
