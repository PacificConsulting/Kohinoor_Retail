codeunit 50303 "POS Procedure"
{
    trigger OnRun()
    begin

    end;

    procedure "Sales Line Deletion"("Document No.": Code[20]; "Line No.": Integer)
    var

        SalesLineDel: Record "Sales Line";
        SalesHeder: Record 36;
    begin
        SalesHeder.Reset();
        SalesHeder.SetRange("No.", "Document No.");
        IF SalesHeder.FindFirst() then begin
            SalesLineDel.Reset();
            SalesLineDel.SetRange("Document No.", SalesHeder."No.");
            SalesLineDel.SetRange("Line No.", "Line No.");
            IF SalesLineDel.FindFirst() then begin
                SalesLineDel.Delete(true);
                Message('Line deleted successfully......');
            end
        end;
    end;

    procedure "Sales Order Deletion"(DocumentNo: Code[20])
    var
        SalesHeaderDelete: Record 36;
    begin
        SalesHeaderDelete.Reset();
        SalesHeaderDelete.SetRange("No.", DocumentNo);
        if SalesHeaderDelete.FindFirst() then
            SalesHeaderDelete.DeleteAll(true);

        Message('Sales Order No. %1 delete Successfully...', DocumentNo);
    end;

    procedure "Payment Line Deletion"(DocumentNo: Code[20]; LineNo: Integer)
    var
        PayLineDelete: Record "Payment Lines";
    begin
        PayLineDelete.Reset();
        PayLineDelete.SetRange("Document No.", DocumentNo);
        PayLineDelete.SetRange("Line No.", LineNo);
        if PayLineDelete.FindFirst() then begin
            PayLineDelete.Delete();
            Message('Given Payment Line Deleted Successfully...');
        end;
    end;

    var
        myInt: Integer;
}