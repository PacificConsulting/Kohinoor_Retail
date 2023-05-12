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

                //******* Warranty Line delete code ******
                SalesLineDel.Reset();
                SalesLineDel.SetRange("Document No.", SalesHeder."No.");
                SalesLineDel.SetRange("Warranty Parent Line No.", "Line No.");
                IF SalesLineDel.FindFirst() then
                    SalesLineDel.Delete();

            end
        end;
    end;



    /// <summary>
    /// Sales Order Deletion with all its child table
    /// </summary>
    procedure SalesOrderDeletion(documentno: Code[20]): Text
    var
        SalesHeaderDelete: Record 36;
        PaymentLineDelete: record "Payment Lines";
        SalesLineDelete: Record 37;
    begin
        SalesHeaderDelete.Reset();
        SalesHeaderDelete.SetRange("No.", documentno);
        if SalesHeaderDelete.FindFirst() then begin
            SalesHeaderDelete.Delete();
            SalesLineDelete.Reset();
            SalesLineDelete.SetRange("Document No.", documentno);
            IF SalesLineDelete.FindFirst() then
                SalesLineDelete.DeleteAll();
            PaymentLineDelete.reset();
            PaymentLineDelete.SetRange("Document No.", DocumentNo);
            IF PaymentLineDelete.FindFirst() then begin
                PaymentLineDelete.DeleteAll();
                //exit('Success');
            end;
            //exit('Success');
        end;
        //exit('Success');
        // exit('Failed');
    end;


    /// <summary>
    /// Delete payment line
    /// </summary>
    procedure PaymentLineDeletion(documentNo: Code[20]; lineNo: Integer): Text
    var
        PayLineDelete: Record "Payment Lines";
    begin
        PayLineDelete.Reset();
        PayLineDelete.SetRange("Document No.", DocumentNo);
        PayLineDelete.SetRange("Line No.", LineNo);
        PayLineDelete.SetRange(Posted, false);
        if PayLineDelete.FindFirst() then begin
            PayLineDelete.Delete();
            //Message('Given payment line deleted successfully...');
            //exit('Success');
        end
        //else
        //  exit('Failed');
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
                //exit('Success');
            end;
            IF (SalesLineDisc."Line Discount %" <> LineDicountDecimal) then
                exit('Failed');

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
            //exit('Success');
        end;
        IF SalesHeaderDisc."Invoice Discount Value" <> DiscAmt then
            exit('Failed');
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
                    SalesLine.Validate("Qty. to Invoice", SalesLine.Quantity);
                    SalesLine.Modify();
                until SalesLine.Next() = 0;
            //<< Comment Mandetory so We have to pass Order Comment
            SalesCommLine.Reset();
            SalesCommLine.SetRange("No.", SalesHdr."No.");
            IF Not SalesCommLine.FindFirst() then begin
                SalesCommLine.Init();
                SalesCommLine."Document Type" := SalesCommLine."Document Type"::Order;
                SalesCommLine."No." := SalesHdr."No.";
                SalesCommLine."Line No." := SalesLine."Line No.";
                SalesCommLine."Document Line No." := SalesLine."Line No.";
                SalesCommLine.Insert();
                SalesCommLine.Comment := 'Document Processed from POS';
                SalesCommLine.Modify();
            end;
            //>> Comment Mandetory so We have to pass Order Comment
            SalesHdr.Status := SalesHdr.Status::Released;
            SalesHdr.Modify();
            Salespost.Run(SalesHdr);
            //exit('Failed');
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
        SalespostYN: codeunit 81;
        SalesCommLine: Record 44;
        ReturnBool: Boolean;
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin
        // Clear(InputData);
        //Evaluate(ShipInvtoQty, InputData);
        SaleHeaderInv.Reset();
        SaleHeaderInv.SetRange("No.", DocumentNo);
        IF SaleHeaderInv.FindFirst() then begin
            //  EXIT('Found');
            IF SaleHeaderInv.Status = SaleHeaderInv.Status::Released then begin
                SaleHeaderInv.Status := SaleHeaderInv.Status::Open;
                SaleHeaderInv.Modify(true);
            end;
            SaleLinerInv.Reset();
            SaleLinerInv.SetRange("Document No.", SaleHeaderInv."No.");
            SaleLinerInv.SetRange("Line No.", LineNo);
            IF SaleLinerInv.FindFirst() then begin
                SaleLinerInv.validate("Qty. to Ship", SaleLinerInv."Qty. to Ship");
                SaleLinerInv.Validate("Qty. to Invoice", SaleLinerInv."Qty. to Ship");
                SaleLinerInv.Modify(true);
                //<< Comment Mandetory so We have to pass Order Comment
                SalesCommLine.Reset();
                SalesCommLine.SetRange("No.", SaleHeaderInv."No.");
                IF Not SalesCommLine.FindFirst() then begin
                    SalesCommLine.Init();
                    SalesCommLine."Document Type" := SalesCommLine."Document Type"::Order;
                    SalesCommLine."No." := SaleHeaderInv."No.";
                    SalesCommLine."Line No." := SaleLinerInv."Line No.";
                    SalesCommLine."Document Line No." := SaleLinerInv."Line No.";
                    SalesCommLine.Insert();
                    SalesCommLine.Comment := 'Document Processed from POS';
                    SalesCommLine.Modify();
                end;
                //>> Comment Mandetory so We have to pass Order Comment
                //SaleHeaderInv.Status := SaleHeaderInv.Status::Released;
                ReleaseSalesDoc.PerformManualRelease(SaleHeaderInv);
                SaleHeaderInv.Modify(true);
                Salespost.Run(SaleHeaderInv);
                //Message(FORMAT(ReturnBool));
                //exit('Failed');
            end
        end;
    end;

    /// <summary>
    /// Receive GRN or Transfer Receipt
    /// </summary>
    procedure ItemReceipt(documentNo: Code[20]; lineNo: Integer; inputData: Text): text
    var
        PurchHeader: Record 38;
        PurchLine: Record 39;
        QtyToReceive: Decimal;
        TransferHeader: record "Transfer Header";
        Transferline: Record "Transfer Line";
        Purchpost: Codeunit "Purch.-Post";
        TranspostReceived: Codeunit "TransferOrder-Post Receipt";
        ReleasePurch: codeunit "Release Purchase Document";
        PurchCommLine: Record "Purch. Comment Line";
    begin
        //Clear(InputData);
        // Evaluate(QtyToReceive, InputData);

        PurchHeader.Reset();
        PurchHeader.SetRange("No.", DocumentNo);
        IF PurchHeader.FindFirst() then begin
            IF PurchHeader.Status = PurchHeader.Status::Released then begin
                PurchHeader.Status := PurchHeader.Status::Open;
                PurchHeader.Modify();
            end;
            PurchLine.Reset();
            PurchLine.SetRange("Document No.", PurchHeader."No.");
            IF PurchLine.FindFirst() then begin
                //<< Comment Mandetory so We have to pass Order Comment
                PurchCommLine.Reset();
                PurchCommLine.SetRange("No.", PurchHeader."No.");
                IF Not PurchCommLine.FindFirst() then begin
                    PurchCommLine.Init();
                    PurchCommLine."Document Type" := PurchCommLine."Document Type"::Order;
                    PurchCommLine."No." := PurchHeader."No.";
                    PurchCommLine."Line No." := PurchLine."Line No.";
                    PurchCommLine."Document Line No." := PurchLine."Line No.";
                    PurchCommLine.Insert();
                    PurchCommLine.Comment := 'Document Processed from POS';
                    PurchCommLine.Modify();
                end;
                //>> Comment Mandetory so We have to pass Order Comment
                PurchHeader.Receive := true;
                PurchHeader.Invoice := false;
                PurchHeader.Modify();
                ReleasePurch.PerformManualRelease(PurchHeader);
                Purchpost.Run(PurchHeader);

            end
        end else begin
            TransferHeader.Reset();
            TransferHeader.SetRange("No.", DocumentNo);
            IF TransferHeader.FindFirst() then begin
                IF TransferHeader.Status = TransferHeader.Status::Released then begin
                    TransferHeader.Status := TransferHeader.Status::Open;
                    TransferHeader.Modify();
                end;
                Transferline.Reset();
                Transferline.SetRange("Document No.", TransferHeader."No.");
                IF Transferline.FindFirst() then begin
                    //   Transferline.Validate("Qty. to Receive", Transferline.Quantity);
                    //Transferline.Modify();
                    TransferHeader.Status := TransferHeader.Status::Released;
                    TransferHeader.Modify();
                    TranspostReceived.Run(TransferHeader);
                end;
            end //else
                //exit('Failed');
        end;

    end;

    /// <summary>
    /// Adding delivery details like delivery method on Sales Order
    /// </summary>
    procedure DeliveryDetails(DocumentNo: Code[20]; InputData: Text): text
    var
        SalesHeder: Record "Sales Header";
        DeliveryDate: Date;
    begin
        Evaluate(DeliveryDate, InputData);
        SalesHeder.Reset();
        SalesHeder.SetRange("No.", DocumentNo);
        IF SalesHeder.FindFirst() then begin
            IF SalesHeder.Status = SalesHeder.Status::Released then begin
                SalesHeder.Status := SalesHeder.Status::Open;
                SalesHeder.Modify();
            end;
            SalesHeder.Validate("Requested Delivery Date", DeliveryDate);
            SalesHeder.Modify();
            IF SalesHeder."Requested Delivery Date" <> DeliveryDate then
                exit('Delivery date not updated successfully.');
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
        TradeAggre: record "Trade Aggrement";
        SalesHeder: record 36;
        SL: Record 37;

    begin
        Clear(NewUnitPrice);
        Evaluate(NewUnitPrice, LineDocumentpara);
        SaleHeaderUnitPrice.Reset();
        SaleHeaderUnitPrice.SetRange("No.", DocumentNo);
        IF SaleHeaderUnitPrice.FindFirst() then begin
            IF SaleHeaderUnitPrice.Status = SaleHeaderUnitPrice.Status::Released then begin
                SaleHeaderUnitPrice.Status := SaleHeaderUnitPrice.Status::Open;
                SaleHeaderUnitPrice.Modify();
            end;
            SalesLineunitPrice.Reset();
            SalesLineunitPrice.SetRange("Document No.", SaleHeaderUnitPrice."No.");
            SalesLineunitPrice.SetRange("Line No.", LineNo);
            IF SalesLineunitPrice.FindFirst() then begin
                //<< New Condtion add after with kunal Discussion to Send for Approval befor Modification Unit Price before price line level new field Add and Update first
                IF SalesLineunitPrice."Unit Price Incl. of Tax" <> NewUnitPrice then begin
                    SalesLineunitPrice."Old Unit Price" := SalesLineunitPrice."Unit Price Incl. of Tax";
                    SalesLineunitPrice.validate("Unit Price Incl. of Tax", NewUnitPrice);
                    SalesLineunitPrice.Modify();
                    IF SalesHeder.Get(SalesLineunitPrice."Document Type", SalesLineunitPrice."Document No.") then;
                    TradeAggre.Reset();
                    TradeAggre.SetCurrentKey("Item No.", "From Date", "To Date", "Location Code");
                    TradeAggre.SetRange("Item No.", SalesLineunitPrice."No.");
                    TradeAggre.SetRange("Location Code", SalesHeder."Location Code");
                    TradeAggre.SetFilter("From Date", '<=%1', SalesHeder."Posting Date");
                    TradeAggre.SetFilter("To Date", '>=%1', SalesHeder."Posting Date");
                    IF TradeAggre.FindFirst() then begin
                        IF TradeAggre."Amount In INR" < SalesLineunitPrice."Unit Price Incl. of Tax" then
                            Error('Amount should not be more than %1 INR', TradeAggre."Amount In INR");
                        IF TradeAggre."Last Selling Price" > SalesLineunitPrice."Unit Price Incl. of Tax" then begin
                            ApprovalMailSent(SalesLineunitPrice);
                        end;
                    end else begin
                        TradeAggre.SetRange("Location Code");
                        IF TradeAggre.FindFirst() then begin
                            IF TradeAggre."Amount In INR" < SalesLineunitPrice."Unit Price Incl. of Tax" then
                                Error('Amount should not be more than %1 INR', TradeAggre."Amount In INR");
                            IF TradeAggre."Last Selling Price" > SalesLineunitPrice."Unit Price Incl. of Tax" then begin
                                ApprovalMailSent(SalesLineunitPrice);
                            end;
                        end;
                    end;
                end;
                /*
                SalesLineunitPrice."Approval Status" := SalesLineunitPrice."Approval Status"::"Pending for Approval";
                SalesLineunitPrice."Approval Sent By" := UserId;
                SalesLineunitPrice."Approval Sent On" := Today;
                */
                //  IF SalesLineunitPrice."Approval Status" = SalesLineunitPrice."Approval Status"::" " then begin
                //SalesLineunitPrice."Old Unit Price" := SalesLineunitPrice."Unit Price";
                //SalesLineunitPrice.validate("Unit Price", NewUnitPrice);
                /*
                SalesLineunitPrice."Old Unit Price" := SalesLineunitPrice."Unit Price Incl. of Tax";
                SalesLineunitPrice.validate("Unit Price Incl. of Tax", NewUnitPrice);
                SalesLineunitPrice.Modify();

                IF SalesLineunitPrice."Unit Price" = NewUnitPrice then
                    exit('Unit Price not updated.');
                    */
            end;

        end;
    end;

    /// <summary>
    /// Exchange Order Function
    /// </summary>
    procedure ExchangeItem(documentno: Code[20]; exchangeitem: code[20]; serialno: code[50]; price: text): text
    var
        SalesLineInit: Record 37;
        SalesLine: Record 37;
        SR: Record "Sales & Receivables Setup";
        Quantity: Decimal;
        SalesHeader: Record 36;
        UnitP: Decimal;
        RecItem: Record 27;
        SNlist: record 6504;
    begin
        SNlist.Reset();
        SNlist.SetRange("Serial No.", serialno);
        IF SNlist.FindFirst() then
            Error('Serial No. does not exist');

        SalesHeader.Reset();
        SalesHeader.SetRange("No.", documentno);
        SalesHeader.SetRange("Document Type", SalesHeader."Document Type"::Order);
        IF SalesHeader.FindFirst() then begin
            SR.Get();
            SR.TestField("Exchange Item G/L");
            IF price <> '' then
                Evaluate(UnitP, price);
            SalesLineInit.Init();
            SalesLineInit."Document Type" := SalesLineInit."Document Type"::Order;
            SalesLineInit."Document No." := documentno;
            SalesLine.Reset();
            SalesLine.SetRange("Document No.", documentno);
            IF SalesLine.FindLast() then
                SalesLineInit."Line No." := SalesLine."Line No." + 10000
            else
                SalesLineInit."Line No." := 10000;

            SalesLineInit.Insert();
            SalesLineInit.Type := SalesLineInit.Type::"G/L Account";
            SalesLineInit.Validate("No.", SR."Exchange Item G/L");
            SalesLineInit.Validate(Quantity, 1);
            SalesLineInit.Validate("Unit of Measure Code", 'PCS');
            IF RecItem.Get(exchangeitem) then begin
                SalesLineInit.Validate(Description, RecItem.Description);
                SalesLineInit.Validate("Unit Price", RecItem."Unit Price" * -1);
            end;
            SalesLineInit."Serial No." := serialno;
            SalesLineInit."Exchange Item No." := exchangeitem;
            SalesLineInit."Store No." := SalesLine."Store No.";

            SalesLineInit.Modify();

            IF (SalesLineInit."Serial No." <> serialno) or (SalesLineInit."Exchange Item No." <> exchangeitem) then
                Exit('Quantity,Serial No. and Exchange Item No. not update');

        end;
    end;

    /// <summary>
    /// Serial No Item tracking for Sales Line and Transfer Line
    /// </summary>
    procedure SerialItemTracking(documentno: code[20]; lineno: integer; input: text[50]): text
    var
        ReservEntry: Record 337;
        ReservEntryInit: Record 337;
        LastEntryNo: Integer;
        SalesLine: Record 37;
        SerialNo: Code[50];
        ItemLedgEntry: Record 32;
        TranLine: Record "Transfer Line";
        PurchLine: Record 39;
        DocFound: Boolean;
        BincodeEvaluate: code[20];
        SNlist: record 6504;
    begin
        Evaluate(SerialNo, input);
        Clear(LastEntryNo);
        DocFound := false;
        SalesLine.Reset();
        SalesLine.SetRange("Document No.", documentno);
        SalesLine.SetRange("Line No.", lineno);
        IF SalesLine.FindFirst() then begin
            DocFound := true;
            SalesLine.Validate("Bin Code", 'BACKPACK');
            SalesLine.Validate("Qty. to Ship", SalesLine."Qty. to Ship" + 1);
            SalesLine.Modify();


            //exit('Error');
            ReservEntry.RESET;
            ReservEntry.LOCKTABLE;
            IF ReservEntry.FINDLAST THEN
                LastEntryNo := ReservEntry."Entry No.";
            ItemLedgEntry.RESET;
            ItemLedgEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code");
            ItemLedgEntry.SETRANGE("Item No.", SalesLine."No.");
            ItemLedgEntry.SETRANGE("Variant Code", SalesLine."Variant Code");
            ItemLedgEntry.SETRANGE(Open, TRUE);
            ItemLedgEntry.SETRANGE("Location Code", SalesLine."Location Code");
            ItemLedgEntry.SetRange("Serial No.", SerialNo);
            IF ItemLedgEntry.FindSet() then Begin //repeat
                ReservEntryInit.INIT;
                LastEntryNo += 1;
                ReservEntryInit."Entry No." := LastEntryNo;
                ReservEntryInit."Reservation Status" := ReservEntryInit."Reservation Status"::Surplus;
                ReservEntryInit.Positive := FALSE;
                ReservEntryInit."Item No." := SalesLine."No.";
                ReservEntryInit."Location Code" := ItemLedgEntry."Location Code";  //SalesLine."Location Code";
                ReservEntryInit."Qty. per Unit of Measure" := SalesLine."Qty. per Unit of Measure";
                ReservEntryInit.VALIDATE("Quantity (Base)", SalesLine.Quantity * -1);
                ReservEntryInit."Source Type" := DATABASE::"Sales Line";
                ReservEntryInit."Source ID" := SalesLine."Document No.";
                ReservEntryInit."Source Ref. No." := SalesLine."Line No.";
                ReservEntryInit."Source Subtype" := 1;
                ReservEntryInit.validate("Serial No.", ItemLedgEntry."Serial No."/*SerialNo*/);
                ReservEntryInit."Item Tracking" := ReservEntryInit."Item Tracking"::"Serial No.";
                ReservEntryInit."Shipment Date" := SalesLine."Shipment Date";
                ReservEntryInit."Planning Flexibility" := ReservEntryInit."Planning Flexibility"::Unlimited;
                ReservEntryInit."Back Pack/Display" := ItemLedgEntry."Back Pack/Display";
                //ReservEntry.
                ReservEntryInit."Creation Date" := TODAY;
                ReservEntryInit."Created By" := USERID;
                ReservEntryInit.INSERT;
            End
            ELSE
                EXIT('Insufficient Inventory'); //Until
                                                //exit('Success');
        end else begin
            Evaluate(SerialNo, input);
            Clear(LastEntryNo);

            TranLine.Reset();
            TranLine.SetRange("Document No.", documentno);
            TranLine.SetRange("Line No.", lineno);
            IF TranLine.FindFirst() then begin
                DocFound := true;
                IF TranLine."Qty. to Ship" = 0 then begin
                    TranLine.Validate("Transfer-from Bin Code", 'BACKPACK');
                    TranLine.Validate("Qty. to Ship", TranLine."Qty. to Ship" + 1);
                    TranLine.Modify();
                end;
                ReservEntry.RESET;
                ReservEntry.LOCKTABLE;
                IF ReservEntry.FINDLAST THEN
                    LastEntryNo := ReservEntry."Entry No.";
                // ItemLedgEntry.RESET;
                // ItemLedgEntry.SETCURRENTKEY("Item No.", Open, "Variant Code", Positive, "Location Code");
                // ItemLedgEntry.SETRANGE("Item No.", TranLine."Item No.");
                // ItemLedgEntry.SETRANGE(Open, TRUE);
                // ItemLedgEntry.SETRANGE("Location Code", ItemLedgEntry."Location Code");
                // ItemLedgEntry.SetRange("Serial No.", SerialNo);
                // IF ItemLedgEntry.FindSet() then Begin //repeat

                //<<<<<***********With Negative Qty New Reservation Entry Created*************//
                ReservEntryInit.INIT;
                LastEntryNo += 1;
                ReservEntryInit."Entry No." := LastEntryNo;
                ReservEntryInit."Reservation Status" := ReservEntryInit."Reservation Status"::Surplus;
                ReservEntryInit.Positive := FALSE;
                ReservEntryInit."Item No." := TranLine."Item No.";
                ReservEntryInit."Location Code" := TranLine."Transfer-from Code";  //SalesLine."Location Code";
                ReservEntryInit."Qty. per Unit of Measure" := TranLine."Qty. per Unit of Measure";
                ReservEntryInit.VALIDATE("Quantity (Base)", 1 * -1);
                ReservEntryInit."Source Type" := DATABASE::"Transfer Line";
                ReservEntryInit."Source ID" := TranLine."Document No.";
                ReservEntryInit."Source Ref. No." := TranLine."Line No.";
                ReservEntryInit."Source Subtype" := 0;
                ReservEntryInit.validate("Serial No.", SerialNo/*ItemLedgEntry."Serial No."/*SerialNo*/);
                ReservEntryInit."Item Tracking" := ReservEntryInit."Item Tracking"::"Serial No.";
                ReservEntryInit."Shipment Date" := TranLine."Shipment Date";
                ReservEntryInit."Planning Flexibility" := ReservEntryInit."Planning Flexibility"::Unlimited;
                //ReservEntry.
                ReservEntryInit."Creation Date" := TODAY;
                ReservEntryInit."Created By" := USERID;
                ReservEntryInit.INSERT;

                // //<<<<<***********Postive Qty New Reservation Entry Created*************//
                // ReservEntry.RESET;
                // ReservEntry.LOCKTABLE;
                // IF ReservEntry.FINDLAST THEN
                //     LastEntryNo := ReservEntry."Entry No.";
                // ReservEntryInit.INIT;
                // LastEntryNo += 1;
                // ReservEntryInit."Entry No." := LastEntryNo;
                // ReservEntryInit."Reservation Status" := ReservEntryInit."Reservation Status"::Surplus;
                // ReservEntryInit.Positive := FALSE;
                // ReservEntryInit."Item No." := TranLine."Item No.";
                // ReservEntryInit."Location Code" := TranLine."Transfer-to Code";  //SalesLine."Location Code";
                // ReservEntryInit."Qty. per Unit of Measure" := TranLine."Qty. per Unit of Measure";
                // ReservEntryInit.VALIDATE("Quantity (Base)", 1/*TranLine.Quantity*/);
                // ReservEntryInit."Source Type" := DATABASE::"Transfer Line";
                // ReservEntryInit."Source ID" := TranLine."Document No.";
                // ReservEntryInit."Source Ref. No." := TranLine."Line No.";
                // ReservEntryInit."Source Subtype" := 1;
                // ReservEntryInit.validate("Serial No.", SerialNo/* ItemLedgEntry."Serial No."*/);
                // ReservEntryInit."Item Tracking" := ReservEntryInit."Item Tracking"::"Serial No.";
                // ReservEntryInit."Shipment Date" := TranLine."Shipment Date";
                // ReservEntryInit."Planning Flexibility" := ReservEntryInit."Planning Flexibility"::Unlimited;
                // //ReservEntry.
                // ReservEntryInit."Creation Date" := TODAY;
                // ReservEntryInit."Created By" := USERID;
                // ReservEntryInit.INSERT;

            end;
        end;
        Evaluate(SerialNo, input);
        //Error(input);
        Clear(LastEntryNo);
        PurchLine.Reset();
        PurchLine.SetRange("Document No.", documentno);
        PurchLine.SetRange("Line No.", lineno);
        IF PurchLine.FindFirst() then begin
            DocFound := true;
            //IF PurchLine."Qty. to Receive" = 0 then begin
            SNlist.Reset();
            SNlist.SetRange("Serial No.", SerialNo);
            IF SNlist.FindFirst() then
                Error('Serial No. does not exist');

            PurchLine.Validate("Bin Code", 'BACKPACK');
            PurchLine.Validate("Qty. to Receive", PurchLine."Qty. to Receive" + 1);
            PurchLine.Validate("Qty. to Invoice", 0);
            PurchLine.Modify();


            // end;

            ReservEntry.RESET;
            ReservEntry.LOCKTABLE;
            IF ReservEntry.FINDLAST THEN
                LastEntryNo := ReservEntry."Entry No.";

            ReservEntryInit.INIT;
            LastEntryNo += 1;
            ReservEntryInit."Entry No." := LastEntryNo;
            ReservEntryInit."Reservation Status" := ReservEntryInit."Reservation Status"::Surplus;
            ReservEntryInit.Positive := true;
            ReservEntryInit."Item No." := PurchLine."No.";
            ReservEntryInit."Location Code" := PurchLine."Location Code";
            ReservEntryInit."Qty. per Unit of Measure" := PurchLine."Qty. per Unit of Measure";
            ReservEntryInit.VALIDATE("Quantity (Base)", 1);
            ReservEntryInit."Source Type" := DATABASE::"Purchase Line";
            ReservEntryInit."Source ID" := PurchLine."Document No.";
            ReservEntryInit."Source Ref. No." := PurchLine."Line No.";
            ReservEntryInit."Source Subtype" := 1;
            ReservEntryInit.validate("Serial No.", SerialNo/*ItemLedgEntry."Serial No."/*SerialNo*/);
            ReservEntryInit."Item Tracking" := ReservEntryInit."Item Tracking"::"Serial No.";
            ReservEntryInit."Expected Receipt Date" := PurchLine."Posting Date";
            ReservEntryInit."Planning Flexibility" := ReservEntryInit."Planning Flexibility"::Unlimited;
            ReservEntryInit."Creation Date" := TODAY;
            ReservEntryInit."Created By" := USERID;
            ReservEntryInit.INSERT;

        end;
        IF DocFound = false then
            exit('No document found')
    end;

    /// <summary>
    /// Order Confirmation for Delivery function POS.
    /// </summary>
    procedure OrderConfirmationforDelivery(documentno: Code[20]): Text
    var
        PaymentLine: Record "Payment Lines";
        TotalPayemtamt: Decimal;
        SalesHeader: Record "Sales Header";
        AmountToCust: decimal;
        TotalGSTAmount1: Decimal;
        TotalAmt: Decimal;
        TotalTCSAmt: Decimal;
        SalesRec11: record "Sales & Receivables Setup";
        SalesLine: Record 37;
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin
        clear(TotalGSTAmount1);
        Clear(TotalTCSAmt);
        Clear(TotalAmt);
        SalesRec11.get();

        SalesLine.Reset();
        SalesLine.SetRange("Document No.", DocumentNo);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        IF SalesLine.FindSet() then
            repeat
                SalesLine.TestField("Salesperson Code");
            until SalesLine.Next() = 0;

        SalesHeader.Reset();
        SalesHeader.SetRange("No.", DocumentNo);
        IF SalesHeader.FindFirst() then begin
            SalesHeader.TestField(Status, SalesHeader.Status::Open);
            // IF SalessHeader.Status = SalesHeader.Status::Released then begin
            //     SalesHeader.Status := SalesHeader.Status::Open;
            //     SalesHeader.Modify();
            // end;
        end;
        SalesHeader.Reset();
        SalesHeader.SetRange("No.", DocumentNo);
        if SalesHeader.FindFirst() then begin
            GetGSTAmountTotal(SalesHeader, TotalGSTAmount1);
            GetTCSAmountTotal(SalesHeader, TotalTCSAmt);
            GetSalesorderStatisticsAmount(SalesHeader, TotalAmt);
            SalesHeader."Amount To Customer" := ROUND(TotalAmt + TotalGSTAmount1 + TotalTCSAmt, 1);
            SalesHeader.Modify();

            Clear(TotalPayemtamt);
            PaymentLine.Reset();
            PaymentLine.SetRange("Document No.", SalesHeader."No.");
            if PaymentLine.FindSet() then
                repeat
                    TotalPayemtamt += PaymentLine.Amount;
                until PaymentLine.Next() = 0;

            IF TotalPayemtamt <> SalesHeader."Amount To Customer" then
                Error('Sales Order amount is not match with Payment amount %1 with %2', TotalPayemtamt, SalesHeader."Amount To Customer")
            else begin
                BankPayentReceiptAutoPost(SalesHeader);
                SalesHeader.Reset();
                SalesHeader.SetRange("No.", SalesHeader."No.");
                If SalesHeader.FindFirst() then begin
                    // SalesHeader.Validate("Location Code", SalesRec11."Default Warehouse");
                    //SalesHdr."Staff Id" :=
                    SalesHeader."POS Released Date" := Today;
                    SalesHeader.Modify();

                    SalesLine.Reset();
                    SalesLine.SetRange("Document No.", DocumentNo);
                    IF SalesLine.FindSet() then
                        repeat
                            SalesLine.Validate("Location Code", SalesHeader."Location Code");
                            SalesLine.Validate("Shortcut Dimension 1 Code", SalesHeader."Shortcut Dimension 1 Code");
                            SalesLine.Validate("Shortcut Dimension 2 Code", SalesHeader."Shortcut Dimension 2 Code");
                            SalesLine.Modify()
                        until SalesLine.Next() = 0;

                    // SalesLine.Reset();
                    // SalesLine.SetRange("Document No.", SalesHeader."No.");
                    // SalesLine.SetRange(Type, SalesLine.Type::Item);
                    // IF SalesLine.FindFirst() then
                    //     repeat
                    //         SalesLine.Validate("Qty. to Ship", 0);
                    //         SalesLine.Modify();
                    //     until SalesLine.Next() = 0;
                    ReleaseSalesDoc.PerformManualRelease(SalesHeader);
                    //SalesHeader.Status := SalesHeader.Status::Released;
                    //SalesHeader.Modify();
                    //Exit('Success');
                end;
            end;
        end; //else
             //exit('Failed');
    end;


    /// <summary>
    /// Order Confirmation for WareHouse function POS.
    /// </summary>
    procedure OrderConfirmationforWH(documentno: Code[20]): Text
    var
        PaymentLine: Record "Payment Lines";
        TotalPayemtamt: Decimal;
        SalesHdr: Record "Sales Header";
        AmountToCust: decimal;
        TotalGSTAmount1: Decimal;
        TotalAmt: Decimal;
        TotalTCSAmt: Decimal;
        SalesRec: record "Sales & Receivables Setup";
        SalesLine: record 37;
        SalesCommLine: Record 44;
        ReleaseSalesDoc: Codeunit "Release Sales Document";
    begin
        clear(TotalGSTAmount1);
        Clear(TotalTCSAmt);
        Clear(TotalAmt);
        SalesRec.Get();


        SalesLine.Reset();
        SalesLine.SetRange("Document No.", DocumentNo);
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        IF SalesLine.FindSet() then
            repeat
                SalesLine.TestField("Salesperson Code");
            until SalesLine.Next() = 0;

        SalesHdr.Reset();
        SalesHdr.SetRange("No.", DocumentNo);
        if SalesHdr.FindFirst() then begin
            SalesHdr.TestField(Status, SalesHdr.Status::Open);
            GetGSTAmountTotal(SalesHdr, TotalGSTAmount1);
            GetTCSAmountTotal(SalesHdr, TotalTCSAmt);
            GetSalesorderStatisticsAmount(SalesHdr, TotalAmt);
            SalesHdr."Amount To Customer" := Round(TotalAmt + TotalGSTAmount1 + TotalTCSAmt, 1);
            SalesHdr.Modify();

            Clear(TotalPayemtamt);
            PaymentLine.Reset();
            PaymentLine.SetRange("Document No.", SalesHdr."No.");
            if PaymentLine.FindSet() then
                repeat
                    TotalPayemtamt += PaymentLine.Amount;
                until PaymentLine.Next() = 0;

            IF TotalPayemtamt <> SalesHdr."Amount To Customer" then
                Error('Sales Order amount is not match with Payment amount')
            else begin
                BankPayentReceiptAutoPost(SalesHdr);
                SalesHdr.Reset();
                SalesHdr.SetRange("No.", SalesHdr."No.");
                If SalesHdr.FindFirst() then begin
                    SalesHdr.Status := SalesHdr.Status::Open;
                    SalesHdr.Modify();
                    //SalesHdr."Staff Id" :=
                    SalesHdr."POS Released Date" := Today;
                    SalesHdr.Validate("Location Code", SalesRec."Default Warehouse");
                    SalesHdr.Modify();

                end;
                SalesLine.Reset();
                SalesLine.SetRange("Document No.", DocumentNo);
                IF SalesLine.FindSet() then
                    repeat
                        SalesLine.Validate("Location Code", SalesRec."Default Warehouse");
                        SalesLine.Validate("Shortcut Dimension 1 Code", SalesHdr."Shortcut Dimension 1 Code");
                        SalesLine.Validate("Shortcut Dimension 2 Code", SalesHdr."Shortcut Dimension 2 Code");
                        SalesLine.Modify();
                        //<< Comment Mandetory so We have to pass Order Comment
                        SalesCommLine.Reset();
                        SalesCommLine.SetRange("No.", SalesHdr."No.");
                        IF Not SalesCommLine.FindFirst() then begin
                            SalesCommLine.Init();
                            SalesCommLine."Document Type" := SalesCommLine."Document Type"::Order;
                            SalesCommLine."No." := SalesHdr."No.";
                            SalesCommLine."Line No." := SalesLine."Line No.";
                            SalesCommLine."Document Line No." := SalesLine."Line No.";
                            SalesCommLine.Insert();
                            SalesCommLine.Comment := 'Document Processed from POS';
                            SalesCommLine.Modify();
                            //>> Comment Mandetory so We have to pass Order Comment
                        end;
                    until SalesLine.Next() = 0;

                ReleaseSalesDoc.PerformManualRelease(SalesHdr);
                //SalesHdr.Status := SalesHdr.Status::Released;
                //SalesHdr.Modify();
            end;
        end else
            exit('Failed');
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
        GenJourLineInit: record 81;
        NoSeriesMgt: Codeunit 396;
        BankAcc: Record 270;
        PaymentLine: Record 50301;
        PaymentMethod: record "Payment Method";
        SR: record "Sales & Receivables Setup";
        RecLocation: Record Location;
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        IF RecLocation.Get(Salesheader."Location Code") then begin
            RecLocation.TestField("Payment Journal Template Name");
            RecLocation.TestField("Payment Journal Batch Name");
        end;

        PaymentLine.Reset();
        PaymentLine.SetRange("Document Type", Salesheader."Document Type");
        PaymentLine.SetRange("Document No.", Salesheader."No.");
        if PaymentLine.FindSet() then
            repeat
                GenJourLine.Reset();
                GenJourLine.SetRange("Journal Template Name", RecLocation."Payment Journal Template Name");
                GenJourLine.SetRange("Journal Batch Name", RecLocation."Payment Journal Batch Name");
                GenJourLineInit.Init();
                GenJourLineInit."Document No." := Salesheader."No.";
                GenJourLineInit.validate("Posting Date", Today);
                IF GenJourLine.FindLast() then
                    GenJourLineInit."Line No." := GenJourLine."Line No." + 10000
                else
                    GenJourLineInit."Line No." := 10000;

                GenJourLineInit."Journal Template Name" := RecLocation."Payment Journal Template Name";
                GenJourLineInit."Journal Batch Name" := RecLocation."Payment Journal Batch Name";
                GenJourLineInit."Document Type" := GenJourLineInit."Document Type"::Payment;
                // GenJourLineInit.Insert();

                //*******Condition Add With Payment Method code*********
                IF PaymentMethod.Get(PaymentLine."Payment Method Code") then begin
                    IF PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"G/L Account" then
                        GenJourLineInit."Account Type" := GenJourLineInit."Account Type"::"G/L Account"
                    else
                        IF PaymentMethod."Bal. Account Type" = PaymentMethod."Bal. Account Type"::"Bank Account" then
                            GenJourLineInit."Account Type" := GenJourLineInit."Account Type"::"Bank Account";
                    GenJourLineInit.validate("Account No.", PaymentMethod."Bal. Account No.");
                end;

                GenJourLineInit."Bal. Account Type" := GenJourLine."Bal. Account Type"::Customer;
                GenJourLineInit.Validate("Bal. Account No.", Salesheader."Sell-to Customer No.");

                GenJourLineInit."GST Group Code" := 'Goods';
                GenJourLineInit.validate(Amount, PaymentLine.Amount);
                GenJourLineInit.Validate("Shortcut Dimension 1 Code", Salesheader."Shortcut Dimension 1 Code");
                GenJourLineInit.Validate("Shortcut Dimension 2 Code", Salesheader."Shortcut Dimension 2 Code");
                GenJourLineInit.Comment := 'Auto Post';
                //GenJourLineInit.modify();
                GenJourLineInit.Insert();
            Until PaymentLine.Next() = 0;
        GenJnlPostBatch.Run(GenJourLineInit);
        //CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJourLine);// then begin
        PaymentLine.Reset();
        PaymentLine.SetRange("Document Type", Salesheader."Document Type");
        PaymentLine.SetRange("Document No.", Salesheader."No.");
        if PaymentLine.FindSet() then
            repeat
                PaymentLine.Posted := True;
                PaymentLine.Modify();
            //IsPaymentLineeditable := PaymentLine.PaymentLinesEditable()
            Until PaymentLine.Next() = 0;
        //end;
    end;
    // <summary>
    /// Update the Unit Price Sales Line
    /// </summary>


    local procedure ApprovalMailSent(SalesLine: Record "Sales Line")
    var
        txtFile: Text[100];
        Window: Dialog;
        txtFileName: Text[100];
        Char: Char;
        recSalesInvHdr: Record 112;
        Recref: RecordRef;
        recCust: Record 18;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        Instr: InStream;
        EMail: Codeunit Email;
        Emailmessage: Codeunit "Email Message";
        Pagelink: Text;
        GLSetup: Record "General Ledger Setup";
        ToRecipients: List of [text];
        SL: Record 37;
        RecUser1: Record "User Setup";
        RecUser2: Record "User Setup";
        RecUser3: Record "User Setup";
    begin
        Sl.Reset();
        SL.SetRange("Document No.", SalesLine."Document No.");
        SL.SetRange("Line No.", SalesLine."Line No.");
        IF SL.FindFirst() then begin
            SL."Approval Status" := SL."Approval Status"::"Pending for Approval";
            SL.Modify();
        end;

        GLSetup.Get();
        GLSetup.TestField("Slab Approval User 1");
        //GLSetup.TestField("Slab Approval User 2");
        //GLSetup.TestField("Slab Approval User 3");
        //Pagelink := GetUrl(ClientType::Current, Rec.CurrentCompany, ObjectType::Page, Page::"Slab Approval List");
        Sl.Reset();
        SL.SetRange("Document No.", SalesLine."Document No.");
        SL.SetRange("Line No.", SalesLine."Line No.");
        IF SL.FindFirst() then
            Pagelink := GETURL(CURRENTCLIENTTYPE, 'Kohinoor Televideo Pvt. Ltd.', ObjectType::Page, 50361, SL, true);

        //  Window.OPEN(
        // 'Sending Mail#######1\');
        IF RecUser1.Get(GLSetup."Slab Approval User 1") then begin
            RecUser1.TestField("E-Mail");
            ToRecipients.Add(RecUser1."E-Mail");
        end;
        /*
        IF RecUser2.Get(GLSetup."Slab Approval User 2") then begin
            RecUser2.TestField("E-Mail");
            ToRecipients.Add(RecUser2."E-Mail");
        end;
        IF RecUser3.Get(GLSetup."Slab Approval User 3") then begin
            RecUser3.TestField("E-Mail");
            ToRecipients.Add(RecUser3."E-Mail");
        end;
        */


        Emailmessage.Create(ToRecipients/*'niwagh16@gmail.com'*/, 'Approval Slab', '', true);
        Emailmessage.AppendToBody('<p><font face="Georgia">Dear <B>Sir,</B></font></p>');
        Char := 13;
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody('<p><font face="Georgia"> <B>!!!Greetings!!!</B></font></p>');
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody('<p><font face="Georgia"><BR>Please find below Approval Link Approve Date</BR></font></p>');
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody('<a href=' + Pagelink + '/">Web Link!</a>');
        Emailmessage.AppendToBody(Pagelink);
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody('<p><font face="Georgia"><BR>Thanking you,</BR></font></p>');

        // Window.UPDATE(1, STRSUBSTNO('%1', 'Mail Sent'));
        EMail.Send(Emailmessage, Enum::"Email Scenario"::Default);
        //Window.CLOSE;
        Sl.Reset();
        SL.SetRange("Document No.", SalesLine."Document No.");
        SL.SetRange("Line No.", SalesLine."Line No.");
        IF SL.FindFirst() then begin
            SL."Approval Sent By" := UserId;
            SL."Approval Sent On" := Today;
            SL.Modify();
        end;
        //Rec."Approval Sent By" := UserId;
        //Rec."Approval Sent On" := Today;
        // Rec.Modify();
        Message('Approval mail sent successfully');

    end;



}