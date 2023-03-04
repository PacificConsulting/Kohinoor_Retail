codeunit 50302 "POS Event and Subscriber"
{
    Access = Public;
    trigger OnRun()
    begin

    end;

    procedure POSActionEx(DocumentNo: Text; LineNo: integer; POSAction: Text; Parameter: Text; Input: Text): Text
    var
        POSProcedure: Codeunit 50303;
    begin
        case POSAction of
            'VOIDL':
                exit('Request received for document No' + DocumentNo);
            //POSProcedure.SalesLineDeletion(DocumentNo, LineNo);
            'VOIDT':
                POSProcedure.SalesOrderDeletion(DocumentNo);
            'VOIDP':
                POSProcedure.PaymentLineDeletion(DocumentNo, LineNo);
            'INVDISC':
                POSProcedure.InvoiceDiscount(DocumentNo, Input);
            'LINEDISC':
                POSProcedure.LineDiscount(DocumentNo, LineNo, Input);
            'SHIPLINE':
                POSProcedure.ShipLine(DocumentNo, LineNo, Input);
            'INVLINE':
                POSProcedure.InvoiceLine(DocumentNo, LineNo, Input);
            'RECEIPT':
                POSProcedure.ItemReceipt(DocumentNo, LineNo, Input);
            'DELDET':
                POSProcedure.DeliveryDetails(DocumentNo, Input);
        end;
        exit('Request received for document No' + DocumentNo);
    end;

    // procedure Ping(): Text
    // begin
    //     exit('Pong');
    // end;

    // procedure Addition(number1: Integer; number2: Integer): Integer
    // begin
    //     exit(number1 + number2);
    // end;

    // procedure GetJsonData(A: Integer; B: Integer) ReturnValue: Text
    // var
    //     Jobj: JsonObject;
    // begin

    //     JObj.Add('A', A);
    //     JObj.Add('B', B);
    //     Jobj.Add('Sum', A + B);
    //     Jobj.WriteTo(ReturnValue);
    //     exit(ReturnValue);
    // end;

    // procedure Capitalize(input: Text): Text
    // begin
    //     exit(input.ToUpper);
    // end;

    procedure POSEvent(documentno: text; linno: Integer; posaction: text; parameter: Text; input: Text): Text
    begin
        exit('Request received for document No' + documentno);
    end;

    procedure POSAction(documentno: text; lineno: Integer; posaction: text; parameter: Text; input: Text): Text
    var
        POSProcedure: Codeunit 50303;
        PageVar: Page 50319;
    begin
        case posaction of
            'VOIDL':
                begin
                    ClientId := Constants.GetClientId();
                    ClientSecret := Constants.GetClientSecret();
                    RedirectURL := Constants.GetRedirectURL();
                    AadTenantId := Constants.GetAadTenantId();
                    ApiGraph := Constants.GetApiGraphMe();
                    ApiListCompanies := Constants.GetApiListCompanies();
                    OAuthAuthorityUrl := Constants.GetOAuthAuthorityUrl();
                    GetAccessTokenForBC();
                    exit('Request received for document No:-' + documentno);
                end;
            //POSProcedure.SalesLineDeletion(DocumentNo, LineNo);
            'VOIDT':
                POSProcedure.SalesOrderDeletion(documentno);
            'VOIDP':
                POSProcedure.PaymentLineDeletion(documentno, lineno);
            'INVDISC':
                POSProcedure.InvoiceDiscount(documentno, input);
            'LINEDISC':
                POSProcedure.LineDiscount(documentno, lineno, input);
            'SHIPLINE':
                POSProcedure.ShipLine(documentno, lineno, input);
            'INVLINE':
                POSProcedure.InvoiceLine(documentno, lineno, input);
            'RECEIPT':
                POSProcedure.ItemReceipt(documentno, lineno, input);
            'DELDET':
                POSProcedure.DeliveryDetails(documentno, input);
        end;
    end;

    procedure GetAccessTokenForBC()
    var
        PromptInteraction: Enum "Prompt Interaction";
        AuthCodeError: Text;
        Scopes: List of [Text];
    begin
        Scopes.Add(Constants.GetResourceURLForApiBC() + '.default');

        OAuth2.AcquireAuthorizationCodeTokenFromCache(
        ClientId,
        ClientSecret,
        RedirectURL,
        OAuthAuthorityUrl,
        Scopes,
        AccessTokenForBC);
        //IF CompanyName = 'CRONUS IN' then begin
        GLSetup.get();
        IF AccessTokenForBC <> '' then begin
            GLSetup."Access Token" := AccessTokenForBC;
            GLSetup.Modify();
        end;
        // end;

        if AccessTokenForBC = '' then
            OAuth2.AcquireTokenByAuthorizationCode(
                      ClientId,
                      ClientSecret,
                      OAuthAuthorityUrl,
                      RedirectURL,
                      Scopes,
                      PromptInteraction::Consent,
                      AccessTokenForBC,
                      AuthCodeError);

    end;

    var
        GenericApiCalls: Codeunit GenericApiCalls;
        Constants: Codeunit Constants;
        OAuth2: Codeunit Oauth2;
        AadTenantId, APICallResponse, ClientId, ClientSecret : Text;
        AccessTokenForBC, AccessTokenForGraph, AuthError, ErrorMessage, OAuthAuthorityUrl, RedirectURL : text;
        ApiGraph, ApiListCompanies : Text;
        Result1, Result2, ResultStyleExpr1, ResultStyleExpr2 : text;
        GLSetup: record 98;
        ApiBCUrl: Label 'https://api.businesscentral.dynamics.com/', Locked = true;
        ApiGraphMeUrlTxt: Label 'https://graph.microsoft.com/v1.0/me', Locked = true;
        ApiGraphUrlTxt: Label 'https://graph.microsoft.com/', Locked = true;
        ApiListCompaniesTxt: Label '%1v2.0/%2/%3/api/beta/companies', Locked = true;
        ClientIdTxt: Label '68750603-fadd-4441-8542-bfaaa433a309', Locked = true;
        ClientSecretTxt: Label 'gOr8Q~UysVp6fIKqdedP4i1k1gnoDGGhKV-5TcAR', Locked = true;
        OAuthAuthorityUrlLabel: Label 'https://login.microsoftonline.com/', Locked = true;
        RedirectURLText: Label 'https://businesscentral.dynamics.com/OAuthLanding.htm', Locked = true;



}