page 50329 "Data Entry List"
{
    ApplicationArea = All;
    Caption = 'Data Entry List';
    PageType = List;
    SourceTable = "Data Entry ";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Item No"; Rec."Item No")
                {
                    ToolTip = 'Specifies the value of the Item No field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Location; Rec.Location)
                {
                    ToolTip = 'Specifies the value of the Location field.';
                }
                field("From Location"; Rec."From Location")
                {
                    ToolTip = 'Specifies the value of the From Location field.';
                }
                field(Qty; Rec.Qty)
                {
                    ToolTip = 'Specifies the value of the Qty field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Create TO")
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Caption = 'Craete TO';
                Image = ServiceSetup;

                trigger OnAction()
                var
                    TH: Record "Transfer Header";
                    TL: Record "Transfer Line";
                begin
                    CurrPage.SetSelectionFilter(Rec);
                    TH.Init();
                    TH."No." := Noseries.GetNextNo('T-ORD', Today, true);
                    TH.Insert(true);
                    TH."Transfer-from Code" := Rec."From Location";
                    TH."Transfer-to Code" := Rec.Location;
                    TH."Posting Date" := Today;
                    TH."In-Transit Code" := 'OWN LOG.';
                    TH.Modify(true);


                    TL.Init();
                    TL."Document No." := TH."No.";
                    TL."Line No." := 10000;
                    TL.Insert(true);
                    TL.Validate("Item No.", Rec."Item No");
                    TL.Validate(Quantity, Rec.Qty);
                    TL.Modify();

                    Message('Transfer Order Craeted with No. %1', TH."No.");

                end;
            }


        }
    }
    var
        Noseries: Codeunit NoSeriesManagement;

}
