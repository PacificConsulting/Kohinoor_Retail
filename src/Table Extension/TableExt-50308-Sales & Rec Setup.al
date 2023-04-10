tableextension 50308 "Sales & Rec Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50301; "Default Warehouse"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(50302; "Exchange Item G/L"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
    }

    var
        I: record 27;
}