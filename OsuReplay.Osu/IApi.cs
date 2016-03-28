using System.Collections.Generic;
using System.Threading.Tasks;

namespace OsuReplay.Osu
{
    public enum GameMode
    {
        kStd,
        kTaiko,
        kCtb,
        kMania
    }

    public interface IApi
    {
        /// <summary>
        /// Retrieves the list of beatmaps using the given arguments
        ///
        /// Usage:
        ///
        /// Get beatmap with id 1 and not converted
        /// - await GetBeatmaps(beatmap_id: 1, converted: false);
        ///
        /// Get 100 beatmaps of Musty
        /// - await GetBeatmaps(username: "Musty", limit: 100);
        ///
        /// Get default beatmap (The Big Black)
        /// - await GetBeatmaps();
        ///
        /// Does not use beatmap_id/beatmapset_id/hash/user_id/username at the same time, order is as
        /// given. Will try them sequentially and fall back to beatmap_id of The Big Black.
        /// </summary>
        /// <param name="mode">Game mode: Defaults to GameMode.kStd</param>
        /// <param name="beatmap_id">Beatmap id: Defaults to null</param>
        /// <param name="beatmapset_id">Beatmap set id: Defaults to null</param>
        /// <param name="hash">Beatmap md5 hash: Defaults to null</param>
        /// <param name="user_id">User id: Defaults to null</param>
        /// <param name="username">Username: Defaults to null</param>
        /// <param name="converted">If the converted beatmaps should be included: Defaults to true</param>
        /// <param name="limit">Maximum number of beatmaps retrieved: Defaults to 500</param>
        /// <returns>A list of the matching beatmaps</returns>
        Task<IEnumerable<Beatmap>> GetBeatmaps(GameMode mode = GameMode.kStd, int? beatmap_id = null,
            int? beatmapset_id = null, string hash = null, int? user_id = null, string username = null,
            bool converted = true, int limit = 500);

        /// <summary>
        /// Retrieves the list of players using the given arguments
        ///
        /// Usage:
        ///
        /// Get player with user_id 1:
        /// - await GetPlayers(user_id: 1);
        ///
        /// Get player "Musty":
        /// - await GetPlayers(username: "Musty");
        ///
        /// Get player "Ciel De La Nuit":
        /// - await GetPlayers();
        ///
        /// Does not use user_id and username at the same time. Will try to use the user_id then the
        /// username if the user_id is not present and fall back to Ciel De La Nuit as username
        /// </summary>
        /// <param name="mode">Game mode: Defaults to GameMode.kStd</param>
        /// <param name="user_id">User id: Defaults to null</param>
        /// <param name="username">Username: Defaults to null</param>
        /// <param name="event_days">Event days: Defaults to 1</param>
        /// <returns>A list of the matching players</returns>
        Task<IEnumerable<Player>> GetPlayers(GameMode mode = GameMode.kStd, int? user_id = null,
            string username = null, int event_days = 1);
    }

    public static class GameModeExtensions
    {
        public static GameMode Convert(this byte mode)
        {
            switch (mode)
            {
                case 0:
                    return GameMode.kStd;

                case 1:
                    return GameMode.kTaiko;

                case 2:
                    return GameMode.kCtb;

                case 3:
                    return GameMode.kMania;

                default:
                    return GameMode.kStd;
            }
        }
    }

    public class ApiRequest
    {
        public ApiRequest()
        {
            mode = GameMode.kStd;
            user_id = null;
            username = null;
        }

        public GameMode mode
        {
            get;
            set;
        }

        public int? user_id
        {
            get;
            set;
        }

        public string username
        {
            get;
            set;
        }
    }

    public class BeatmapRequest : ApiRequest
    {
        public BeatmapRequest()
        {
            beatmap_id = null;
            beatmapset_id = null;
            converted = true;
            hash = null;
            limit = 500;
        }

        public int? beatmap_id
        {
            get;
            set;
        }

        public int? beatmapset_id
        {
            get;
            set;
        }

        public bool converted
        {
            get;
            set;
        }

        public string hash
        {
            get;
            set;
        }

        public int limit
        {
            get;
            set;
        }
    }

    public class PlayerRequest : ApiRequest
    {
        public PlayerRequest()
        {
            event_days = 1;
        }

        public int event_days
        {
            get;
            set;
        }
    }
}
