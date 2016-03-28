using Newtonsoft.Json;
using OsuReplay.Configuration;
using OsuReplay.Http;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace OsuReplay.Osu
{
    public class Api : IApi
    {
        public Api(IConfiguration configuration, IHttpClient client)
        {
            client_ = client;
            api_key_ = configuration.Get<string>("Osu.Api.Key");
        }

        /// <inheritdoc />
        public async Task<IEnumerable<Beatmap>> GetBeatmaps(GameMode mode = GameMode.kStd,
            int? beatmap_id = null, int? beatmapset_id = null, string hash = null,
            int? user_id = null, string username = null, bool converted = true, int limit = 500)
        {
            return await Get<Beatmap>(MakeUrl(mode, beatmap_id, beatmapset_id, hash, user_id,
                username, converted, limit));
        }

        /// <inheritdoc />
        public async Task<IEnumerable<Player>> GetPlayers(GameMode mode = GameMode.kStd,
            int? user_id = null, string username = null, int event_days = 1)
        {
            return await Get<Player>(MakeUrl(mode, user_id, username, event_days));
        }

        private async Task<IEnumerable<T>> Get<T>(string url)
        {
            string json = await client_.Get(url);

            if (json == null)
                return Enumerable.Empty<T>();
            else
            {
                try
                {
                    return JsonConvert.DeserializeObject<IEnumerable<T>>(json);
                }
                catch (JsonSerializationException)
                {
                    return Enumerable.Empty<T>();
                }
            }
        }

        private string MakeUrl(string route, GameMode mode)
        {
            string url = "https://osu.ppy.sh/api/" + route + "?k=" + api_key_;

            switch (mode)
            {
                case GameMode.kStd:
                    url += "&m=0";
                    break;

                case GameMode.kTaiko:
                    url += "&m=1";
                    break;

                case GameMode.kCtb:
                    url += "&m=2";
                    break;

                case GameMode.kMania:
                    url += "&m=3";
                    break;

                default:
                    break;
            }

            return url;
        }

        private string MakeUrl(GameMode mode, int? beatmap_id, int? beatmapset_id,
                            string hash, int? user_id, string username, bool converted, int limit)
        {
            string url = MakeUrl("get_beatmaps", mode);

            if (hash != null)
                url += "&h=" + hash;
            else if (beatmap_id.HasValue)
                url += "&b=" + beatmap_id.Value;
            else if (beatmapset_id.HasValue)
                url += "&s=" + beatmapset_id.Value;
            else if (user_id.HasValue)
                url += "&u=" + user_id.Value + "&type=id";
            else if (username != null)
                url += "&u=" + username + "&type=string";
            else
                url += "&s=41823";

            if (converted)
                url += "&a=1";

            url += "&limit=" + limit;

            return url;
        }

        private string MakeUrl(GameMode mode, int? user_id, string username, int event_days)
        {
            string url = MakeUrl("get_user", mode);

            if (user_id.HasValue)
                url += "&u=" + user_id.Value + "&type=id";
            else if (username != null)
                url += "&u=" + username + "&type=string";
            else
                url += "&u=ciel_de_la_nuit&type=string";

            url += "&event_days=" + event_days;

            return url;
        }

        private string api_key_;
        private IHttpClient client_;
    }
}
