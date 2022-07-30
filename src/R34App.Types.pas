//♡2022 by Kisspeace. https://github.com/kisspeace
unit R34App.Types;

interface
uses
  XSuperObject;

type

  TR34AppFile = record
    [ALIAS('url')] Url: string;
    [ALIAS('width')] Width: integer;
    [ALIAS('height')] Height: integer;
  end;

  TR34AppTags = record
    [ALIAS('character')] Character: TArray<String>;
    [ALIAS('copyright')] Copyright: TArray<String>;
    [ALIAS('artist')] Artist: TArray<String>;
    [ALIAS('general')] General: TArray<String>;
    [ALIAS('meta')] Meta: TArray<String>;
    function Count: integer;
    function ToString: string;
    function ToStringAr: TArray<String>;
  end;

  TR34AppItem = record
    [ALIAS('id')] Id: int64;
    [ALIAS('score')] Score: integer;
    [ALIAS('tags')] Tags: TR34AppTags;
    [ALIAS('high_res_file')] HighResFile: TR34AppFile;
    [ALIAS('low_res_file')] LowResFile: TR34AppFile;
    [ALIAS('preview_file')] PreviewFile: TR34AppFile;
    [ALIAS('sources')] Sources: TArray<string>;
    [ALIAS('rating')] Rating: string;
    [ALIAS('media_type')] MediaType: string;
    function IsImage: boolean;
  end;

  TR34AppItems = TArray<TR34AppItem>;

implementation

{ TR34AppItem }

function TR34AppItem.IsImage: boolean;
begin
  Result := (Self.MediaType = 'image');
end;

function TR34AppTags.Count: integer;
begin
  Result := Length(Character) +
            Length(Copyright) +
            Length(Artist) +
            Length(General) +
            Length(Meta);
end;

function TR34AppTags.ToString: string;

  procedure LStrArToStr(const AAr: TArray<string>; var AResult: string);
  var
    I: integer;
  begin
    for I := Low(AAr) to High(AAr) do
      AResult := AResult + ' ' + AAr[I];
  end;

begin
  Result := '';
  LStrArToStr(Character, Result);
  LStrArToStr(Copyright, Result);
  LStrArToStr(Artist, Result);
  LStrArToStr(General, Result);
  LStrArToStr(Meta, Result);
end;

function TR34AppTags.ToStringAr: TArray<String>;
begin
  Result := Character + Copyright + Artist + General + Meta;
end;


end.
