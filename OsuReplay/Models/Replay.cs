namespace OsuReplay.Models
{
    internal class Replay
    {
        public Replay(string title, string description)
        {
            title_ = title;
            description_ = description;
        }

        public string description
        {
            get
            {
                return description_;
            }
        }

        public string title
        {
            get
            {
                return title_;
            }
        }

        private string description_;
        private string title_;
    }
}
