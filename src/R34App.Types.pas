//♡2022 by Kisspeace. https://github.com/kisspeace
unit R34App.Types;

interface

type

  TR34AppFile = record
    url: string;
    width: integer;
    height: integer;
  end;

  TR34AppItem = record
    id: int64;
    score: integer;
    tags: TArray<string>;
    high_res_file: TR34AppFile;
    low_res_file: TR34AppFile;
    preview_file: TR34AppFile;
    source: TArray<string>;
    rating: string;
    media_type: string;
    function IsImage: boolean;
    function TagsCount: integer;
    function TagsStr: string;
  end;

  TR34AppItems = TArray<TR34AppItem>;

implementation

{ TR34AppItem }

function TR34AppItem.IsImage: boolean;
begin
  Result := (Self.media_type = 'image');
end;

function TR34AppItem.TagsCount: integer;
begin
  Result := Length(Tags);
end;

function TR34AppItem.TagsStr: string;
var
  I: integer;
begin
  Result := '';
  for I := Low(tags) to High(tags) do
    Result := Result + ' ' + Tags[I];
end;

end.
