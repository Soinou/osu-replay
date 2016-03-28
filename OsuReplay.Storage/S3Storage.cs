using Amazon;
using Amazon.Runtime;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.S3.Transfer;
using OsuReplay.Configuration;
using System.IO;

namespace OsuReplay.Storage
{
    internal class S3Storage : IStorage
    {
        public S3Storage(IConfiguration configuration)
        {
            var access = configuration.Get<string>("Storage.S3.Access");
            var secret = configuration.Get<string>("Storage.S3.Secret");
            var region = configuration.Get<string>("Storage.S3.Region");
            bucket_ = configuration.Get<string>("Storage.S3.Bucket");
            var credentials = new BasicAWSCredentials(access, secret);

            client_ = AWSClientFactory.CreateAmazonS3Client(credentials,
                RegionEndpoint.GetBySystemName(region));
        }

        public void Delete(string key)
        {
            try
            {
                var request = new DeleteObjectRequest();

                request.BucketName = bucket_;
                request.Key = key + ".osr";

                client_.DeleteObject(request);
            }
            catch (AmazonS3Exception e)
            {
                throw new StorageException(e);
            }
        }

        public string GetLink(string key)
        {
            return "https://" + bucket_ + ".s3.amazonaws.com/" + key + ".osr";
        }

        public void Upload(string key, Stream stream)
        {
            try
            {
                using (var input = new MemoryStream())
                {
                    stream.CopyTo(input);

                    var utility = new TransferUtility(client_);
                    var request = new TransferUtilityUploadRequest();

                    request.BucketName = bucket_;
                    request.InputStream = input;
                    request.Key = key + ".osr";
                    request.CannedACL = S3CannedACL.PublicRead;

                    utility.Upload(request);
                }
            }
            catch (AmazonS3Exception e)
            {
                throw new StorageException(e);
            }
        }

        private string bucket_;
        private IAmazonS3 client_;
    }
}
