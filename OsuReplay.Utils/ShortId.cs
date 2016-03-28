using System;
using System.Text;

namespace OsuReplay.Utils
{
    public class ShortId
    {
        public ShortId()
        {
            characters_ = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz".ToCharArray();
            random_ = new Random();
        }

        public static ShortId Instance
        {
            get
            {
                if (instance_ == null)
                {
                    instance_ = new ShortId();
                }

                return instance_;
            }
        }

        public static string Generate()
        {
            return Instance.New(kIdLength);
        }

        private string New(int length)
        {
            var builder = new StringBuilder(length);

            for (int i = 0; i < length; i++)
                builder.Append(characters_[random_.Next(62)]);

            return builder.ToString();
        }

        private const int kIdLength = 14;
        private static ShortId instance_;
        private char[] characters_;
        private Random random_;
    }
}
