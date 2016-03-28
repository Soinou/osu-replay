using System;

namespace OsuReplay.Storage
{
    public class StorageException : Exception
    {
        public StorageException(Exception e)
            : base(e.Message, e)
        { }

        public StorageException(string message)
            : base(message)
        { }
    }
}
