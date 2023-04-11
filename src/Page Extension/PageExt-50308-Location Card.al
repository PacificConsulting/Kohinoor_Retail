pageextension 50308 Location_Card extends "Location Card"
{
    layout
    {
        addafter("Use As In-Transit")
        {
            field(Store; Rec.Store)
            {
                ApplicationArea = all;
            }
            field("Cash Account No."; Rec."Cash Account No.")
            {
                ApplicationArea = all;
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