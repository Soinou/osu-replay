using OsuReplay.Http;
using OsuReplay.Log;
using OsuReplay.Requests;
using OsuReplay.Storage;
using OsuReplay.Store;
using OsuReplay.Stores;
using System;
using System.IO;

namespace OsuReplay.Controllers
{
    public class ReplaysApiController : HttpRestController
    {
        public ReplaysApiController(ILogManager manager, ReplayStore store)
            : base("api/replays")
        {
            log_ = manager.Get("OsuReplay.Replays");
            store_ = store;
        }

        protected override void All(IHttpRequest request, IHttpResponse response)
        {
            throw new NotImplementedException();
        }

        protected override void Delete(string id, IHttpRequest request, IHttpResponse response)
        {
            throw new NotImplementedException();
        }

        protected override async void Find(string id, IHttpRequest request, IHttpResponse response)
        {
            try
            {
                response.Json(200, await store_.Find(id));
            }
            catch (StoreException e)
            {
                log_.Warning(e.Message);
                response.Send(404, "Not Found");
            }
        }

        protected override void Store(IHttpRequest request, IHttpResponse response)
        {
            // Get store request
            var store_request = request.As<StoreReplayRequest>();

            // Validate request

            // Send eventual errors

            // Request is valid, save a new replay
            try
            {
                response.Send(200, store_.Save(store_request));
            }
            // IO Exceptions when reading the replay
            catch (IOException e)
            {
                log_.Error("Unable to read data from the sent replay", e);
                response.Send(422, "Replay data has wrong format");
            }
            // Storage exceptions when uploading to Amazon S3
            catch (StorageException e)
            {
                log_.Error("Storage failed to upload replay", e);
                response.Send(500, "Unexpected error when uploading replay");
            }
            // Store exceptions when sending to Redis
            catch (StoreException e)
            {
                log_.Error("Store failed to save replay", e);
                response.Send(500, "Unexpected error when saving replay");
            }
        }

        protected override void Update(string id, IHttpRequest request, IHttpResponse response)
        {
            throw new NotImplementedException();
        }

        private ILog log_;
        private ReplayStore store_;
    }
}
