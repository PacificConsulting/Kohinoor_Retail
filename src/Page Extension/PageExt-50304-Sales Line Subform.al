pageextension 50304 "Sales Line Subform" extends "Sales Order Subform"
{
    layout
    {
        addafter(Quantity)
        {
            field("Store No."; Rec."Store No.")
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