page 50308 "Tender Declartion API Hdr"
{
    APIGroup = 'TenderGroup';
    APIPublisher = 'Pacific';
    APIVersion = 'v5.0';
    ApplicationArea = All;
    Caption = 'TenderDeclartionAPIHdr';
    DelayedInsert = true;
    EntityName = 'TenderDeclartionHdr';
    EntitySetName = 'TenderDeclartionHdrs';
    PageType = API;
    SourceTable = "Tender Declartion Header";
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

            }
        }
    }
}
