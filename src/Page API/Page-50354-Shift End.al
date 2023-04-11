page 50354 "Shift End"
{
    APIGroup = 'ShiftGroup';
    APIPublisher = 'Pacific';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'shiftend';
    DelayedInsert = true;
    EntityName = 'Shiftend';
    EntitySetName = 'Shiftends';
    PageType = API;
    SourceTable = "Shift Details";
    ODataKeyFields = SystemId;
    SourceTableView = where("Shift Type" = filter("End"));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field(entryNo; Rec."Entry No.")
                // {
                //     Caption = 'Entry No.';
                //     Editable = false;
                // }
                field(shiftType; Rec."Shift Type")
                {
                    Caption = 'Shift Type';
                }
                field(staffID; Rec."Staff ID")
                {
                    Caption = 'Staff ID';
                }
                field(storeNo; Rec."Store No.")
                {
                    Caption = 'Store No.';
                }
                field("date"; Rec."Date")
                {
                    Caption = 'Date';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }

            }
        }
    }
}
