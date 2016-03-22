using System;

namespace OsuReplay.Utils.Logging
{
    /// <summary>
    /// Represents a logger interface
    /// </summary>
    public interface ILog
    {
        /// <summary>
        /// Error
        /// </summary>
        /// <param name="what">What</param>
        /// <param name="e">Error</param>
        void Error(string what, Exception e);

        /// <summary>
        /// Fatal
        /// </summary>
        /// <param name="what">What</param>
        /// <param name="e">Error</param>
        void Fatal(string what, Exception e);

        /// <summary>
        /// Info
        /// </summary>
        /// <param name="what">What</param>
        void Info(string what);

        /// <summary>
        /// Warning
        /// </summary>
        /// <param name="what">What</param>
        void Warning(string what);
    }
}
