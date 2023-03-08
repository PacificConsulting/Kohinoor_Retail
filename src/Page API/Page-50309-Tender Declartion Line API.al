page 50309 "Tender Declartion API Line "
{
    APIGroup = 'TenderGroup';
    APIPublisher = 'Pacific';
    APIVersion = 'v6.0';
    ApplicationArea = All;
    Caption = 'TenderDeclartionAPIline';
    DelayedInsert = true;
    EntityName = 'TenderDeclartionLine';
    EntitySetName = 'TenderDeclartionHdrLines';
    PageType = API;
    SourceTable = "Tender Declartion Line ";
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(storeNo; Rec."Store No.")
                {
                    Caption = 'Store No.';
                }
                field(staffID; Rec."Staff ID")
                {
                    Caption = 'Staff ID';
                }
                field(storeDate; Rec."Store Date")
                {
                    Caption = 'Store Date';
                }
                field(lineNo; Rec."Line No.")
                {
                    Caption = 'Line No.';
                }
                field(paymentMethodCode; Rec."Payment Method code")
                {
                    Caption = 'Payment Method code';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}