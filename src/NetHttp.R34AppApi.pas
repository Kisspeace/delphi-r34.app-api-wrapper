//♡2022 by Kisspeace. https://github.com/kisspeace
unit NetHttp.R34AppApi;

interface
uses
  R34App.Types, Net.HttpClientComponent,
  Net.HttpClient, XSuperObject, SysUtils;

const
  R34APP_API_URL = 'https://api.r34.app';
  DEFAULT_LIMIT = 20;

type

  TR34AppFreeBooru = (
    rule34xxx,        // rule34.xxx
    rule34pahealnet,  // rule34.paheal.net
    danboorudonmaius, // danbooru.donmai.us
    gelboorucom,      // gelbooru.com
    safebooruorg,     // safebooru.org
    e621net,          // e621.net
    e926net           // e926.net
  );

  TR34AppClient = class(TObject)
    public
      WebClient: TNetHttpClient;
      function GetPosts(ATags: string; APageId: integer = 0; ALimit: integer = DEFAULT_LIMIT; ABooru: TR34AppFreeBooru = rule34xxx): TR34AppItems;
      constructor Create;
      destructor Destroy; override;
  end;

  function BooruToLink(ABooru: TR34AppFreeBooru): string;
  function GetProxyUrl(AUrl: string): string;

implementation

function BooruToLink(ABooru: TR34AppFreeBooru): string;
begin
  case ABooru of
    rule34xxx:        Result := 'rule34.xxx';
    rule34pahealnet:  Result := 'rule34.paheal.net';
    danboorudonmaius: Result := 'danbooru.donmai.us';
    gelboorucom:      Result := 'gelbooru.com';
    safebooruorg:     Result := 'safebooru.org';
    e621net:          Result := 'e621.net';
    e926net:          Result := 'e926.net';
  end;
end;

function GetProxyUrl(AUrl: string): string;
begin
  Result := 'https://cors-proxy.r34.app/?q=' + AUrl;
end;


{ TR34Client }

constructor TR34AppClient.Create;
begin
  WebClient := TNetHttpClient.Create(nil);
  WebClient.SynchronizeEvents := true;
  WebClient.Asynchronous := false;
end;

destructor TR34AppClient.Destroy;
begin
  WebClient.Free;
  inherited;
end;

function TR34AppClient.GetPosts(ATags: string; APageId: integer;
  ALimit: integer; ABooru: TR34AppFreeBooru): TR34AppItems;
var
  X: ISuperArray;
  Url: string;
  BooruLink: string;
  Response: IHTTPResponse;
  Content: string;
begin
  Result := nil;
  Url := R34APP_API_URL + '/booru/';
  BooruLink := BooruToLink(ABooru);

  case ABooru of
    danboorudonmaius: Url := Url + 'danbooru2';
    safebooruorg:     Url := Url + 'gelbooru';
    e926net:          Url := Url + 'e621.net';
    else              Url := Url + BooruLink;
  end;

  Url := Url + '/posts?' +
    'baseEndpoint=' + BooruLink +
    '&limit=' + ALimit.ToString +
    '&pageID=' + APageId.ToString;

  if ( not ATags.IsEmpty ) then
    Url := Url + '&tags=' + ATags;

  Response := WebClient.Get(url);
  Content := Response.ContentAsString;

  X := SA(Content);
  if ( X.Length > 0 ) then
    Result := TJson.Parse<TR34AppItems>(X);
end;

end.
