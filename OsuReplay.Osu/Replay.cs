using OsuReplay.Utils;
using System.IO;

namespace OsuReplay.Osu
{
    public class Replay
    {
        public Replay()
        { }

        public Replay(string title, string description, Stream stream)
        {
            this.title = title;
            this.description = description;

            using (var reader = new BinaryReader(stream))
            {
                mode = reader.ReadByte();
                version = reader.ReadInt32();
                beatmap = reader.ReadLebString();
                player = reader.ReadLebString();
                hash = reader.ReadLebString();
                n_300 = reader.ReadInt16();
                n_100 = reader.ReadInt16();
                n_50 = reader.ReadInt16();
                gekis = reader.ReadInt16();
                katus = reader.ReadInt16();
                misses = reader.ReadInt16();
                score = reader.ReadInt32();
                combo = reader.ReadInt16();
                perfect = reader.ReadByte();
                mods = reader.ReadInt32();
                reader.ReadLebString();
                timestamp = reader.ReadInt64();
            }
        }

        public string beatmap;
        public int combo;
        public string description;
        public short gekis;
        public string hash;
        public short katus;
        public short misses;
        public byte mode;
        public int mods;
        public short n_100;
        public short n_300;
        public short n_50;
        public byte perfect;
        public string player;
        public int score;
        public long timestamp;
        public string title;
        public int version;
    }
}
