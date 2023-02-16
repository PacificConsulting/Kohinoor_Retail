codeunit 50303 "POS Procedure"
{
    trigger OnRun()
    begin

    end;

    procedure "Sales Line Deletion"("Document No.": Code[20]; "Line No.": Integer)
    var

        SalesLineDel: Record "Sales Line";
        SalesHeder: Record "Sales Header";
    begin
        SalesHeder.Reset();
        SalesHeder.SetRange("No.", "Document No.");
        SalesHeder.SetRange(Status, SalesHeder.Status::Open);
        IF SalesHeder.FindFirst() then begin
            SalesLineDel.Reset();
            SalesLineDel.SetRange("Document No.", SalesHeder."No.");
            SalesLineDel.SetRange("Line No.", "Line No.");
            IF SalesLineDel.FindFirst() then begin
                SalesLineDel.Delete(true);
                Message('Line deleted successfully......');
            end
        end else
            Error('Please repone sales order %1 status before the delete the Line.', SalesHeder."No.");

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
            Message('Given payment line deleted successfully...');
        end;
    end;

    procedure "Apply Line Discount"(DocumentNo: Code[20]; LineNo: Integer; LineDocuntpara: Text)
    var
        SaleHeaderDisc: Record "Sales Header";
        SalesLineDisc: Record "Sales Line";
        LineDicountDecimal: Decimal;
    begin
        Clear(LineDicountDecimal);
        Evaluate(LineDicountDecimal, LineDocuntpara);
        SaleHeaderDisc.Reset();
        SaleHeaderDisc.SetRange("No.", DocumentNo);
        SaleHeaderDisc.SetRange(Status, SaleHeaderDisc.Status::Open);
        IF SaleHeaderDisc.FindFirst() then begin
            SalesLineDisc.Reset();
            SalesLineDisc.SetRange("Document No.", SaleHeaderDisc."No.");
            SalesLineDisc.SetRange("Line No.", LineNo);
            IF SalesLineDisc.FindFirst() then begin
                SalesLineDisc.validate("Line Discount %", LineDicountDecimal);
                SalesLineDisc.Modify(true);
            end
        end else
            Error('Please repone sales order %1 status before apply discount.', SaleHeaderDisc."No.");

    end;
}