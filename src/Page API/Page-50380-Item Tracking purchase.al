page 50380 ItemTrackingPurchase
{
    APIGroup = 'ItemTrackingGroup';
    APIPublisher = 'Pacific';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'ItemTrackingPurchase';
    DelayedInsert = true;
    EntityName = 'ItemTrackingPurchase';
    EntitySetName = 'ItemTrackingPurchases';
    PageType = API;
    SourceTable = "Reservation Entry";
    ODataKeyFields = SystemId;
    SourceTableView = where("Source Type" = filter(39));

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
                field(serialNo; Rec."Serial No.")
                {
                    Caption = 'Serial No.';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
            }
        }
    }
}
