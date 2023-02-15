page 50315 "Sales Order Subform API"
{
    APIGroup = 'SalesLineGroup';
    APIPublisher = 'Pacific';
    APIVersion = 'v7.0';
    ApplicationArea = All;
    Caption = 'SalesOrdSubformAPI';
    DelayedInsert = true;
    EntityName = 'SalesLine';
    EntitySetName = 'SalesLines';
    PageType = API;
    SourceTable = "Sales Line";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("type"; Rec."Type")
                {
                    Caption = 'Type';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(Description; Rec.Description)
                {
                    Caption = 'Description';
                    Editable = false;
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(qtyToShip; Rec."Qty. to Ship")
                {
                    Caption = 'Qty. to Ship';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(unitPrice; Rec."Unit Price")
                {
                    Caption = 'Unit Price';
                }
                field(lineAmount; Rec."Line Amount")
                {
                    Caption = 'Line Amount';
                }
                field(hsnSACCode; Rec."HSN/SAC Code")
                {
                    Caption = 'HSN/SAC Code';
                }
                field(gstGroupCode; Rec."GST Group Code")
                {
                    Caption = 'GST Group Code';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                    Editable = false;
                }


            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}