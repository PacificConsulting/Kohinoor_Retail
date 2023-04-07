pageextension 50309 "Payment Methods" extends "Payment Methods"
{
    layout
    {
        addafter(Description)
        {
            field(Tender; Rec.Tender)
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