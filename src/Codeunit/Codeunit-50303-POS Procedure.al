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
                Purchpost.Run(PurchHeader);
                exit('Success');
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
                    TranspostReceived.Run(TransferHeader);
                    exit('Success');
                end;
            end;

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
        //SalesHeder.SetRange(Status, SalesHeder.Status::Open);
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
                SalesLineunitPrice.validate("Unit Price", NewUnitPrice);
                SalesLineunitPrice.Modify(true);
                exit('Success');
            end;

        end;
    end;


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



}