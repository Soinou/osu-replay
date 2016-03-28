using Newtonsoft.Json;
using OsuReplay.Utils;
using System.ComponentModel;

namespace OsuReplay.Osu
{
    /// <summary>
    /// Represents an osu! beatmap
    /// </summary>
    public class Beatmap
    {
        [JsonConverter(typeof(JsonBooleanConverter))]
        [JsonProperty(PropertyName = "approved")]
        public bool Approved;

        [JsonProperty(PropertyName = "approved_date")]
        public string approved_date;

        [JsonProperty(PropertyName = "artist")]
        public string artist;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "beatmap_id")]
        public long beatmap_id;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "beatmapset_id")]
        public long beatmapset_id;

        [TypeConverter(typeof(DoubleConverter))]
        [JsonProperty(PropertyName = "bpm")]
        public double bpm;

        [JsonProperty(PropertyName = "creator")]
        public string creator;

        [TypeConverter(typeof(DoubleConverter))]
        [JsonProperty(PropertyName = "diff_approach")]
        public double diff_approach;

        [TypeConverter(typeof(DoubleConverter))]
        [JsonProperty(PropertyName = "diff_drain")]
        public double diff_drain;

        [TypeConverter(typeof(DoubleConverter))]
        [JsonProperty(PropertyName = "diff_overall")]
        public double diff_overall;

        [TypeConverter(typeof(DoubleConverter))]
        [JsonProperty(PropertyName = "diff_size")]
        public double diff_size;

        [TypeConverter(typeof(DoubleConverter))]
        [JsonProperty(PropertyName = "difficultyrating")]
        public double difficultyrating;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "favourite_count")]
        public long favourite_count;

        [JsonProperty(PropertyName = "file_md5")]
        public string file_md5;

        [TypeConverter(typeof(ByteConverter))]
        [JsonProperty(PropertyName = "genre_id")]
        public byte genre_id;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "hit_length")]
        public long hit_length;

        [TypeConverter(typeof(ByteConverter))]
        [JsonProperty(PropertyName = "language_id")]
        public byte language_id;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "max_combo")]
        public long? max_combo;

        [TypeConverter(typeof(ByteConverter))]
        [JsonProperty(PropertyName = "mode")]
        public byte mode;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "passcount")]
        public long passcount;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "playcount")]
        public long playcount;

        [JsonProperty(PropertyName = "source")]
        public string source;

        [JsonProperty(PropertyName = "tags")]
        public string tags;

        [JsonProperty(PropertyName = "title")]
        public string title;

        [TypeConverter(typeof(Int64Converter))]
        [JsonProperty(PropertyName = "total_length")]
        public long total_length;

        [JsonProperty(PropertyName = "version")]
        public string version;
    }
}
