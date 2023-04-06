codeunit 50301 "Event and Subscribers"
{
    trigger OnRun()
    begin

    end;
    //START**********************************Codeunit-80***************************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesInvLineInsert', '', false, false)]
    local procedure OnAfterSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; var SalesHeader: Record "Sales Header"; var TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; PreviewMode: Boolean)
    var
        PostedPayemntLine: Record "Posted Payment Lines";
        PaymentLine: Record "Payment Lines";
    begin
        PostedPayemntLine.Reset();
        PostedPayemntLine.SetRange("Document No.", SalesInvHeader."No.");
        IF not PostedPayemntLine.Find() then begin
            PaymentLine.Reset();
            PaymentLine.SetRange("Document Type", SalesHeader."Document Type");
            PaymentLine.SetRange("Document No.", SalesHeader."No.");
            if PaymentLine.FindSet() then
                repeat
                    PostedPayemntLine.InitFromPaymentLine(PostedPayemntLine, PaymentLine, SalesInvHeader);
                until PaymentLine.Next() = 0;
            DeletePayemntLines(SalesHeader, PaymentLine);
        end;
    end;
    //********below given code for auto ship all order for POS*****************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforeSetPostingFlags', '', false, false)]
    // local procedure OnBeforePostSalesLines(var SalesHeader: Record "Sales Header"; var TempSalesLineGlobal: Record "Sales Line" temporary; var TempVATAmountLine: Record "VAT Amount Line" temporary; var EverythingInvoiced: Boolean)
    // begin
    //     IF SalesHeader."Store No." <> '' then begin
    //         SalesHeader.Ship := true;
    //         SalesHeader.Invoice := false;
    //     end
    // end;
    local procedure OnBeforeSetPostingFlags(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        IF SalesHeader."Store No." <> '' then begin
            SalesHeader.Ship := true;
            SalesHeader.Invoice := true;
        end
    end;
    //END**********************************Codeunit-80***************************************

    //START**********************************Codeunit-90***************************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterSetPostingFlags', '', false, false)]
    local procedure OnAfterSetPostingFlags(var PurchHeader: Record "Purchase Header")
    begin
        // IF PurchHeader."Store No." then begin
        PurchHeader.Receive := true;
        PurchHeader.Invoice := false;
        //end;
    end;
    //START**********************************Codeunit-5704***************************************
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeTransferOrderPostShipment', '', false, false)]
    local procedure OnBeforeTransferOrderPostShipment(var TransferHeader: Record "Transfer Header"; var CommitIsSuppressed: Boolean)
    begin

    end;
    //END**********************************Codeunit-5704***************************************
    local procedure DeletePayemntLines(salesHeaderRec: record "Sales Header"; RecPaymentLine: Record "Payment Lines")
    var
    begin
        RecPaymentLine.Reset();
        RecPaymentLine.SetRange("Document Type", salesHeaderRec."Document Type");
        RecPaymentLine.SetRange("Document No.", salesHeaderRec."No.");
        if RecPaymentLine.FindFirst() then
            RecPaymentLine.DeleteAll();
    end;


    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforeCheckTotalInvoiceAmount', '', false, false)]
    // local procedure OnRunOnBeforeCheckTotalInvoiceAmount(var SalesHeader: Record "Sales Header")
    // var
    //     TempPaymentLineRec: Record 50101 temporary;
    // begin
    //     Cod50101.CopyToTempPaymentLines(SalesHeader, TempPaymentLineRec);

    // end;

    // procedure CopyToTempPaymentLines(SalesHeader: Record "Sales Header"; var TempPaymentLine: Record 50101 temporary)
    // var
    //     PaymentLine: Record 50101;
    // begin
    //     PaymentLine.SetRange("Document Type", SalesHeader."Document Type");
    //     PaymentLine.SetRange("Document No.", SalesHeader."No.");
    //     if PaymentLine.FindSet() then
    //         repeat
    //             TempPaymentLine := PaymentLine;
    //             TempPaymentLine.Insert();
    //         until PaymentLine.Next() = 0;

    // end;

    var

}