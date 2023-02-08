pageextension 50305 "Sales Inv Line Subform" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Store No."; Rec."Store No.")
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