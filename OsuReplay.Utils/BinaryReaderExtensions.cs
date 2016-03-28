using System.IO;

namespace OsuReplay.Utils
{
    public static class BinaryReaderExtensions
    {
        public static string ReadLebString(this BinaryReader reader)
        {
            return reader.ReadByte() != 0 ? reader.ReadString() : "";
        }
    }
}
