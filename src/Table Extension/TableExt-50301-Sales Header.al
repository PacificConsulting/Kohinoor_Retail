tableextension 50301 Sales_Header_AmttoCust extends "Sales Header"
{
    fields
    {
        modify("Location Code")
        {
            trigger OnAfterValidate()
            var
                RecLoc: Record Location;
            begin
                IF RecLoc.Get("Location Code") then begin
                    "Store No." := "Location Code";
                    //Validate("Shortcut Dimension 1 Code",RecLoc.glo);
                end;


            end;
        }
        field(50301; "Amount To Customer"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Amount To Customer';
        }
        field(50302; "Store No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Store No.';
        }
    }

    var
        myInt: Integer;

    trigger OnDelete()
    var
        PayLine: Record "Payment Lines";
    begin
        PayLine.Reset();
        PayLine.SetRange("Document No.", "No.");
        PayLine.SetRange("Document Type", "Document Type");
        IF PayLine.FindSet() then
            repeat
                PayLine.Delete();
            until PayLine.Next() = 0;
    end;
}