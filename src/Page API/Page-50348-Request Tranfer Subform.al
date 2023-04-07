page 50348 "Request Tranfer Subform"
{
    APIGroup = 'TransferGroup';
    APIPublisher = 'Pacific';
    APIVersion = 'v4.0';
    ApplicationArea = All;
    Caption = 'requestTranferSubform';
    DelayedInsert = true;
    EntityName = 'RequestTranferSubform';
    EntitySetName = 'RequestTranferSubforms';
    PageType = API;
    SourceTable = "Request Transfer Line";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(itemNo; Rec."Item No.")
                {
                    Caption = 'Item No.';
                }
                field(itemDescription; Rec."Item Description")
                {
                    Caption = 'Item Description';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(unitOfMeasureCode; Rec."Unit of Measure Code")
                {
                    Caption = 'Unit of Measure Code';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
