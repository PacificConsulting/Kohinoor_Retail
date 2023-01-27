tableextension 50102 "Sales Inv Hdr AmtToCust" extends "Sales Invoice Header"
{
    fields
    {
        field(50101; "Amount To Customer"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

}