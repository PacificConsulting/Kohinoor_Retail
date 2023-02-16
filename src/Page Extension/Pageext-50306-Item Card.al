pageextension 50306 "ItemCArdExtension" extends "Item Card"
{
    actions
    {
        addlast(processing)
        {
            group(Picture)
            {
                action(CreatePicture)
                {
                    Caption = 'Create Picture by Description';
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Image = Picture;
                    ApplicationArea = All;

                    trigger OnAction();
                    begin
                        //Clear(APIManagment);
                        Base64text := CreateImgOpenAI(Rec.Description);

                        TempBlob.CreateOutStream(outstream);
                        base64convert.FromBase64(Base64text, outstream);
                        TempBlob.CreateInStream(InStream);

                        Clear(rec.Picture);
                        Rec.Picture.ImportStream(instream, '');
                        Rec.Modify()

                    end;
                }
            }
        }
    }

    procedure CreateImgOpenAI(Description: Text): Text
    var
        JObject: JsonObject;
        JToken: JsonToken;
        JValue: JsonValue;
        JArray2: JsonArray;
        Base64: Text;
        Body: Text;
        z: Integer;

    begin
        Body := StrSubstNo('{"prompt":"%1","n": 2,"size": "256x256","response_format":"b64_json"}', Description);
        JObject.ReadFrom(POST_Request('https://api.openai.com/v1/images/generations', Body));
        JObject.get('data', JToken);
        Jarray2.ReadFrom(Format(Jtoken));
        for z := 0 to JArray2.Count() - 1 do begin
            Jarray2.Get(z, Jtoken);
            JObject := Jtoken.AsObject();
            JObject.get('b64_json', JToken);
            JValue := JToken.AsValue();
            Base64 := JValue.AsText();
        end;
        exit(Base64);
    end;

    procedure POST_Request(uri: Text; _queryObj: Text) responseText: Text;
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        contentHeaders: HttpHeaders;
        content: HttpContent;
    begin
        contentHeaders := client.DefaultRequestHeaders();
        contentHeaders.Add('Authorization', 'Bearer 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');

        content.WriteFrom(_queryObj);
        content.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');
        request.Content(content);

        request.SetRequestUri(uri);

        request.Method := 'POST';

        client.Send(request, response);

        // Read the response content as json.

        response.Content().ReadAs(responseText);

    end;

    var
        //APIManagment: Codeunit APiMgtOpenAI;
        FromText: Text;
        Base64text: Text;
        base64convert: codeunit "Base64 Convert";
        newItem: Record Item;
        TempBlob: Codeunit "Temp Blob";
        outstream: OutStream;
        instream: InStream;
}