pageextension 50302 "Posted Sales invoice Retail" extends "Posted Sales Invoice"
{
    layout
    {
        addafter(SalesInvLines)
        {
            part(PaymentLine; "Posted Payment Lines Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
                Editable = false;
            }
        }
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