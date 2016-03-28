using System;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;

namespace OsuReplay.Http
{
    public class HttpClient : IHttpClient, IDisposable
    {
        public HttpClient()
        {
            client_ = new System.Net.Http.HttpClient(new HttpClientHandler()
            {
                AutomaticDecompression = DecompressionMethods.GZip | DecompressionMethods.Deflate
            });
        }

        public void Dispose()
        {
            Dispose(true);
        }

        public async Task<string> Get(string url)
        {
            using (var response = await client_.GetAsync(url))
            {
                if (!response.IsSuccessStatusCode)
                {
                    return null;
                }
                else
                {
                    return await response.Content.ReadAsStringAsync();
                }
            }
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!disposed_)
            {
                if (disposing)
                {
                    client_.Dispose();
                }

                disposed_ = true;
            }
        }

        private System.Net.Http.HttpClient client_;

        private bool disposed_;
    }
}
