page 50362 "Sales Line New Subform"
{
    APIGroup = 'SalesNew';
    APIPublisher = 'Pacific';
    APIVersion = 'v10.0';
    ApplicationArea = All;
    Caption = 'salesLineNewSubform';
    DelayedInsert = true;
    EntityName = 'SalesLineNew';
    EntitySetName = 'SalesLineNews';
    PageType = API;
    SourceTable = "Sales Line";
    ODataKeyFields = SystemId;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'System ID';
                }
                field(documentType; Rec."Document Type")
                {
                    Caption = 'Document Type';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(type; Rec.Type)
                {
                    Caption = 'Type';
                }
                field(ItemNo; Rec."No.")
                {
                    Caption = 'Item No.';
                }
                field(Qty; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(Amount; Rec."Amount")
                {
                    Caption = 'Amount';
                }
                field(AmountIncVat; Rec."Amount Including VAT")
                {
                    Caption = 'Amount Incl. Vat';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        SalesLine: record 37;
    begin
        SalesLine.reset;
        SalesLine.SETRANGE("Document No.", Rec."Document No.");
        IF SalesLine.findlast then
            Rec."Line No." := SalesLine."Line No." + 10000
        else
            Rec."Line No." := 10000;
    end;

}