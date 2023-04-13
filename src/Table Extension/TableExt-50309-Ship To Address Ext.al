tableextension 50309 "Ship To Address Ext" extends "Ship-to Address"
{
    fields
    {

        field(50301; "Ship Type"; Enum "Ship To Address Option")
        {
            Caption = 'Ship Type';
            DataClassification = ToBeClassified;
        }
    }
}
