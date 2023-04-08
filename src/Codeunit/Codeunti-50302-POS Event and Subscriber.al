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
                    IsResult := POSProcedure.InvoiceLine(documentno, lineno, parameter, input);
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
        POSProcedure: Codeunit 50303;
        IsResult: Text;
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
            //GLSetup."Access Token" := AccessTokenForBC;
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

    /// <summary>
    /// Update Tender Status Update to released as Submited
    /// </summary>
    procedure TenderSubmit(storeno: Code[20]; staffid: Code[20]; sdate: Date): Text
    var
        TenderHdr: Record "Tender Declartion Header";
    begin
        TenderHdr.Reset();
        TenderHdr.SetRange("Store No.", storeno);
        TenderHdr.SetRange("Staff ID", staffid);
        TenderHdr.SetRange("Store Date", sdate);
        IF TenderHdr.FindFirst() then begin
            TenderHdr.Status := TenderHdr.Status::Released;
            TenderHdr.Modify();
            exit('Sucess');
        end else
            exit('Failed, Tender does not exist');
    end;


    /// <summary>
    /// Bank Drop Submit Function
    /// </summary>
    procedure Bankdropsubmit(storeno: Code[20]; staffid: Code[20]; sdate: Date; amount: text): Text
    var
    begin
        exit('Success')
    end;


    /// <summary>
    /// Order Confirmation for WareHouse function POS.
    /// </summary>
    procedure OrderConfirmationforDelivery(DocumentNo: Code[20]): Text
    var
        PaymentLine: Record "Payment Lines";
        TotalPayemtamt: Decimal;
        SalesHeader: Record "Sales Header";
        AmountToCust: decimal;
        TotalGSTAmount1: Decimal;
        TotalAmt: Decimal;
        TotalTCSAmt: Decimal;
        SalesRec11: record "Sales & Receivables Setup";
    begin
        clear(TotalGSTAmount1);
        Clear(TotalTCSAmt);
        Clear(TotalAmt);
        SalesRec11.get();

        SalesHeader.Reset();
        SalesHeader.SetRange("No.", DocumentNo);
        if SalesHeader.FindFirst() then begin
            GetGSTAmountTotal(SalesHeader, TotalGSTAmount1);
            GetTCSAmountTotal(SalesHeader, TotalTCSAmt);
            GetSalesorderStatisticsAmount(SalesHeader, TotalAmt);
            SalesHeader."Amount To Customer" := TotalAmt + TotalGSTAmount1 + TotalTCSAmt;
            SalesHeader.Modify();

            Clear(TotalPayemtamt);
            PaymentLine.Reset();
            PaymentLine.SetRange("Document No.", SalesHeader."No.");
            if PaymentLine.FindSet() then
                repeat
                    TotalPayemtamt := PaymentLine.Amount;
                until PaymentLine.Next() = 0;

            IF TotalPayemtamt <> SalesHeader."Amount To Customer" then
                Error('Sales Order amount is not match with Payment amount')
            else begin
                BankPayentReceiptAutoPost(SalesHeader);
                SalesHeader.Reset();
                SalesHeader.SetRange("No.", SalesHeader."No.");
                If SalesHeader.FindFirst() then begin
                    SalesHeader.Validate("Location Code", SalesRec11."Default Warehouse");
                    //SalesHdr."Staff Id" :=
                    SalesHeader."POS Released Date" := Today;
                    SalesHeader.Status := SalesHeader.Status::Released;
                    SalesHeader.Modify();
                    Exit('Success');
                end;
            end;
        end else
            exit('Failed');
    end;

    /// <summary>
    /// Serial No Item tracking for SO
    /// </summary>
    procedure SerialItemTracking(documentno: code[20]; lineno: integer; input: text[50]): text
    var
        ReservEntry: Record 337;
        ReservEntryInit: Record 337;
        LastEntryNo: Integer;
        SalesLine: Record 37;
        SerialNo: Code[50];
    begin
        // exit('Success....');
        Evaluate(SerialNo, input);
        Clear(LastEntryNo);

        SalesLine.Reset();
        SalesLine.SetRange("Document No.", documentno);
        SalesLine.SetRange("Line No.", lineno);
        IF SalesLine.FindFirst() then begin
            ReservEntry.RESET;
            ReservEntry.LOCKTABLE;
            IF ReservEntry.FINDLAST THEN
                LastEntryNo := ReservEntry."Entry No.";

            ReservEntryInit.INIT;
            LastEntryNo += 1;
            ReservEntryInit."Entry No." := LastEntryNo;
            ReservEntryInit."Reservation Status" := ReservEntryInit."Reservation Status"::Surplus;
            ReservEntryInit.Positive := FALSE;
            ReservEntryInit."Item No." := SalesLine."No.";
            ReservEntryInit."Location Code" := SalesLine."Location Code";
            ReservEntryInit."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
            ReservEntryInit.VALIDATE("Quantity (Base)", /*SalesLine.Quantity*/1 * -1);
            ReservEntryInit."Source Type" := DATABASE::"Sales Line";
            ReservEntryInit."Source ID" := SalesLine."Document No.";
            ReservEntryInit."Source Ref. No." := SalesLine."Line No.";
            ReservEntryInit."Source Subtype" := 1;
            ReservEntryInit.validate("Serial No.", SerialNo);
            ReservEntryInit."Item Tracking" := ReservEntryInit."Item Tracking"::"Serial No.";
            ReservEntryInit."Shipment Date" := SalesLine."Shipment Date";
            ReservEntryInit."Planning Flexibility" := ReservEntryInit."Planning Flexibility"::Unlimited;
            // ReservEntryInit.VALIDATE("Lot No.", ItemLedgEntry."Lot No.");
            // ReservEntryInit."Variant Code" := ItemLedgEntry."Variant Code";

            // IF ReservEntryInit.Positive THEN BEGIN
            //     ReservEntryInit."Warranty Date" := ItemLedgEntry."Warranty Date";
            //     ReservEntryInit."Expiration Date" := ItemLedgEntry."Expiration Date";
            //     ReservEntryInit."Expected Receipt Date" := 0D
            // END ELSE

            ReservEntryInit."Creation Date" := TODAY;
            ReservEntryInit."Created By" := USERID;
            ReservEntryInit.INSERT;
            exit('Success');
        end;

    end;

    /// <summary>
    /// Order Confirmation for WareHouse function POS.
    /// </summary>
    procedure OrderConfirmationforWH(DocumentNo: Code[20]): Text
    var
        PaymentLine: Record "Payment Lines";
        TotalPayemtamt: Decimal;
        SalesHdr: Record "Sales Header";
        AmountToCust: decimal;
        TotalGSTAmount1: Decimal;
        TotalAmt: Decimal;
        TotalTCSAmt: Decimal;
        SalesRec: record "Sales & Receivables Setup";
    begin
        clear(TotalGSTAmount1);
        Clear(TotalTCSAmt);
        Clear(TotalAmt);
        SalesRec.get();

        SalesHdr.Reset();
        SalesHdr.SetRange("No.", DocumentNo);
        if SalesHdr.FindFirst() then begin
            GetGSTAmountTotal(SalesHdr, TotalGSTAmount1);
            GetTCSAmountTotal(SalesHdr, TotalTCSAmt);
            GetSalesorderStatisticsAmount(SalesHdr, TotalAmt);
            SalesHdr."Amount To Customer" := TotalAmt + TotalGSTAmount1 + TotalTCSAmt;
            SalesHdr.Modify();

            Clear(TotalPayemtamt);
            PaymentLine.Reset();
            PaymentLine.SetRange("Document No.", SalesHdr."No.");
            if PaymentLine.FindSet() then
                repeat
                    TotalPayemtamt := PaymentLine.Amount;
                until PaymentLine.Next() = 0;

            IF TotalPayemtamt <> SalesHdr."Amount To Customer" then
                Error('Sales Order amount is not match with Payment amount')
            else begin
                BankPayentReceiptAutoPost(SalesHdr);
                SalesHdr.Reset();
                SalesHdr.SetRange("No.", SalesHdr."No.");
                If SalesHdr.FindFirst() then begin
                    SalesHdr.Validate("Location Code", SalesRec."Default Warehouse");
                    //SalesHdr."Staff Id" :=
                    SalesHdr."POS Released Date" := Today;
                    SalesHdr.Status := SalesHdr.Status::Released;
                    SalesHdr.Modify();
                    Exit('Success');
                end;
            end;
        end else
            exit('Failed');
    end;


    /// <summary>
    /// Request Transfer Header Status Update Function
    /// </summary>
    procedure RequestTransferStatusUpdate(no: code[20]): text
    var
        RequestTranHdr: Record "Request Transfer Header";
    begin
        RequestTranHdr.Reset();
        RequestTranHdr.SetRange("No.", no);
        IF RequestTranHdr.FindFirst() then begin
            RequestTranHdr.Status := RequestTranHdr.Status::"Pending for Approval";
            RequestTranHdr.Modify();
            Exit('Success')
        end else
            exit('Failed');
    end;

    //<<<<<******************************** Local function created depending on original function*************
    procedure GetGSTAmountTotal(
     SalesHeader: Record 36;
     var GSTAmount: Decimal)
    var
        SalesLine: Record 37;
    begin
        Clear(GSTAmount);
        SalesLine.SetRange("Document no.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                GSTAmount += GetGSTAmount11(SalesLine.RecordId());
            until SalesLine.Next() = 0;
    end;

    local procedure GetGSTAmount11(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;

        TaxTransactionValue.SetRange("Tax Record ID", RecID);
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        if GSTSetup."Cess Tax Type" <> '' then
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type", GSTSetup."Cess Tax Type")
        else
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if not TaxTransactionValue.IsEmpty() then begin
            TaxTransactionValue.CalcSums(Amount);
            TaxTransactionValue.CalcSums(Percent);

        end;
        exit(TaxTransactionValue.Amount);
    end;

    procedure GetTCSAmountTotal(
           SalesHeader: Record 36;
           var TCSAmount: Decimal)
    var
        SalesLine: Record 37;
        TCSManagement: Codeunit "TCS Management";
        i: Integer;
        RecordIDList: List of [RecordID];
    begin
        Clear(TCSAmount);
        // Clear(TCSPercent);

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document no.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                RecordIDList.Add(SalesLine.RecordId());
            until SalesLine.Next() = 0;

        for i := 1 to RecordIDList.Count() do begin
            TCSAmount += GetTCSAmount(RecordIDList.Get(i));
        end;

        TCSAmount := TCSManagement.RoundTCSAmount(TCSAmount);
    end;

    local procedure GetTCSAmount(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TCSSetup: Record "TCS Setup";
    begin
        if not TCSSetup.Get() then
            exit;

        TaxTransactionValue.SetRange("Tax Record ID", RecID);
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        TaxTransactionValue.SetRange("Tax Type", TCSSetup."Tax Type");
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if not TaxTransactionValue.IsEmpty() then
            TaxTransactionValue.CalcSums(Amount);

        exit(TaxTransactionValue.Amount);
    end;

    procedure GetSalesorderStatisticsAmount(
            SalesHeader: Record 36;
            var TotalInclTaxAmount: Decimal)
    var
        SalesLine: Record 37;
        RecordIDList: List of [RecordID];
        GSTAmount: Decimal;
        TCSAmount: Decimal;
    begin
        Clear(TotalInclTaxAmount);

        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                RecordIDList.Add(SalesLine.RecordId());
                TotalInclTaxAmount += SalesLine.Amount;
            until SalesLine.Next() = 0;


        TotalInclTaxAmount := TotalInclTaxAmount + GSTAmount + TCSAmount;
    end;

    local procedure BankPayentReceiptAutoPost(Salesheader: Record "Sales Header")
    var
        GenJourLine: Record 81;
        NoSeriesMgt: Codeunit 396;
        BankAcc: Record 270;
        PaymentLine: Record 50301;
    begin
        PaymentLine.Reset();
        PaymentLine.SetRange("Document Type", Salesheader."Document Type");
        PaymentLine.SetRange("Document No.", Salesheader."No.");
        if PaymentLine.FindSet() then
            repeat
                GenJourLine.Reset();
                GenJourLine.SetRange("Journal Template Name", 'BANKRCPTY');
                GenJourLine.SetRange("Journal Batch Name", 'USER-A');
                GenJourLine.Init();
                GenJourLine."Document No." := NoSeriesMgt.GetNextNo('BANKRCPTV', Salesheader."Posting Date", false);
                GenJourLine."Posting Date" := Today;
                IF GenJourLine.FindLast() then
                    GenJourLine."Line No." := GenJourLine."Line No." + 10000
                else
                    GenJourLine."Line No." := 10000;

                GenJourLine."Journal Template Name" := 'BANKRCPTY';
                GenJourLine."Journal Batch Name" := 'USER-A';
                GenJourLine."Account Type" := GenJourLine."Account Type"::"Bank Account";
                GenJourLine."Bal. Account Type" := GenJourLine."Bal. Account Type"::Customer;
                GenJourLine.Validate("Bal. Account No.", Salesheader."Sell-to Customer No.");
                GenJourLine.validate("Account No.", 'GIRO');
                GenJourLine."GST Group Code" := 'Goods';
                GenJourLine.validate(Amount, PaymentLine.Amount);
                GenJourLine.Comment := 'Auto Post';
                GenJourLine.Insert(true);
            Until PaymentLine.Next() = 0;

        // IF CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJourLine) then begin
        //     PaymentLine.Reset();
        //     PaymentLine.SetRange("Document Type", Rec."Document Type");
        //     PaymentLine.SetRange("Document No.", Rec."No.");
        //     if PaymentLine.FindSet() then
        //         repeat
        //             PaymentLine.Posted := True;
        //             PaymentLine.Modify();
        //             IsPaymentLineeditable := PaymentLine.PaymentLinesEditable()
        //         Until PaymentLine.Next() = 0;
        // end;
    end;
    //>>>>>>******************************** Local function created depending on original function*************

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