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
                    Editable = false;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    ToolTip = 'Specifies the value of the Transfer-to Code field.';
                    Editable = false;
                }
                field("Transfer-to Name"; Rec."Transfer-to Name")
                {
                    ToolTip = 'Specifies the value of the Transfer-to Name field.';
                    Editable = false;
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
            action("Send for Approval")
            {
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Caption = 'Send for Approval';
                Image = SendApprovalRequest;
                trigger OnAction()
                var
                    RTH: Record "Request Transfer Header";
                begin
                    RTH.Reset();
                    RTH.SetRange("No.", rec."No.");
                    IF RTH.FindFirst() then begin
                        RTH.Status := RTH.Status::"Pending for Approval";
                        RTH.Modify();
                    end;
                end;
            }
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
                    RLocation: Record Location;
                    InvSetup: Record "Inventory Setup";
                //NavAction:Page navi
                begin

                    InvSetup.Get();
                    TransferHeader.Init();
                    TransferHeader."No." := Noseries.GetNextNo(InvSetup."Transfer Order Nos.", Today, true);
                    TransferHeader.Insert(true);
                    TransferHeader."Transfer-from Code" := Rec."Transfer-from Code";
                    TransferHeader."Transfer-to Code" := rec."Transfer-to Code";
                    TransferHeader."Posting Date" := Rec."Posting Date";
                    RLocation.Reset();
                    RLocation.SetRange("Use As In-Transit", true);
                    IF RLocation.FindFirst() then begin
                        TransferHeader."In-Transit Code" := RLocation.Code;
                    end;
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
                    //Message('Transfer Order Craeted with Trasfer Order No. %1', TransferHeader."No.");
                    if InstructionMgt.IsEnabled(InstructionMgt.ShowPostedConfirmationMessageCode()) then
                        ShowPostedConfirmationMessage(TransferHeader."No.");

                end;
            }


        }
    }
    var
        Noseries: Codeunit NoSeriesManagement;
        InstructionMgt: Codeunit "Instruction Mgt.";
        OpenPostedSalesOrderQst: Label 'The transfer Order is Created as number %1 .\\Do you want to open the Transfer Order?', Comment = '%1 = posted document number';



    local procedure ShowPostedConfirmationMessage(TranferNo: code[20])
    var
        TrasferHeader: Record "Transfer Header";
        InstructionMgt: Codeunit "Instruction Mgt.";
    begin

        TrasferHeader.SetRange("No.", TranferNo);
        if TrasferHeader.FindFirst() then
            if InstructionMgt.ShowConfirm(StrSubstNo(OpenPostedSalesOrderQst, TrasferHeader."No."),
                 InstructionMgt.ShowPostedConfirmationMessageCode())
            then
                InstructionMgt.ShowPostedDocument(TrasferHeader, Page::"Transfer Order");
    end;



}
