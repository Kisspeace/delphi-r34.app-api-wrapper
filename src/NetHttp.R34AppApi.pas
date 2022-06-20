//♡2022 by Kisspeace. https://github.com/kisspeace
unit NetHttp.R34AppApi;

interface
uses
  R34App.Types, Net.HttpClientComponent,
  Net.HttpClient, XSuperObject, SysUtils;

const
  R34APP_API_URL = 'https://api.r34.app';

type

  TR34AppClient = class(TObject)
    private
      FBooru: string;
    public
      WebClient: TNetHttpClient;
      function GetPosts(ATags: string; APageId: integer = 1;
        ALimit: integer = 100): TR34AppItems;
      property Booru: string read FBooru write FBooru;
      constructor Create;
      destructor Destroy; override;
  end;

implementation
uses unit1;

{ TR34Client }

constructor TR34AppClient.Create;
begin
  WebClient := TNetHttpClient.Create(nil);
  WebClient.SynchronizeEvents := true;
  WebClient.Asynchronous := false;
  Booru := 'rule34.xxx';
end;

destructor TR34AppClient.Destroy;
begin
  WebClient.Free;
  inherited;
end;

function TR34AppClient.GetPosts(ATags: string; APageId: integer;
  ALimit: integer): TR34AppItems;
var
  X: ISuperArray;
  url: string;
  Response: IHTTPResponse;
  Content: string;
begin
  Result := nil;
  url :=
    ( R34APP_API_URL + '/booru/' +
      FBooru + '/posts?' +
      'baseEndpoint=' + FBooru +
      '&limit=' + ALimit.ToString +
      '&pageID=' + APageId.ToString );

  if not ATags.IsEmpty then
    url := url + '&tags=' + ATags;

  Response := WebClient.Get(url);

  try
    Content := Response.ContentAsString;
    X := SA(Content);
    try
      if X.Length > 0 then
        Result := TJson.Parse<TR34AppItems>(X);
    except
      Result := nil;
    end;
  Except
    Result := nil;
  end;
end;

end.
