using System.Collections.Generic;

namespace OsuReplay.Utils
{
    public static class DictionaryExtensions
    {
        public static string GetValue(this Dictionary<string, string> dictionary, string key)
        {
            string value = null;
            dictionary.TryGetValue(key, out value);
            return value;
        }
    }
}
