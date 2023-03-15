tableextension 50303 "Sales Line Retail" extends "Sales Line"
{
    fields
    {
        field(50301; "Store No."; Code[20])
        {
            Caption = 'Store No.';
            DataClassification = ToBeClassified;
        }
        field(50302; "Approval Status"; Option)
        {
            DataClassification = ToBeClassified;
            // OptionCaption = 'Open','Release';
            OptionMembers = Open,Relase;

        }

    }
}
