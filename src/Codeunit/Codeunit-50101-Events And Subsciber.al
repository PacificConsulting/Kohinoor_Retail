codeunit 50101 "Event and Subscribers"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterSalesInvLineInsert', '', false, false)]
    local procedure OnAfterSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; var SalesHeader: Record "Sales Header"; var TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; PreviewMode: Boolean)
    var
        PostedPayemntLine: Record "Posted Payment Lines";
        PaymentLine: Record "Payment Lines";
    begin
        PaymentLine.Reset();
        PaymentLine.SetRange("Document Type", SalesHeader."Document Type");
        PaymentLine.SetRange("Document No.", SalesHeader."No.");
        if PaymentLine.FindSet() then
            repeat
                PostedPayemntLine.InitFromPaymentLine(PostedPayemntLine, PaymentLine, SalesInvHeader);
            until PaymentLine.Next() = 0;
        DeletePayemntLines(SalesHeader, PaymentLine);
    end;

    local procedure DeletePayemntLines(salesHeaderRec: record "Sales Header"; RecPaymentLine: Record "Payment Lines")
    var
        myInt: Integer;
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