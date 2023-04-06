page 50329 "Request Transfer Order"
{
    ApplicationArea = All;
    Caption = 'Request Transfer Order';
    SourceTable = "Request Transfer Header";
    PageType = Document;
    RefreshOnActivate = true;


    layout
    {
        area(content)
        {
            group(General)

            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update();
                    end;
                }
                field("Staff ID"; Rec."Staff ID")
                {
                    ToolTip = 'Specifies the value of the Staff ID field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    ToolTip = 'Specifies the value of the Transfer-from Code field.';
                }
                field("Transfer-from Name"; Rec."Transfer-from Name")
                {
                    ToolTip = 'Specifies the value of the Transfer-from Name field.';
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ToolTip = 'Specifies the value of the Transfer-to Code field.';
                }
                field("Transfer-to Name"; Rec."Transfer-to Name")
                {
                    ToolTip = 'Specifies the value of the Transfer-to Name field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }

            }
            part(RequestTransferLines; "Request Tranfer Ord. Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Submit Transfer Order")
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Caption = 'Submit Transfer Order';
                Image = TransferOrder;

                trigger OnAction()
                var
                    TransferHeader: Record "Transfer Header";
                    TransferLine: Record "Transfer Line";
                    RrqTransferLine: Record "Request Transfer Line";
                begin

                    TransferHeader.Init();
                    TransferHeader."No." := Noseries.GetNextNo('T-ORD', Today, true);
                    TransferHeader.Insert(true);
                    TransferHeader."Transfer-from Code" := Rec."Transfer-from Code";
                    // TransferHeader."Transfer-to Code" := ;
                    TransferHeader."Posting Date" := Rec."Posting Date";
                    // TransferHeader."In-Transit Code" := 'OWN LOG.';
                    TransferHeader.Modify(true);

                    RrqTransferLine.Reset();
                    RrqTransferLine.SetRange("Document No.", Rec."No.");
                    IF RrqTransferLine.FindSet() then
                        repeat
                            TransferLine.Init();
                            TransferLine."Document No." := TransferHeader."No.";
                            TransferLine."Line No." := RrqTransferLine."Line No.";
                            TransferLine.Insert(true);
                            TransferLine.Validate("Item No.", RrqTransferLine."Item No.");
                            TransferLine.Validate(Quantity, RrqTransferLine.Quantity);
                            TransferLine.Modify();
                        until RrqTransferLine.Next() = 0;
                    TransferHeader.Status := TransferHeader.Status::Released;
                    TransferHeader.Modify();
                    // Message('Transfer Order Craeted wiTransferHeader No. %1', TransferHeader."No.");

                end;
            }


        }
    }
    var
        Noseries: Codeunit NoSeriesManagement;

}
