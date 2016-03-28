using Newtonsoft.Json;
using System.ComponentModel;

namespace OsuReplay.Osu
{
    /// <summary>
    /// Represents an osu! player
    ///
    /// Events are not stored since they are not used
    /// </summary>
    public struct Player
    {
        [TypeConverter(typeof(DoubleConverter))]
        [JsonProperty(PropertyName = "accuracy")]
        public double Accuracy;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "count100")]
        public long Count100;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "count300")]
        public long Count300;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "count50")]
        public long Count50;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "count_rank_a")]
        public long CountRankA;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "count_rank_s")]
        public long CountRankS;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "count_rank_ss")]
        public long CountRankSS;

        [JsonProperty(PropertyName = "country")]
        public string Country;

        [TypeConverter(typeof(DoubleConverter))]
        [JsonProperty(PropertyName = "level")]
        public double Level;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "playcount")]
        public long Playcount;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "pp_country_rank")]
        public long PpCountryRank;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "pp_rank")]
        public long PpRank;

        [TypeConverter(typeof(DoubleConverter))]
        [JsonProperty(PropertyName = "pp_raw")]
        public double PpRaw;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "ranked_score")]
        public long RankedScore;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "total_score")]
        public long TotalScore;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "user_id")]
        public long UserId;

        [JsonProperty(PropertyName = "username")]
        public string Username;
    }
}
