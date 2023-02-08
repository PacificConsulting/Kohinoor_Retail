tableextension 50304 "Sales inv. Line Retail" extends "Sales Invoice Line"
{
    fields
    {
        field(50301; "Store No."; Code[20])
        {
            Caption = 'Store No.';
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }
}
