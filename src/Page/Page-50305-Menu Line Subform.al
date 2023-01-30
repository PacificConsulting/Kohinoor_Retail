page 50305 "Menu Line Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Menu Line";



    layout
    {
        area(Content)
        {
            repeater(Control001)
            {

                field("Menu Line"; Rec."Menu Line")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Menu Line field.';
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Action"; Rec."Action")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Action field.';
                }
                field(Parameter; Rec.Parameter)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Parameter field.';
                }
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