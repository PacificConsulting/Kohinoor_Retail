page 50104 "Menu Card"
{
    PageType = Card;
    Caption = 'Menu Card';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Menu Header";
    RefreshOnActivate = true;
    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Menu ID"; Rec."Menu ID")
                {
                    ToolTip = 'Specifies the value of the Menu ID field.';
                }
                field("Menu Name"; Rec."Menu Name")
                {
                    ToolTip = 'Specifies the value of the Menu Name field.';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ToolTip = 'Specifies the value of the Creation Date field.';
                    Editable = false;
                }
                field("Creation ID"; Rec."Creation ID")
                {
                    ToolTip = 'Specifies the value of the Creation ID field.';
                    Editable = false;
                }

            }
            part(Lines; "Menu Line Subform")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Menu ID" = field("Menu ID");

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}