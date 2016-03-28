using OsuReplay.Osu;

namespace OsuReplay.Models
{
    public class Replay
    {
        public Replay(Osu.Replay replay, Beatmap beatmap, Player player, string link)
        {
            combo = replay.combo;
            description = replay.description;
            gekis = replay.gekis;
            hash = replay.hash;
            katus = replay.katus;
            misses = replay.misses;
            mode = replay.mode;
            mods = replay.mods;
            n_100 = replay.n_100;
            n_300 = replay.n_300;
            n_50 = replay.n_50;
            perfect = replay.perfect;
            score = replay.score;
            this.beatmap = beatmap;
            this.link = link;
            this.player = player;
            timestamp = replay.timestamp;
            title = replay.title;
            version = replay.version;
        }

        public Beatmap beatmap;
        public int combo;
        public string description;
        public short gekis;
        public string hash;
        public short katus;
        public string link;
        public short misses;
        public byte mode;
        public int mods;
        public short n_100;
        public short n_300;
        public short n_50;
        public byte perfect;
        public Player player;
        public int score;
        public long timestamp;
        public string title;
        public int version;
    }
}
