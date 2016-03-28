using System;

namespace OsuReplay.Log
{
    /// <summary>
    /// Represents a logging manager
    /// </summary>
    public interface ILogManager : IDisposable
    {
        /// <summary>
        /// Gets the logger with the given name
        ///
        /// Name is used for the filename as the following:
        ///
        /// "{data_folder}\logs\{name}_{date}.log"
        /// </summary>
        /// <param name="name">Name of the logger</param>
        /// <returns>Logger with this name</returns>
        ILog Get(string name);
    }
}
