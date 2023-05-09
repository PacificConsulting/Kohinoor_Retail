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
        field(50303; "Payment Journal Template Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            //TableRelation = "Gen. Journal Batch"."Journal Template Name";
        }
        field(50304; "Payment Journal Batch Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            // TableRelation = "Gen. Journal Batch".Name;
        }
    }

    var
        myInt: Integer;
}