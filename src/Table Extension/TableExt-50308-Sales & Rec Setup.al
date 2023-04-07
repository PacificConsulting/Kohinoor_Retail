tableextension 50308 "Sales & Rec Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50301; "Default Warehouse"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
    }

    var
        myInt: Integer;
}