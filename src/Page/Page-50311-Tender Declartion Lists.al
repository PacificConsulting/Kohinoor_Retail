page 50311 "Tender Declartion Lists"
{
    ApplicationArea = All;
    Caption = 'Tendor Declartion Lists';
    PageType = List;
    SourceTable = "Tender Declartion Header";
    UsageCategory = Lists;
    CardPageId = "Tender Declartion Card";
    InsertAllowed = false;
    ModifyAllowed = false;



    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Staff ID"; Rec."Staff ID")
                {
                    ToolTip = 'Specifies the value of the Staff ID field.';
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
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Tender Creation")
            {
                ApplicationArea = all;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Create;
                trigger OnAction()
                var
                    TDC: page "Tender Declartion Creation";
                begin
                    TDC.Run();
                end;

            }
        }
    }
}
