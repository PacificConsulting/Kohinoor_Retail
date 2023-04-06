page 50341 "Customer List API"
{
    APIGroup = 'CustomerGroup';
    APIPublisher = 'Pacific';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'customerList';
    DelayedInsert = true;
    EntityName = 'CustomerList';
    EntitySetName = 'CustomerLists';
    PageType = API;
    SourceTable = Customer;
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'SystemID';
                }
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(contact; Rec.Contact)
                {
                    Caption = 'Contact';
                }
                field(balanceLCY; Rec."Balance (LCY)")
                {
                    Caption = 'Balance (LCY)';
                }
                field(balanceDueLCY; Rec."Balance Due (LCY)")
                {
                    Caption = 'Balance Due (LCY)';
                }
                field(salesLCY; Rec."Sales (LCY)")
                {
                    Caption = 'Sales (LCY)';
                }
                field(paymentsLCY; Rec."Payments (LCY)")
                {
                    Caption = 'Payments (LCY)';
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                }
            }
        }
    }
}
