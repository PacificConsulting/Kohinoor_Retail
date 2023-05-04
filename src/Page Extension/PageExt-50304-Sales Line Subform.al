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
            field("Approval Status"; Rec."Approval Status")
            {
                ApplicationArea = all;
            }
            field("Approval Sent By"; Rec."Approval Sent By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Approval Sent By field.';
            }
            field("Approval Sent On"; Rec."Approval Sent On")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Approval Sent On field.';
            }
            field("Approved By"; Rec."Approved By")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Approved By field.';
            }
            field("Approved On"; Rec."Approved On")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Approved On field.';
            }
            field("Old Unit Price"; Rec."Old Unit Price")
            {
                ApplicationArea = all;
            }
            field("Salesperson Code"; Rec."Salesperson Code")
            {
                ApplicationArea = all;
            }
        }
        addafter("Unit Price Incl. of Tax")
        {
            field("GST Tax Amount"; Rec."GST Tax Amount")
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the GST Tax Amount.';

            }
        }
    }


    actions
    {
        // Add changes to page actions here
    }

    // trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    // var
    //     SalesLine: record 37;
    // begin
    //     SalesLine.reset;
    //     SalesLine.SETRANGE("Document No.", 'PCORD2');
    //     IF SalesLine.findlast then begin
    //         SalesLine."Document Type" := SalesLine."Document Type"::Order;
    //         SalesLine."Document No." := SalesLine."Document No.";
    //         SalesLine."Line No." := SalesLine."Line No." + 10000;
    //         SalesLine.Insert();
    //         //Rec.modify;
    //     end
    //     else begin
    //         SalesLine."Document Type" := SalesLine."Document Type"::Order;
    //         SalesLine."Document No." := SalesLine."Document No.";
    //         SalesLine."Line No." := 10000;
    //         SalesLine.Insert();
    //         //Rec.modify;
    //     end;

    // end;


    var
        myInt: Integer;
}