table 50311 "Store Expense Configration"
{
    Caption = 'Store Expense Configration';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(2; Name; Text[30])
        {
            Caption = 'Name';
            DataClassification = ToBeClassified;
        }
        field(3; "Store ID"; Code[20])
        {
            Caption = 'Store ID';
            DataClassification = ToBeClassified;
        }
        field(4; "Expense Type"; Text[20])
        {
            Caption = 'Expense Type';
            DataClassification = ToBeClassified;
            TableRelation = "Expense Type".Name;
        }
        field(5; "Max Allowed Exp. Amount"; Decimal)
        {
            Caption = 'Max Allowed Exp. Amount';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
}
