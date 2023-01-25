tableextension 50101 Sales_Header_AmttoCust extends "Sales Header"
{
    fields
    {
        field(50101; "Amount To Customer"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    var
        myInt: Integer;
}