codeunit 50302 "POS Event and Subscriber"
{
    Access = Public;
    trigger OnRun()
    begin

    end;


    procedure POSAction(documentno: text; lineno: Integer; posaction: text; parameter: Text; input: Text): Text
    var
        POSProcedure: Codeunit 50303;
        IsResult: Text;
    begin
        case posaction of
            'VOIDL':
                begin
                    // AccessToken();
                    Clear(IsResult);
                    IsResult := POSProcedure.SalesLineDeletion(documentno, lineno);
                    IF IsResult = 'Success' then
                        exit('Success')
                    Else
                        if IsResult = 'Failed' then
                            exit('Given order No. does not exist.');


                    //Recref.GetTable(recCust);
                    // TempBlob.CreateOutStream(OutStr);
                    // Report.SaveAs(Report::"Customer - List", '', ReportFormat::Pdf, OutStr, Recref);
                    // OutStr.WriteText('F:\txtfile\', 1024);
                    //exit('Request received for document No:-' + documentno);


                end;
            'VOIDT':
                begin
                    Clear(IsResult);
                    IsResult := POSProcedure.SalesOrderDeletion(documentno);
                    IF IsResult = 'Success' then
                        exit('Success')
                    Else
                        if IsResult = 'Failed' then
                            exit('Failed');
                end;
            'VOIDP':
                begin
                    Clear(IsResult);
                    IsResult := POSProcedure.PaymentLineDeletion(documentno, lineno);
                    IF IsResult = 'Success' then
                        exit('Success')
                    Else
                        if IsResult = 'Failed' then
                            exit('Failed');
                end;
            'INVDISC':
                begin
                    IsResult := POSProcedure.InvoiceDiscount(documentno, input);
                    IF IsResult = 'Success' then
                        exit('Success')
                    Else
                        if IsResult = 'Failed' then
                            exit('Failed');
                end;
            'LINEDISC':
                begin
                    IsResult := POSProcedure.LineDiscount(documentno, lineno, input);
                    IF IsResult = 'Success' then
                        exit('Success')
                    Else
                        if IsResult = 'Failed' then
                            exit('Failed');
                end;
            'SHIPLINE':
                begin
                    IsResult := POSProcedure.ShipLine(documentno, lineno, input);
                    IF IsResult = 'Success' then
                        exit('Success')
                    Else
                        if IsResult = 'Failed' then
                            exit('Failed');
                end;
            'INVLINE':
                begin
                    IsResult := POSProcedure.InvoiceLine(documentno, lineno, input);
                    IF IsResult = 'Success' then
                        exit('Success')
                    Else
                        if IsResult = 'Failed' then
                            exit('Failed');
                end;
            'RECEIPT':
                begin
                    IsResult := POSProcedure.ItemReceipt(documentno, lineno, input);
                    IF IsResult = 'Success' then
                        exit('Success')
                    Else
                        if IsResult = 'Failed' then
                            exit('Failed');
                end;
            'DELDET':
                begin
                    IsResult := POSProcedure.DeliveryDetails(documentno, input);
                    IF IsResult = 'Success' then
                        exit('Success')
                    Else
                        if IsResult = 'Failed' then
                            exit('Failed');
                end;
            'CUPSL':
                begin
                    IsResult := POSProcedure.ChangeUnitPrice(documentno, lineno, input);
                    IF IsResult = 'Success' then
                        exit('Success')
                    Else
                        if IsResult = 'Failed' then
                            exit('Failed');
                end;
        end;
    end;

    // procedure POSActionEx(DocumentNo: Text; LineNo: integer; POSAction: Text; Parameter: Text; Input: Text): Text
    // var
    //     POSProcedure: Codeunit 50303;
    // begin
    //     case POSAction of
    //         'VOIDL':
    //             exit('Request received for document No' + DocumentNo);
    //         //POSProcedure.SalesLineDeletion(DocumentNo, LineNo);
    //         'VOIDT':
    //             POSProcedure.SalesOrderDeletion(DocumentNo);
    //         'VOIDP':
    //             POSProcedure.PaymentLineDeletion(DocumentNo, LineNo);
    //         'INVDISC':
    //             POSProcedure.InvoiceDiscount(DocumentNo, Input);
    //         'LINEDISC':
    //             POSProcedure.LineDiscount(DocumentNo, LineNo, Input);
    //         'SHIPLINE':
    //             POSProcedure.ShipLine(DocumentNo, LineNo, Input);
    //         'INVLINE':
    //             POSProcedure.InvoiceLine(DocumentNo, LineNo, Input);
    //         'RECEIPT':
    //             POSProcedure.ItemReceipt(DocumentNo, LineNo, Input);
    //         'DELDET':
    //             POSProcedure.DeliveryDetails(DocumentNo, Input);
    //     end;
    //     exit('Request received for document No' + DocumentNo);
    // end;

    // procedure Ping(): Text
    // begin
    //     exit('Pong');
    // end;

    // procedure Addition(number1: Integer; number2: Integer): Integer
    // begin
    //     exit(number1 + number2);
    // end;


    // procedure Capitalize(input: Text): Text
    // begin
    //     exit(input.ToUpper);
    // end;

    procedure POSEvent(documentno: text; linno: Integer; posaction: text; parameter: Text; input: Text): Text
    var
        Recref: RecordRef;
        recCust: Record 18;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        Instr: InStream;
        FileManagement_lCdu: Codeunit "File Management";
        NewStr: text;
    begin
        // Recref.GetTable(recCust);
        // TempBlob.CreateOutStream(OutStr);
        // Report.SaveAs(Report::"Customer - List", '', ReportFormat::Pdf, OutStr, Recref);
        // TempBlob.CreateInStream(InStr);
        // FileManagement_lCdu.BLOBExport(TempBlob, STRSUBSTNO('Proforma_%1.Pdf', recCust."No."), TRUE);
        // // exit('PC Request received for document No' + documentno);
        // Evaluate(NewStr, FORMAT(OutStr));

        // exit(NewStr);
        recCust.get(10000);
        //CustReport.Run();
        Report.Run(101, false, false, recCust);

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

        GLSetup.get();
        IF AccessTokenForBC <> '' then begin
            GLSetup."Access Token" := AccessTokenForBC;
            GLSetup.Modify();
        end;


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

    local procedure AccessToken()
    var
        myInt: Integer;
    begin
        ClientId := Constants.GetClientId();
        ClientSecret := Constants.GetClientSecret();
        RedirectURL := Constants.GetRedirectURL();
        AadTenantId := Constants.GetAadTenantId();
        ApiGraph := Constants.GetApiGraphMe();
        ApiListCompanies := Constants.GetApiListCompanies();
        OAuthAuthorityUrl := Constants.GetOAuthAuthorityUrl();
        GetAccessTokenForBC();
    end;

    var
        //GenericApiCalls: Codeunit GenericApiCalls;
        Constants: Codeunit "Access Token API";
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

        Recref: RecordRef;
        recCust: Record 18;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        Instr: InStream;
        CustReport: Report "Customer - List";




}