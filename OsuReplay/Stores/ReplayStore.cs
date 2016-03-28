using OsuReplay.Osu;
using OsuReplay.Requests;
using OsuReplay.Storage;
using OsuReplay.Store;
using OsuReplay.Utils;
using System;
using System.IO;
using System.Threading.Tasks;

namespace OsuReplay.Stores
{
    public class ReplayStore
    {
        public ReplayStore(BeatmapStore beatmaps, PlayerStore players, IStorage storage,
            IStore<Osu.Replay> store)
        {
            beatmaps_ = beatmaps;
            players_ = players;
            storage_ = storage;
            store_ = store;
        }

        public async Task<Models.Replay> Find(string key)
        {
            var replay = store_.Find(key);
            var mode = replay.mode.Convert();
            var beatmap = await beatmaps_.Find(mode, replay.beatmap);
            var player = await players_.Find(mode, replay.player);

            return new Models.Replay(replay, beatmap, player, storage_.GetLink(key));
        }

        public string Save(StoreReplayRequest request)
        {
            var key = ShortId.Generate();
            var title = request.title;
            var description = request.description;
            var file = request.file;

            // Decode the file content into a stream
            var bytes = Convert.FromBase64String(file.Substring(file.IndexOf(",") + 1));
            using (var stream = new MemoryStream(bytes))
            {
                // Upload the replay
                storage_.Upload(key, stream);

                // Reset the stream position
                stream.Position = 0;

                // Create a new replay and save it to our store
                var replay = new Osu.Replay(title, description, stream);
                store_.Save(key, replay);
            }

            return key;
        }

        private BeatmapStore beatmaps_;
        private PlayerStore players_;
        private IStorage storage_;
        private IStore<Osu.Replay> store_;
    }
}
