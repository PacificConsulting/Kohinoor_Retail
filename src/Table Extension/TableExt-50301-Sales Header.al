tableextension 50301 Sales_Header_AmttoCust extends "Sales Header"
{
    fields
    {
        field(50301; "Amount To Customer"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    var
        myInt: Integer;
}