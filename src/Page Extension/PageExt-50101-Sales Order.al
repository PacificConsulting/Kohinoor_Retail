pageextension 50101 "Sales Order Payment Ext" extends "Sales Order"
{
    layout
    {
        addafter(SalesLines)
        {
            part(PaymentLine; "Payment Lines Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
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