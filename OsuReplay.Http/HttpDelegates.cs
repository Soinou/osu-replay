using System;

namespace OsuReplay.Http
{
    public delegate void HttpErrorHandlerDelegate(Exception error, IHttpRequest request, IHttpResponse response);

    public delegate void HttpRequestHandlerDelegate(IHttpRequest request, IHttpResponse response);

    public delegate void HttpResponseSentHandler();
}
