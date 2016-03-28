using OsuReplay.Osu;
using OsuReplay.Store;
using System.Linq;
using System.Threading.Tasks;

namespace OsuReplay.Stores
{
    public class BeatmapStore
    {
        public BeatmapStore(IApi api, IStore<Beatmap> store)
        {
            api_ = api;
            store_ = store;
        }

        public async Task<Beatmap> Find(GameMode mode, string hash)
        {
            try
            {
                return store_.Find(hash);
            }
            catch (StoreException)
            {
                var beatmap = (await api_.GetBeatmaps(mode: mode, hash: hash)).FirstOrDefault();

                store_.Save(hash, beatmap);

                return beatmap;
            }
        }

        private IApi api_;
        private IStore<Beatmap> store_;
    }
}
