pageextension 50315 Cust_card extends "Customer Card"
{
    layout
    {
        modify("Search Name")
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}