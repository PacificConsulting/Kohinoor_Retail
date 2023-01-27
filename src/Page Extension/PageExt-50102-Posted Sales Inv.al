pageextension 50102 "Posted Sales inv AmtToCust" extends "Posted Sales Invoice"
{
    layout
    {
        addafter(Closed)
        {
            field("Amount To Customer"; Rec."Amount To Customer")
            {
                ApplicationArea = all;
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}