page 50361 "Slab Approval List"
{
    ApplicationArea = All;
    Caption = 'Slab Approval List';
    PageType = List;
    SourceTable = "Sales Line";
    UsageCategory = Lists;
    SourceTableView = where("Approval Status" = filter("Pending for Approval"));

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the document number.';
                    Editable = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ToolTip = 'Specifies the line number.';
                    Editable = false;

                }
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the record.';
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a description of the item or service on the line.';
                    Editable = false;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the price for one unit on the sales line.';
                    Editable = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the inventory location from which the items sold should be picked and where the inventory decrease is registered.';
                    Editable = false;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = ' Specifies the Approval Status for one unit on the sales line.';

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Approved Status")
            {
                Caption = 'Approved Status';
                ApplicationArea = all;
                PromotedCategory = Process;
                Promoted = true;
                PromotedOnly = true;
                Image = Approve;
                trigger OnAction()
                var
                    SalesLine: Record 37;
                begin
                    CurrPage.SetSelectionFilter(SalesLine);
                    SalesLine.SetRange("Approval Status", SalesLine."Approval Status"::"Pending for Approval");
                    IF SalesLine.FindFirst() then begin
                        SalesLine."Approval Status" := SalesLine."Approval Status"::" ";
                        SalesLine.Modify();
                    end;
                end;
            }

        }
    }
}