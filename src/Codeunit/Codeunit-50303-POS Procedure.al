codeunit 50303 "POS Procedure"
{
    trigger OnRun()
    begin

    end;

    /// <summary>
    /// Sales Line Deletion
    /// </summary>
    /// 

    procedure SalesLineDeletion("Document No.": Code[20]; "Line No.": Integer): Text
    var

        SalesLineDel: Record "Sales Line";
        SalesHeder: Record "Sales Header";
        ResultError: text;
    begin
        SalesHeder.Reset();
        SalesHeder.SetRange("No.", "Document No.");
        IF SalesHeder.FindFirst() then begin
            IF SalesHeder.Status = SalesHeder.Status::Released then begin
                SalesHeder.Status := SalesHeder.Status::Open;
                SalesHeder.Modify(true);
            end;
            SalesLineDel.Reset();
            SalesLineDel.SetRange("Document No.", SalesHeder."No.");
            SalesLineDel.SetRange("Line No.", "Line No.");
            IF SalesLineDel.FindFirst() then begin
                SalesLineDel.Delete();
                //Message('Line deleted successfully......');
                exit('Success');
            end
        end else
            exit('Failed');


        // ResultError := GetLastErrorText();


    end;



    /// <summary>
    /// Sales Order Deletion with all its child table
    /// </summary>
    procedure SalesOrderDeletion(DocumentNo: Code[20]): Text
    var
        SalesHeaderDelete: Record 36;
        PaymentLineDelete: record "Payment Lines";
        SalesLineDelete: Record 37;
    begin
        SalesHeaderDelete.Reset();
        SalesHeaderDelete.SetRange("No.", DocumentNo);
        if SalesHeaderDelete.FindFirst() then begin
            SalesHeaderDelete.Delete();
            SalesLineDelete.Reset();
            SalesLineDelete.SetRange("Document No.", DocumentNo);
            IF SalesLineDelete.FindFirst() then
                SalesLineDelete.DeleteAll();
            PaymentLineDelete.reset();
            PaymentLineDelete.SetRange("Document No.", DocumentNo);
            IF PaymentLineDelete.FindFirst() then begin
                PaymentLineDelete.DeleteAll();
                //exit('Success');
            end;
            exit('Success');
        end;
        exit('Success');
        // exit('Failed');
    end;


    /// <summary>
    /// Delete payment line
    /// </summary>
    procedure PaymentLineDeletion(DocumentNo: Code[20]; LineNo: Integer): Text
    var
        PayLineDelete: Record "Payment Lines";
    begin
        PayLineDelete.Reset();
        PayLineDelete.SetRange("Document No.", DocumentNo);
        PayLineDelete.SetRange("Line No.", LineNo);
        if PayLineDelete.FindFirst() then begin
            PayLineDelete.Delete();
            Message('Given payment line deleted successfully...');
            exit('Success');
        end;
        exit('Failed');
    end;


    /// <summary>
    /// Apply Line Discount
    /// </summary>
    procedure LineDiscount(DocumentNo: Code[20]; LineNo: Integer; LineDocumentpara: Text): Text
    var
        SaleHeaderDisc: Record "Sales Header";
        SalesLineDisc: Record "Sales Line";
        LineDicountDecimal: Decimal;
    begin
        Clear(LineDicountDecimal);
        Evaluate(LineDicountDecimal, LineDocumentpara);
        SaleHeaderDisc.Reset();
        SaleHeaderDisc.SetRange("No.", DocumentNo);
        IF SaleHeaderDisc.FindFirst() then begin
            IF SaleHeaderDisc.Status = SaleHeaderDisc.Status::Released then begin
                SaleHeaderDisc.Status := SaleHeaderDisc.Status::Open;
                SaleHeaderDisc.Modify(true);
            end;
            SalesLineDisc.Reset();
            SalesLineDisc.SetRange("Document No.", SaleHeaderDisc."No.");
            SalesLineDisc.SetRange("Line No.", LineNo);
            IF SalesLineDisc.FindFirst() then begin
                SalesLineDisc.validate("Line Discount %", LineDicountDecimal);
                SalesLineDisc.Modify(true);
                exit('Success');
            end;

        end;
    end;


    /// <summary>
    /// Apply Invoice Discount on Sales Order
    /// </summary>
    procedure InvoiceDiscount(DocumentNo: Code[20]; InputData: Text): Text
    var
        SalesHeaderDisc: Record "Sales Header";
        SalesStatDisc: Page "Sales Order Statistics";
        DiscAmt: Decimal;
        SalesLineDisc: Record "Sales Line";
    begin
        Clear(DiscAmt);
        Evaluate(DiscAmt, InputData);
        SalesHeaderDisc.Reset();
        SalesHeaderDisc.SetRange("No.", DocumentNo);
        SalesHeaderDisc.SetRange(Status, SalesHeaderDisc.Status::Open);
        IF SalesHeaderDisc.FindFirst() then begin
            InvoiceDiscountAmountSO(SalesHeaderDisc."Document Type", SalesHeaderDisc."No.", DiscAmt);
            exit('Success');
        end;
        exit('Failed');
    end;


    /// <summary>
    /// Post Shipment for a specific order Line / TO Line
    /// </summary>
    procedure ShipLine(DocumentNo: Code[20]; LineNo: Integer; InputData: Text): text
    var
        SaleHeaderShip: Record "Sales Header";
        ShiptoQty: Decimal;
        SalesLineShip: Record "Sales Line";
        TransferHeaderShip: record "Transfer Header";
        TransferlineShip: Record "Transfer Line";
        Salespost: codeunit 80;
        Transpostship: Codeunit "TransferOrder-Post Shipment";
    begin
        // Clear(InputData);
        Evaluate(ShiptoQty, InputData);
        // SaleHeaderShip.Reset();
        // SaleHeaderShip.SetRange("No.", DocumentNo);
        // //SaleHeaderShip.SetRange(Status, SaleHeaderShip.Status::Open);
        // IF SaleHeaderShip.FindFirst() then begin
        //     IF SaleHeaderShip.Status = SaleHeaderShip.Status::Released then begin
        //         SaleHeaderShip.Status := SaleHeaderShip.Status::Open;
        //         SalesLineShip.Modify(true);
        //     end;
        //     SalesLineShip.Reset();
        //     SalesLineShip.SetRange("Document No.", SaleHeaderShip."No.");
        //     SalesLineShip.SetRange("Line No.", LineNo);
        //     IF SalesLineShip.FindFirst() then begin
        //         SalesLineShip.validate("Qty. to Ship", ShiptoQty);
        //         SalesLineShip.Modify(true);
        //         SaleHeaderShip.Status := SaleHeaderShip.Status::Released;
        //         SaleHeaderShip."Store No." := 'POS';
        //         SaleHeaderShip.Modify(true);
        //         Salespost.Run(SaleHeaderShip);
        //         exit('Success');
        //     end
        // end else begin
        TransferHeaderShip.Reset();
        TransferHeaderShip.SetRange("No.", DocumentNo);
        IF TransferHeaderShip.FindFirst() then begin
            IF TransferHeaderShip.Status = TransferHeaderShip.Status::Released then begin
                TransferHeaderShip.Status := TransferHeaderShip.Status::Open;
                TransferHeaderShip.Modify(true);
            end;
            TransferlineShip.Reset();
            TransferlineShip.SetRange("Document No.", TransferHeaderShip."No.");
            TransferlineShip.SetRange("Line No.", LineNo);
            IF TransferlineShip.FindFirst() then begin
                TransferlineShip.Validate("Qty. to Ship", ShiptoQty);
                TransferlineShip.Modify(true);
                TransferHeaderShip.Status := TransferHeaderShip.Status::Released;
                TransferHeaderShip.Modify(true);
                Transpostship.Run(TransferHeaderShip);
                exit('Success');
            end;
        end;

        //end;

    end;


    /// <summary>
    /// Post ship and Invoice for a Complete order with Auto updare Qty Ship from Sales Line Qty
    /// </summary>
    procedure InvoiceComplete(DocumentNo: Code[20]): text
    var
        SalesHdr: Record 36;
        SalesLine: Record 37;
        SalesCommLine: Record 44;
        Salespost: codeunit 80;
    Begin
        SalesHdr.Reset();
        SalesHdr.SetRange("No.", DocumentNo);
        IF SalesHdr.FindFirst() then begin
            IF SalesHdr.Status = SalesHdr.Status::Released then begin
                SalesHdr.Status := SalesHdr.Status::Open;
                SalesHdr.Modify();
            end;
            SalesLine.Reset();
            SalesLine.SetRange("Document No.", SalesHdr."No.");
            IF SalesLine.FindSet() then
                repeat
                    SalesLine.Validate("Qty. to Ship", SalesLine.Quantity);
                    SalesLine.Modify();
                until SalesLine.Next() = 0;
            //<< Comment Mandetory so We have to pass Order Comment
            SalesCommLine.Reset();
            SalesCommLine.SetRange("No.", SalesHdr."No.");
            IF Not SalesCommLine.FindFirst() then begin
                SalesCommLine.Init();
                SalesCommLine."Document Type" := SalesCommLine."Document Type"::Order;
                SalesCommLine."No." := SalesHdr."No.";
                SalesCommLine."Line No." := 10000;
                SalesCommLine."Document Line No." := 10000;
                SalesCommLine.Insert();
                SalesCommLine.Comment := 'Document Processed from POS';
                SalesCommLine.Modify();
            end;
            //>> Comment Mandetory so We have to pass Order Comment
            SalesHdr.Status := SalesHdr.Status::Released;
            SalesHdr.Modify();
            IF Salespost.Run(SalesHdr) then
                exit('Success')
            else
                exit('Failed');
        end;
    End;

    /// <summary>
    /// Post ship and Invoice for a specific Order line
    /// </summary>
    procedure InvoiceLine(DocumentNo: Code[20]; LineNo: Integer; parameter: Text; InputData: Text): text
    var
        SaleHeaderInv: Record "Sales Header";
        SaleLinerInv: Record "Sales Line";
        ShipInvtoQty: Decimal;
        Salespost: codeunit 80;
        SalesCommLine: Record 44;
    begin
        Clear(InputData);
        Evaluate(ShipInvtoQty, InputData);
        SaleHeaderInv.Reset();
        SaleHeaderInv.SetRange("No.", DocumentNo);
        IF SaleHeaderInv.FindFirst() then begin
            IF SaleHeaderInv.Status = SaleHeaderInv.Status::Released then begin
                SaleHeaderInv.Status := SaleHeaderInv.Status::Open;
                SaleHeaderInv.Modify(true);
            end;
            SaleLinerInv.Reset();
            SaleLinerInv.SetRange("Document No.", SaleHeaderInv."No.");
            SaleLinerInv.SetRange("Line No.", LineNo);
            IF SaleLinerInv.FindFirst() then begin
                SaleLinerInv.validate("Qty. to Ship", ShipInvtoQty);
                SaleLinerInv.Modify(true);
                //<< Comment Mandetory so We have to pass Order Comment
                SalesCommLine.Reset();
                SalesCommLine.SetRange("No.", SaleHeaderInv."No.");
                IF Not SalesCommLine.FindFirst() then begin
                    SalesCommLine.Init();
                    SalesCommLine."Document Type" := SalesCommLine."Document Type"::Order;
                    SalesCommLine."No." := SaleHeaderInv."No.";
                    SalesCommLine."Line No." := 10000;
                    SalesCommLine."Document Line No." := 10000;
                    SalesCommLine.Insert();
                    SalesCommLine.Comment := 'Document Processed from POS';
                    SalesCommLine.Modify();
                end;
                //>> Comment Mandetory so We have to pass Order Comment
                SaleHeaderInv.Status := SaleHeaderInv.Status::Released;
                SaleHeaderInv.Modify(true);
                IF Salespost.Run(SaleHeaderInv) then
                    exit('Success');
            end
        end;
    end;

    /// <summary>
    /// Receive GRN or Transfer Receipt
    /// </summary>
    procedure ItemReceipt(DocumentNo: Code[20]; LineNo: Integer; InputData: Text): text
    var
        PurchHeader: Record 38;
        PurchLine: Record 39;
        QtyToReceive: Decimal;
        TransferHeader: record "Transfer Header";
        Transferline: Record "Transfer Line";
        Purchpost: Codeunit "Purch.-Post";
        TranspostReceived: Codeunit "TransferOrder-Post Receipt";

    begin
        Clear(InputData);
        Evaluate(QtyToReceive, InputData);
        PurchHeader.Reset();
        PurchHeader.SetRange("No.", DocumentNo);
        IF PurchHeader.FindFirst() then begin
            IF PurchHeader.Status = PurchHeader.Status::Released then begin
                PurchHeader.Status := PurchHeader.Status::Open;
                PurchHeader.Modify(true);
            end;
            PurchLine.Reset();
            PurchLine.SetRange("Document No.", PurchHeader."No.");
            PurchLine.SetRange("Line No.", LineNo);
            IF PurchLine.FindFirst() then begin
                PurchLine.validate("Qty. to Receive", QtyToReceive);
                PurchLine.Modify(true);
                PurchHeader.Status := PurchHeader.Status::Released;
                PurchHeader.Modify(true);
                IF Purchpost.Run(PurchHeader) then
                    exit('Success')
                else
                    exit('Failed');
            end
        end else begin
            TransferHeader.Reset();
            TransferHeader.SetRange("No.", DocumentNo);
            IF TransferHeader.FindFirst() then begin
                IF TransferHeader.Status = TransferHeader.Status::Released then begin
                    TransferHeader.Status := TransferHeader.Status::Open;
                    TransferHeader.Modify(true);
                end;
                Transferline.Reset();
                Transferline.SetRange("Document No.", TransferHeader."No.");
                Transferline.SetRange("Line No.", LineNo);
                IF Transferline.FindFirst() then begin
                    Transferline.Validate("Qty. to Receive", QtyToReceive);
                    Transferline.Modify(true);
                    TransferHeader.Status := TransferHeader.Status::Released;
                    TransferHeader.Modify(true);
                    IF TranspostReceived.Run(TransferHeader) then
                        exit('Success')
                    else
                        exit('Failed');
                end;
            end else
                exit('Failed');

        end;

    end;

    /// <summary>
    /// Adding delivery details like delivery method on Sales Order
    /// </summary>
    procedure DeliveryDetails(DocumentNo: Code[20]; InputData: Text): text
    var
        SalesHeder: Record "Sales Header";
    begin
        SalesHeder.Reset();
        SalesHeder.SetRange("No.", DocumentNo);
        IF SalesHeder.FindFirst() then begin
            IF SalesHeder.Status = SalesHeder.Status::Released then begin
                SalesHeder.Status := SalesHeder.Status::Open;
                SalesHeder.Modify(true);
            end;
            SalesHeder.Validate("Transport Method", InputData);
            SalesHeder.Modify();
            exit('Success');
        end;
    end;

    /// <summary>
    /// Update the Unit Price Sales Line
    /// </summary>
    procedure ChangeUnitPrice(DocumentNo: Code[20]; LineNo: Integer; LineDocumentpara: Text): Text
    var
        SaleHeaderUnitPrice: Record 36;
        SalesLineunitPrice: Record 37;
        NewUnitPrice: Decimal;

    begin
        Clear(NewUnitPrice);
        Evaluate(NewUnitPrice, LineDocumentpara);
        SaleHeaderUnitPrice.Reset();
        SaleHeaderUnitPrice.SetRange("No.", DocumentNo);
        IF SaleHeaderUnitPrice.FindFirst() then begin
            IF SaleHeaderUnitPrice.Status = SaleHeaderUnitPrice.Status::Released then begin
                SaleHeaderUnitPrice.Status := SaleHeaderUnitPrice.Status::Open;
                SaleHeaderUnitPrice.Modify(true);
            end;
            SalesLineunitPrice.Reset();
            SalesLineunitPrice.SetRange("Document No.", SaleHeaderUnitPrice."No.");
            SalesLineunitPrice.SetRange("Line No.", LineNo);
            IF SalesLineunitPrice.FindFirst() then begin
                //<< New Condtion add after with kunal Discussion to Send for Approval befor Modification Unit Price before price line level new field Add and Update first
                SalesLineunitPrice."Approval Status" := SalesLineunitPrice."Approval Status"::"Pending for Approval";
                SalesLineunitPrice."Approval Sent By" := UserId;
                SalesLineunitPrice."Approval Sent On" := Today;
                IF SalesLineunitPrice."Approval Status" = SalesLineunitPrice."Approval Status"::" " then begin
                    SalesLineunitPrice."Old Unit Price" := SalesLineunitPrice."Unit Price";
                    SalesLineunitPrice.validate("Unit Price", NewUnitPrice);
                end;
                SalesLineunitPrice.Modify(true);
                IF SalesLineunitPrice."Unit Price" = NewUnitPrice then
                    exit('Success')
                else
                    exit('Failed');
            end;

        end;
    end;


    /*
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
    procedure SerialItemTracking(documentno: code[20]; lineno: integer; input: text[20]): text
    begin
        exit('Success')
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
    */
    //<<<<<******************************** Local function created depending on original function*************
    Local procedure InvoiceDiscountAmountSO(DocumentType: enum "Sales Document Type"; DocumentNo: Code[20]; InvoiceDiscountAmount: decimal)
    var
        SalesHeader: Record "Sales Header";
        ConfirmManagement: Codeunit "Confirm Management";
        UpdateInvDiscountQst: Label 'One or more lines have been invoiced. The discount distributed to invoiced lines will not be taken into account.\\Do you want to update the invoice discount?';
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        DocumentTotals: Codeunit "Document Totals";
    begin


        SalesHeader.Get(DocumentType, DocumentNo);
        if SalesHeader.InvoicedLineExists() then
            if not ConfirmManagement.GetResponseOrDefault(UpdateInvDiscountQst, true) then
                exit;

        SalesCalcDiscountByType.ApplyInvDiscBasedOnAmt(InvoiceDiscountAmount, SalesHeader);
        DocumentTotals.SalesDocTotalsNotUpToDate();

    end;

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





}