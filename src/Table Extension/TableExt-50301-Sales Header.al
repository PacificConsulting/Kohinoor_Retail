tableextension 50301 Sales_Header_AmttoCust extends "Sales Header"
{
    fields
    {
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