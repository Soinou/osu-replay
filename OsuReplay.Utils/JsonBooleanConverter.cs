using Newtonsoft.Json;
using System;

namespace OsuReplay.Utils
{
    public class JsonBooleanConverter : JsonConverter
    {
        public override bool CanWrite
        {
            get
            {
                return false;
            }
        }

        public override bool CanConvert(Type type)
        {
            return type == typeof(bool);
        }

        public override object ReadJson(JsonReader reader, Type type, object current,
            JsonSerializer serializer)
        {
            if (reader.TokenType == JsonToken.String)
            {
                switch (reader.Value.ToString().ToLower().Trim())
                {
                    case "true":
                    case "yes":
                    case "y":
                    case "1":
                        return true;

                    case "false":
                    case "no":
                    case "n":
                    case "0":
                        return false;
                }
            }

            return new JsonSerializer().Deserialize(reader, type);
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            throw new NotImplementedException();
        }
    }
}
