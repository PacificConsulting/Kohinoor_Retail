page 50312 "Tender Declartion Card"
{
    ApplicationArea = All;
    Caption = 'Tender Declartion Card';
    PageType = Card;
    SourceTable = "Tender Declartion Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Staff ID"; Rec."Staff ID")
                {
                    ToolTip = 'Specifies the value of the Staff ID field.';
                    Editable = false;
                }
                field("Store No."; Rec."Store No.")
                {
                    ToolTip = 'Specifies the value of the Store No. field.';
                }
                field("Store Date"; Rec."Store Date")
                {
                    ToolTip = 'Specifies the value of the Store Date field.';
                }

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status';
                }

            }
            part(Lines; "Tender Declartion Subform")
            {
                ApplicationArea = all;
                SubPageLink = "Staff ID" = field("Staff ID"), "Store No." = field("Store No."), "Store Date" = field("Store Date");
            }
        }
    }
}
