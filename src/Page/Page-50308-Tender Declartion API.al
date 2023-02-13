page 50308 "Tender Declartion API"
{
    APIGroup = 'TenderGroup';
    APIPublisher = 'Pacific';
    APIVersion = 'v5.0';
    ApplicationArea = All;
    Caption = 'tenderDeclartionAPI';
    DelayedInsert = true;
    EntityName = 'TenderDeclartion';
    EntitySetName = 'TenderDeclartions';
    PageType = API;
    SourceTable = "Tender Declartion";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(storeNo; Rec."Store No.")
                {
                    Caption = 'Store No.';
                }
                field(storeDate; Rec."Store Date")
                {
                    Caption = 'Store Date';
                }
                field(paymentMethodCode; Rec."Payment Method code")
                {
                    Caption = 'Payment Method code';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
            }
        }
    }
}
