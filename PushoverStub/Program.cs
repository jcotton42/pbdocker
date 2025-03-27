using System.Net.Http.Headers;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateSlimBuilder(args);

builder.Services.AddHttpClient();

var app = builder.Build();

app.MapPost("/", ProxyToPushover).DisableAntiforgery();

app.Run();

async Task<IResult> ProxyToPushover(
    [FromHeader] string user,
    [FromHeader] string token,
    [FromForm] string title,
    [FromForm] string description,
    HttpClient httpClient,
    IFormFile? thumbnail = null)
{
    var content = new MultipartFormDataContent();
    content.Add(new StringContent(user), "user");
    content.Add(new StringContent(token), "token");
    content.Add(new StringContent($"Posted {title}"), "title");
    content.Add(new StringContent(description), "message");

    Stream? thumbnailStream = null;
    try
    {
        if (thumbnail is not null)
        {
            thumbnailStream = thumbnail.OpenReadStream();
            var thumbnailContent = new StreamContent(thumbnailStream);
            thumbnailContent.Headers.ContentType = MediaTypeHeaderValue.Parse(thumbnail.ContentType);
            content.Add(thumbnailContent, "attachment", thumbnail.FileName);
        }

        var response = await httpClient.PostAsync("https://api.pushover.net/1/messages.json", content);
        return response.IsSuccessStatusCode ? Results.Ok() : Results.BadRequest(response.ReasonPhrase);
    }
    finally
    {
        thumbnailStream?.Dispose();
    }
}
