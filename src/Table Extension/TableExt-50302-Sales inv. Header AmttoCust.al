tableextension 50302 "Sales Inv Hdr AmtToCust" extends "Sales Invoice Header"
{
    fields
    {
        field(50301; "Amount To Customer"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50302; "Store No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Store No.';
            Editable = false;
        }
    }

}