table 50312 "Expense Booking Header"
{
    Caption = 'Expense Booking Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Store No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Store No.';
            Editable = false;

        }
        field(2; Date; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Store Date';
            Editable = false;

        }
        field(3; "Staff ID"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Staff ID';
            TableRelation = "Staff Master".ID;

        }
        field(4; Status; Enum "Bank Drop Status")
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(Key1; "Store No.", "Staff ID", Date)
        {
            Clustered = true;
        }
    }
}
