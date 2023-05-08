codeunit 50302 "POS Event and Subscriber"
{
    Access = Public;
    trigger OnRun()
    begin

    end;

    procedure POSAction(documentno: text; lineno: Integer; posaction: text; parameter1: Text; input: Text; parameter2: Text): Text
    var
        POSProcedure: Codeunit 50303;
        IsResult: Text;
    begin

        case posaction of
            'VOIDL':  //<<<<** Sales Line Delete Function **>>>>
                begin
                    Clear(IsResult);
                    IsResult := POSProcedure.SalesLineDeletion(documentno, lineno);
                    IF IsResult = '' then
                        exit('Success');
                    //Else
                    //  exit(IsResult);
                end;
            'VOIDT':  //<<<<** Complete Sales Order Delete **>>>>
                begin
                    Clear(IsResult);
                    IsResult := POSProcedure.SalesOrderDeletion(documentno);
                    IF IsResult = '' then
                        exit('Success');
                    //Else
                    //  exit(IsResult);
                end;
            'VOIDP':  //<<<<** Payment Line Delete Function **>>>>
                begin
                    Clear(IsResult);
                    IsResult := POSProcedure.PaymentLineDeletion(documentno, lineno);
                    IF IsResult = '' then
                        exit('Success');
                    //Else
                    //  exit(IsResult);
                end;
            'INVDISC':  //<<<<** Complete Sales order Discount Function **>>>>
                begin
                    IsResult := POSProcedure.InvoiceDiscount(documentno, input);
                    IF IsResult = '' then
                        exit('Success')
                    Else
                        exit('Invoice Discount Value not updated.');
                end;
            'LINEDISC':  //<<<<** Sales Line Discount Function **>>>>
                begin
                    IsResult := POSProcedure.LineDiscount(documentno, lineno, input);
                    IF IsResult = '' then
                        exit('Success')
                    Else
                        exit('Line Discount not updated.');
                end;
            'SHIPLINE':  //Not used this Function
                begin
                    IsResult := POSProcedure.ShipLine(documentno, lineno, input);
                    IF IsResult = '' then
                        exit('Success')
                    Else
                        exit(IsResult);
                end;
            'INVLINE':  //<<<<** Sales Order's Perticuller line Ship and Invoice **>>>>
                begin
                    IsResult := POSProcedure.InvoiceLine(documentno, lineno, parameter1, input);
                    IF IsResult = '' then
                        exit('Success');
                    // Else
                    //   exit(IsResult);
                end;
            'RECEIPT': //<<<<** Purchase Order or Tranfer Order Receive Function **>>>>
                begin
                    IsResult := POSProcedure.ItemReceipt(documentno, lineno, input);
                    IF IsResult = '' then
                        exit('Success');
                    //Else
                    //  exit(IsResult);
                end;
            'DELDET':  //<<<<** Sales Order Transport Method Update Function **>>>>
                begin
                    IsResult := POSProcedure.DeliveryDetails(documentno, input);
                    IF IsResult = '' then
                        exit('Success')
                    Else
                        exit(IsResult);
                end;
            'CUPSL':  //<<<<** Sales Line Unit Price Change Function **>>>>
                begin
                    IsResult := POSProcedure.ChangeUnitPrice(documentno, lineno, input);
                    IF IsResult = '' then
                        exit('Success')
                    Else
                        exit(IsResult);

                end;
            'EXITEM':  //<<<<** Exchange Item with new GL Line Created on Sales Order Function **>>>>
                begin
                    IsResult := POSProcedure.ExchangeItem(documentno, input, parameter1, parameter2);
                    IF IsResult = '' then
                        exit('Success')
                    Else
                        exit(IsResult);

                end;
            'STRCK':  //<<<<** Item Tracking for Sales Line,Transfer Line and GRN Function **>>>>
                begin
                    IsResult := POSProcedure.SerialItemTracking(documentno, lineno, input);
                    IF IsResult = '' then
                        exit('Success')
                    Else
                        exit(IsResult);

                end;
            'ORDWH':  //<<<<** Order Confirm for Warehouse **>>>>
                begin
                    IsResult := POSProcedure.OrderConfirmationforWH(documentno);
                    IF IsResult = '' then
                        exit('Success')
                    Else
                        exit(IsResult);

                end;
            'ORDDEL':  //<<<<** Order Confirm for Delivery **>>>>
                begin
                    IsResult := POSProcedure.OrderConfirmationforDelivery(documentno);
                    IF IsResult = '' then
                        exit('Success');
                    //Else
                    //  exit(IsResult);

                end;
            'INVCOM':  //<<<<** compelete Invoice Auto Qty to ship Update **>>>>
                begin
                    IsResult := POSProcedure.InvoiceComplete(documentno);
                    IF IsResult = '' then
                        exit('Success');
                    // Else
                    //   exit(IsResult);

                end;
        end;

    end;



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



    /// <summary>
    /// Update Tender Status Update to released as Submited
    /// </summary>
    procedure TenderSubmit(storeno: Code[20]; staffid: Code[20]; sdate: Text): Text
    var
        TenderHdr: Record "Tender Declartion Header";
        Vdate: date;
    begin
        //exit('Sucess');
        Evaluate(Vdate, sdate);
        TenderHdr.Reset();
        TenderHdr.SetRange("Store No.", storeno);
        TenderHdr.SetRange("Staff ID", staffid);
        TenderHdr.SetRange("Store Date", Vdate);
        IF TenderHdr.FindFirst() then begin
            TenderHdr.Status := TenderHdr.Status::Released;
            TenderHdr.Modify();
            //exit('Sucess');
            IF TenderHdr.Status <> TenderHdr.Status::Released then
                exit('Failed');
        end else
            exit('Failed');
    end;


    /// <summary>
    /// Bank Drop Submit Function
    /// </summary>
    procedure Bankdropsubmit(entryno: Code[20]): Text
    var
        BanKdrop: Record "Bank Drop Entry";
        Storedate: Date;
    begin
        //exit('Success');
        //Evaluate(Storedate, Format(sdate));
        BanKdrop.Reset();
        BanKdrop.SetRange("No.", entryno);
        // BanKdrop.SetRange("Store No.", storeno);
        // BanKdrop.SetRange("Staff ID", staffid);
        // BanKdrop.SetRange("Store Date", Storedate);
        IF BanKdrop.FindFirst() then begin
            BanKdrop.Status := BanKdrop.Status::Release;
            BanKdrop.Modify();
            IF BanKdrop.Status = BanKdrop.Status::Open then
                exit('Failed');
        end;

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
            //Exit('Success')
        end;
        IF RequestTranHdr.Status <> RequestTranHdr.Status::"Pending for Approval" then
            exit('Failed');
    end;

    /// <summary>
    /// Tranfer Order Ship Function
    /// </summary>
    procedure TransferOrderShipment(no: code[20]): Text
    var
        TranHdr: Record "Transfer Header";
        TransShip: Codeunit "TransferOrder-Post Shipment";
    begin
        TranHdr.Reset();
        TranHdr.SetRange("No.", no);
        IF TranHdr.FindFirst() then begin
            IF TranHdr.Status = TranHdr.Status::Open then begin
                TranHdr.Status := TranHdr.Status::Released;
                TranHdr.Modify(true);
            end;
            IF not TransShip.Run(TranHdr) then
                exit('Failed');

        end;
    end;

    /// <summary>
    /// Update Ship to Code on Sales Order
    /// </summary>
    procedure UpdateShiptoCodeOnSalesHeader(documentno: Code[20]; shiptocode: code[10]): Text
    var
        SalesHeader: record 36;
        ShiptoAdd: record 222;
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("No.", DocumentNo);
        IF SalesHeader.FindFirst() then begin
            IF SalesHeader.Status = SalesHeader.Status::Released then begin
                SalesHeader.Status := SalesHeader.Status::Open;
                SalesHeader.Modify();
            end;

            ShiptoAdd.Reset();
            ShiptoAdd.SetRange(Code, shiptocode);
            IF not ShiptoAdd.FindFirst() then
                exit('Failed');

            SalesHeader.Validate("Ship-to Code", shiptocode);
            SalesHeader.Modify(true);
            IF SalesHeader."Ship-to Code" <> shiptocode then
                exit('Failed');
        end;
    end;

    /// <summary>
    /// Tranfer Order Ship Item Tracking
    /// </summary>
    /// 
    // procedure TranferShipItemTracking(documentno: code[20]; lineno: Integer; input: text[50]): text
    // var
    //     ReservEntry: Record 337;
    //     ReservEntryInit: Record 337;
    //     LastEntryNo: Integer;
    //     SerialNo: Code[50];
    //     ItemLedgEntry: Record 32;
    //     TranLine: Record "Transfer Line";
    // begin
    //     // exit('Success....');
    //     Evaluate(SerialNo, input);
    //     Clear(LastEntryNo);

    //     TranLine.Reset();
    //     TranLine.SetRange("Document No.", documentno);
    //     TranLine.SetRange("Line No.", lineno);
    //     IF TranLine.FindFirst() then begin
    //         ReservEntry.RESET;
    //         ReservEntry.LOCKTABLE;
    //         IF ReservEntry.FINDLAST THEN
    //             LastEntryNo := ReservEntry."Entry No.";
    //         // ItemLedgEntry.RESET;
    //         // ItemLedgEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code");
    //         // ItemLedgEntry.SETRANGE("Item No.", TranLine."Item No.");
    //         // ItemLedgEntry.SETRANGE(Open, TRUE);
    //         // ItemLedgEntry.SETRANGE("Location Code", ItemLedgEntry."Location Code");
    //         // ItemLedgEntry.SetRange("Serial No.", SerialNo);
    //         // IF ItemLedgEntry.FindSet() then Begin //repeat
    //         ReservEntryInit.INIT;
    //         LastEntryNo += 1;
    //         ReservEntryInit."Entry No." := LastEntryNo;
    //         ReservEntryInit."Reservation Status" := ReservEntryInit."Reservation Status"::Surplus;
    //         ReservEntryInit.Positive := FALSE;
    //         ReservEntryInit."Item No." := TranLine."Item No.";
    //         ReservEntryInit."Location Code" := TranLine."Transfer-from Code";  //SalesLine."Location Code";
    //         ReservEntryInit."Qty. per Unit of Measure" := TranLine."Qty. per Unit of Measure";
    //         ReservEntryInit.VALIDATE("Quantity (Base)", TranLine.Quantity * -1);
    //         ReservEntryInit."Source Type" := DATABASE::"Transfer Line";
    //         ReservEntryInit."Source ID" := TranLine."Document No.";
    //         ReservEntryInit."Source Ref. No." := TranLine."Line No.";
    //         ReservEntryInit."Source Subtype" := 0;
    //         ReservEntryInit.validate("Serial No.", SerialNo/*ItemLedgEntry."Serial No."/*SerialNo*/);
    //         ReservEntryInit."Item Tracking" := ReservEntryInit."Item Tracking"::"Serial No.";
    //         ReservEntryInit."Shipment Date" := TranLine."Shipment Date";
    //         ReservEntryInit."Planning Flexibility" := ReservEntryInit."Planning Flexibility"::Unlimited;
    //         //ReservEntry.
    //         ReservEntryInit."Creation Date" := TODAY;
    //         ReservEntryInit."Created By" := USERID;
    //         ReservEntryInit.INSERT;
    //         //<<<<<***********Postive Qty New Reservation Entry Created*************//
    //         ReservEntry.RESET;
    //         ReservEntry.LOCKTABLE;
    //         IF ReservEntry.FINDLAST THEN
    //             LastEntryNo := ReservEntry."Entry No.";
    //         ReservEntryInit.INIT;
    //         LastEntryNo += 1;
    //         ReservEntryInit."Entry No." := LastEntryNo;
    //         ReservEntryInit."Reservation Status" := ReservEntryInit."Reservation Status"::Surplus;
    //         ReservEntryInit.Positive := FALSE;
    //         ReservEntryInit."Item No." := TranLine."Item No.";
    //         ReservEntryInit."Location Code" := TranLine."Transfer-to Code";  //SalesLine."Location Code";
    //         ReservEntryInit."Qty. per Unit of Measure" := TranLine."Qty. per Unit of Measure";
    //         ReservEntryInit.VALIDATE("Quantity (Base)", TranLine.Quantity);
    //         ReservEntryInit."Source Type" := DATABASE::"Transfer Line";
    //         ReservEntryInit."Source ID" := TranLine."Document No.";
    //         ReservEntryInit."Source Ref. No." := TranLine."Line No.";
    //         ReservEntryInit."Source Subtype" := 1;
    //         ReservEntryInit.validate("Serial No.", SerialNo/* ItemLedgEntry."Serial No."*/);
    //         ReservEntryInit."Item Tracking" := ReservEntryInit."Item Tracking"::"Serial No.";
    //         ReservEntryInit."Shipment Date" := TranLine."Shipment Date";
    //         ReservEntryInit."Planning Flexibility" := ReservEntryInit."Planning Flexibility"::Unlimited;
    //         //ReservEntry.
    //         ReservEntryInit."Creation Date" := TODAY;
    //         ReservEntryInit."Created By" := USERID;
    //         ReservEntryInit.INSERT;
    //         // End; //Until
    //         //exit('Success');
    //     end;


    // end;

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

    //Salesperson Update
    //
    procedure UpdateSalesPerson(DocumentNo: Code[20]; LineNo: Integer; SPCode: Code[20]): Text
    var

        RecSalesLine: Record 37;


    begin
        RecSalesLine.Reset();
        RecSalesLine.SetRange("Document No.", DocumentNo);
        RecSalesLine.SetRange("Line No.", LineNo);
        IF RecSalesLine.FindFirst() then begin
            RecSalesLine."Salesperson Code" := SPCode;
            RecSalesLine.Modify();
            exit('Success')
        end
        Else
            exit('Document Line not found');

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
        GenJourLineInit: record 81;
    begin
        PaymentLine.Reset();
        PaymentLine.SetRange("Document Type", Salesheader."Document Type");
        PaymentLine.SetRange("Document No.", Salesheader."No.");
        if PaymentLine.FindSet() then
            repeat
                GenJourLine.Reset();
                GenJourLine.SetRange("Journal Template Name", 'BANK RECE');
                GenJourLine.SetRange("Journal Batch Name", 'DEFAULT');
                GenJourLineInit.Init();
                GenJourLineInit."Journal Template Name" := 'BANK RECE';
                GenJourLineInit."Journal Batch Name" := 'DEFAULT';
                GenJourLineInit."Document No." := Salesheader."No.";
                GenJourLineInit.Validate("Posting Date", Today);
                IF GenJourLine.FindLast() then
                    GenJourLine."Line No." := GenJourLine."Line No." + 10000
                else
                    GenJourLine."Line No." := 10000;

                GenJourLineInit."Account Type" := GenJourLineInit."Account Type"::"Bank Account";
                GenJourLineInit."Bal. Account Type" := GenJourLineInit."Bal. Account Type"::Customer;
                GenJourLineInit.Validate("Bal. Account No.", Salesheader."Sell-to Customer No.");
                GenJourLineInit.validate("Account No.", 'BA000009');
                GenJourLineInit."GST Group Code" := 'Goods';
                GenJourLineInit.validate(Amount, PaymentLine.Amount);
                GenJourLineInit.Comment := 'Auto Post';
                GenJourLineInit.Insert(); //This Line Will Comment when auto post below codeunit Call
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