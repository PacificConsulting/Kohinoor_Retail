page 50346 "Request Transfer List"
{
    APIGroup = 'TransferGroup';
    APIPublisher = 'Pacific';
    APIVersion = 'v4.0';
    ApplicationArea = All;
    Caption = 'requestTransferList';
    DelayedInsert = true;
    EntityName = 'RequestTransferList';
    EntitySetName = 'RequestTransferLists';
    PageType = API;
    SourceTable = "Request Transfer Header";
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(staffID; Rec."Staff ID")
                {
                    Caption = 'Staff ID';
                }
                field(transferToCode; Rec."Transfer-to Code")
                {
                    Caption = 'Transfer-to Code';
                }
                field(transferToName; Rec."Transfer-to Name")
                {
                    Caption = 'Transfer-to Name';
                }
                field(transferFromCode; Rec."Transfer-from Code")
                {
                    Caption = 'Transfer-from Code';
                }
                field(transferFromName; Rec."Transfer-from Name")
                {
                    Caption = 'Transfer-from Name';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(status; Rec.Status)
                {
                    Caption = 'Status';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
            }
        }
    }
}
