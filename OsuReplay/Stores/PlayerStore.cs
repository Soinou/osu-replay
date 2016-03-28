using OsuReplay.Osu;
using OsuReplay.Store;
using System.Linq;
using System.Threading.Tasks;

namespace OsuReplay.Stores
{
    public class PlayerStore
    {
        public PlayerStore(IApi api, IStore<Player> store)
        {
            api_ = api;
            store_ = store;
        }

        public async Task<Player> Find(GameMode mode, string username)
        {
            try
            {
                return store_.Find(username);
            }
            catch (StoreException)
            {
                var player = (await api_.GetPlayers(mode: mode, username: username)).FirstOrDefault();

                store_.Save(username, player);

                return player;
            }
        }

        private IApi api_;
        private IStore<Player> store_;
    }
}
