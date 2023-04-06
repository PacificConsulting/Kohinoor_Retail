page 50334 "Purchase Order Subform API"
{
    APIGroup = 'PurchasGroup';
    APIPublisher = 'Pacific';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'purchaseOrderSubform';
    DelayedInsert = true;
    EntityName = 'PurchaseOrderSubform';
    EntitySetName = 'PurchaseOrderSubforms';
    PageType = API;
    SourceTable = "Purchase Line";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(lineno; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(unitCost; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                }
                field(unitOfMeasure; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(lineAmount; Rec."Line Amount")
                {
                    Caption = 'Line Amount';
                }
                field(tdsSectionCode; Rec."TDS Section Code")
                {
                    Caption = 'TDS Section Code';
                }
                field(qtyToReceive; Rec."Qty. to Receive")
                {
                    Caption = 'Qty. to Receive';
                }
                field(qtyReceivedBase; Rec."Qty. Received (Base)")
                {
                    Caption = 'Qty. Received (Base)';
                }
                field(qtyToInvoice; Rec."Qty. to Invoice")
                {
                    Caption = 'Qty. to Invoice';
                }
                field(qtyInvoicedBase; Rec."Qty. Invoiced (Base)")
                {
                    Caption = 'Qty. Invoiced (Base)';
                }
                field(gstGroupCode; Rec."GST Group Code")
                {
                    Caption = 'GST Group Code';
                }
                field(hsnSACCode; Rec."HSN/SAC Code")
                {
                    Caption = 'HSN/SAC Code';
                }
            }
        }
    }
}
