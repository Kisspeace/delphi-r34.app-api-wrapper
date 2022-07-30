program test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  R34App.Types,
  NetHttp.R34AppApi,
  XSuperObject;

var
  Client: TR34AppClient;
  items: TR34AppItems;

procedure Log(AStr: string);
begin
  Writeln('[' + DateTimeToStr(Now) + ']: ' + AStr);
end;

procedure LogResult(AMsg: string; AItems: TR34AppItems);
var
  L: integer;
begin
  L := Length(AItems);
  if ( L > 0 ) then
    Log(AMsg + ': count=' + L.ToString + ' OK')
  else
    Log(AMsg + ': ERROR!!!');
end;

procedure TestBooru(ABooru: TR34AppFreeBooru);
begin
  LogResult(BooruToLink(ABooru), Client.GetPosts('', 0, DEFAULT_LIMIT, ABooru));
end;


var
  I: integer;
begin
  try
    Client := TR34AppClient.Create;
    with Client.WebClient do begin
      CustomHeaders['User-Agent'] := 'Mozilla/5.0 (Windows NT 10.0; rv:91.0) Gecko/20100101 Firefox/91.0';
    end;

    for I := ord(rule34xxx) to ord(e926net) do
      TestBooru(TR34AppFreeBooru(I));


    //Items := Client.GetPosts('', 1, DEFAULT_LIMIT, TR34AppFreeBooru.rule34xxx);
    //Log(TJson.Stringify<TR34AppItems>(Items, true));

    Readln;
  except
    on E: Exception do begin
      Writeln(E.ClassName, ': ', E.Message);
      ReadLn;
    end;
  end;
end.
