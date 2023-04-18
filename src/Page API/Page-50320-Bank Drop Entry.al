page 50320 "Bank Drop Entry"
{
    APIGroup = 'BankGroup';
    APIPublisher = 'Pacific';
    APIVersion = 'v10.0';
    ApplicationArea = All;
    Caption = 'bankDropEntry';
    DelayedInsert = true;
    EntityName = 'BankDropEntry';
    EntitySetName = 'BankDropEntrys';
    PageType = API;
    SourceTable = "Bank Drop Entry";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(staffID; Rec."Staff ID")
                {
                    Caption = 'Staff ID';
                }
                field(storeNo; Rec."Store No.")
                {
                    Caption = 'Store No.';
                }
                field("date"; Rec."Store Date")
                {
                    Caption = 'Store Date';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                // field(bankAccount; Rec."Bank Account")
                // {
                //     Caption = 'Bank Account';
                // }
                // field(cashAccount; Rec."Cash Account")
                // {
                //     Caption = 'Cash Account';
                // }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
