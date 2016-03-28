using System;
using System.IO;
using System.Threading;
using System.Threading.Tasks;

namespace OsuReplay.Utils
{
    /// <summary>
    /// Collection of IO operations helper
    /// </summary>
    public static class IO
    {
        /// <summary>
        /// Will append the given content to the given file
        /// </summary>
        /// <param name="path">Path of the file to append to</param>
        /// <param name="content">Content to append</param>
        public static void Append(string path, string content)
        {
            EnsureDirectory(path);

            using (StreamWriter writer = new StreamWriter(path, true))
            {
                writer.Write(content);
            }
        }

        /// <summary>
        /// Ensures the directory of the given file exists and will create it if not
        /// </summary>
        /// <param name="path">File to check directory of</param>
        public static void EnsureDirectory(string path)
        {
            if (path.IndexOf("/") != -1)
            {
                DirectoryInfo directory = new DirectoryInfo(Path.GetDirectoryName(path));

                if (!directory.Exists)
                {
                    directory.Create();
                }
            }
        }

        /// <summary>
        /// Checks if a file is available
        /// </summary>
        /// <param name="path">File path</param>
        /// <returns>If the file is available</returns>
        public static bool IsAvailable(string path)
        {
            var info = new FileInfo(path);

            try
            {
                using (FileStream stream = info.Open(FileMode.Open))
                {
                    return true;
                }
            }
            catch (IOException)
            {
                return false;
            }
        }

        /// <summary>
        /// Same thing as the other Move() but with a default on_progress handler doing nothing
        /// </summary>
        /// <param name="source">Source file</param>
        /// <param name="destination">Destination file</param>
        public static void Move(string source, string destination)
        {
            Move(source, destination, (progress) => { });
        }

        /// <summary>
        /// Move a file from the given source to the given destination. Will report progress using
        /// the given action.
        ///
        /// Will move the file if the source and the destination are on the same drive, and copy then
        /// delete if they are not on the same drive.
        ///
        /// Will also delete destination if there is already one
        /// </summary>
        /// <param name="source">Source file</param>
        /// <param name="destination">Destination file</param>
        /// <param name="on_progress">Action called every progress change</param>
        public static void Move(string source, string destination, Action<byte> on_progress)
        {
            EnsureDirectory(destination);

            FileInfo source_info = new FileInfo(source);
            FileInfo destination_info = new FileInfo(destination);

            // First, delete destination if there is already one
            if (destination_info.Exists)
                destination_info.Delete();

            // Wait for the file to be available before moving/copying it
            while (!IsAvailable(source))
                Thread.Sleep(kAvailabilityCheckTime);

            // Same drive
            if (Path.GetPathRoot(source_info.FullName)
                == Path.GetPathRoot(destination_info.FullName))
            {
                // Move
                on_progress(0);

                source_info.MoveTo(destination_info.FullName);

                on_progress(100);
            }
            // Not the same drive
            else
            {
                // Copy
                byte[][] buffers =
                {
                    new byte[kBufferSize],
                    new byte[kBufferSize]
                };

                bool swap = false;
                byte progress = 0;
                int read = 0;
                long len = source_info.Length;
                float flen = len;
                Task task = null;

                using (var reader = source_info.OpenRead())
                using (var writer = destination_info.OpenWrite())
                {
                    for (long size = 0; size < len; size += read)
                    {
                        byte new_progress = (byte)((size / flen) * 100);

                        if (new_progress != progress)
                        {
                            progress = new_progress;
                            on_progress(progress);
                        }

                        read = reader.Read(swap ? buffers[0] : buffers[1], 0, kBufferSize);

                        if (task != null)
                            task.Wait();

                        task = writer.WriteAsync(swap ? buffers[0] : buffers[1], 0, read);

                        swap = !swap;
                    }

                    writer.Write(swap ? buffers[1] : buffers[0], 0, read);
                }

                // Wait for the file to be available before deleting it
                while (!IsAvailable(source))
                    Thread.Sleep(kAvailabilityCheckTime);

                source_info.Delete();
            }
        }

        /// <summary>
        /// Reads the content of the given file
        /// </summary>
        /// <param name="path">Path of the file to read from</param>
        /// <returns>Content of the read file</returns>
        public static string Read(string path)
        {
            EnsureDirectory(path);

            using (FileStream stream = new FileStream(path, FileMode.OpenOrCreate))
            {
                using (StreamReader reader = new StreamReader(stream))
                {
                    return reader.ReadToEnd();
                }
            }
        }

        /// <summary>
        /// Writes the given content to the given file
        /// </summary>
        /// <param name="path">Path of the file to write to</param>
        /// <param name="content">Content to write</param>
        public static void Write(string path, string content)
        {
            EnsureDirectory(path);

            using (StreamWriter writer = new StreamWriter(path, false))
            {
                writer.Write(content);
            }
        }

        /// <summary>
        /// Time between file availability checks
        /// </summary>
        private const int kAvailabilityCheckTime = 1000;

        /// <summary>
        /// Copy buffer size
        /// </summary>
        private const int kBufferSize = 1024 * 1024;
    }
}
