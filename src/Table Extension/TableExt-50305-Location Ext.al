tableextension 50305 "Location_Ext" extends Location
{
    fields
    {
        field(50301; Store; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Store';
        }
    }

    var
        myInt: Integer;
}