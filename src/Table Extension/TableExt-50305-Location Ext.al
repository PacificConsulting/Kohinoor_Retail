tableextension 50305 "Location_Ext_retail" extends Location
{
    fields
    {
        field(50301; Store; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Store';
        }
        field(50302; "Cash Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
    }

    var
        myInt: Integer;
}