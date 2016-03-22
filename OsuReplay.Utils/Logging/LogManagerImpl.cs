﻿using System.Collections.Generic;
using System.Timers;

namespace OsuReplay.Utils.Logging
{
    /// <summary>
    /// Represents a log manager
    /// </summary>
    internal class LogManagerImpl : ILogManager
    {
        /// <summary>
        /// Creates a new LogManager
        /// </summary>
        public LogManagerImpl()
        {
            loggers_ = new Dictionary<string, LogImpl>();
            timer_ = new Timer();
            timer_.Interval = 1000;
            timer_.Elapsed += OnTimerElapsed;
            timer_.Start();
        }

        /// <summary>
        /// Frees resources
        /// </summary>
        public void Dispose()
        {
            Dispose(true);
        }

        /// <summary>
        /// Gets the logger with the given name
        /// </summary>
        /// <param name="name">Name of the logger</param>
        /// <returns>The logger</returns>
        public ILog Get(string name)
        {
            LogImpl log = null;

            if (!loggers_.TryGetValue(name, out log))
            {
                log = new LogImpl(name);
                loggers_.Add(name, log);
            }

            return log;
        }

        /// <summary>
        /// Frees resources
        /// </summary>
        /// <param name="disposing">If finalizing</param>
        protected virtual void Dispose(bool disposing)
        {
            if (!disposed_)
            {
                if (disposing)
                {
                    timer_.Stop();

                    foreach (LogImpl log in loggers_.Values)
                        log.Flush();

                    timer_.Dispose();
                }

                disposed_ = true;
            }
        }

        /// <summary>
        /// Called when the timer has elapsed
        /// </summary>
        /// <param name="sender">Sender</param>
        /// <param name="e">Arguments</param>
        protected void OnTimerElapsed(object sender, ElapsedEventArgs e)
        {
            foreach (LogImpl log in loggers_.Values)
                log.Flush();
        }

        /// <summary>
        /// If the resources are already disposed of
        /// </summary>
        protected bool disposed_;

        /// <summary>
        /// Dictionary of loggers
        /// </summary>
        protected Dictionary<string, LogImpl> loggers_;

        /// <summary>
        /// Write timer
        /// </summary>
        protected Timer timer_;
    }
}