using System;
using System.Collections.Concurrent;

namespace OsuReplay.Utils.Logging
{
    /// <summary>
    /// Implementation of the ILog interface
    /// </summary>
    internal class LogImpl : ILog
    {
        /// <summary>
        /// Creates a new LogImpl
        /// </summary>
        /// <param name="name">Name of the logger</param>
        public LogImpl(string name)
        {
            name_ = name;
            messages_ = new ConcurrentQueue<Message>();
        }

        /// <inheritdoc />
        public void Error(string what, Exception e)
        {
            Output("Error", ConsoleColor.Red, what, e);
        }

        /// <inheritdoc />
        public void Fatal(string what, Exception e)
        {
            Output("Fatal", ConsoleColor.DarkRed, what, e);
        }

        /// <summary>
        /// Flushes the write operations of the logger
        /// </summary>
        public void Flush()
        {
            if (!writing_)
            {
                writing_ = true;

                if (messages_.Count > 0)
                {
                    DateTime date = DateTime.Now;
                    string short_date = date.ToString("yyyy-MM-dd");
                    string long_date = date.ToString("yyyy-MM-ddTHH:mm:ss");
                    string file_name = @"logs\" + name_ + "_" + short_date + ".log";
                    string path = IO.GetDataPath(file_name);

                    while (messages_.Count > 0)
                    {
                        Message message = null;

                        if (messages_.TryDequeue(out message))
                        {
                            string long_message = "[" + long_date + "]" + message;

                            IO.Append(path, long_message + Environment.NewLine);
                            Console.Write("[" + long_date + "][");
                            Console.ForegroundColor = message.color;
                            Console.Write(message.status);
                            Console.ResetColor();
                            Console.WriteLine("]: " + message.what);
                        }
                    }
                }

                writing_ = false;
            }
        }

        /// <inheritdoc />
        public void Info(string what)
        {
            Output("Info", ConsoleColor.Cyan, what, null);
        }

        /// <inheritdoc />
        public void Warning(string what)
        {
            Output("Warning", ConsoleColor.Yellow, what, null);
        }

        /// <summary>
        /// Represents a log message
        /// </summary>
        protected class Message
        {
            /// <summary>
            /// Creates a new Message
            /// </summary>
            /// <param name="status"></param>
            /// <param name="color"></param>
            /// <param name="what"></param>
            /// <param name="e"></param>
            public Message(string status, ConsoleColor color, string what, Exception e)
            {
                this.status = status;
                this.color = color;
                this.what = what;
                this.e = e;
            }

            /// <inheritdoc />
            public override string ToString()
            {
                string value = "[" + status + "]: " + what;

                if (e != null)
                    value += Environment.NewLine + e;

                return value;
            }

            /// <summary>
            /// Message color
            /// </summary>
            public readonly ConsoleColor color;

            /// <summary>
            /// Eventual exception that needs to be logged
            /// </summary>
            public readonly Exception e;

            /// <summary>
            /// Message status
            /// </summary>
            public readonly string status;

            /// <summary>
            /// What the message is
            /// </summary>
            public readonly string what;
        }

        /// <summary>
        /// Outputs the given message to the log file
        /// </summary>
        /// <param name="status">Status</param>
        /// <param name="color">Color</param>
        /// <param name="what">What</param>
        /// <param name="e">Exception</param>
        protected void Output(string status, ConsoleColor color, string what, Exception e)
        {
            messages_.Enqueue(new Message(status, color, what, e));
        }

        /// <summary>
        /// Messages to write
        /// </summary>
        protected ConcurrentQueue<Message> messages_;

        /// <summary>
        /// Logger name
        /// </summary>
        protected string name_;

        /// <summary>
        /// If the logger is currently writing
        /// </summary>
        protected bool writing_;
    }
}
