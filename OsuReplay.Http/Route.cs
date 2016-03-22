using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace OsuReplay.Http
{
    public class Route
    {
        public Route(string pattern)
        {
            regex_ = new Regex(pattern, RegexOptions.Compiled);
        }

        public List<string> Match(string uri)
        {
            List<string> parameters = null;
            var match = regex_.Match(uri);

            if (match.Success)
            {
                parameters = new List<string>();

                for (int i = 0; i < match.Groups.Count; i++)
                {
                    parameters.Add(match.Groups[i].Value);
                }
            }

            return parameters;
        }

        private Regex regex_;
    }
}
