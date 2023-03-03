table 50313 "Expense Booking Lines"
{
    Caption = 'Expense Booking Lines';
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
        field(4; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(5; "Expense Type"; Text[20])
        {
            Caption = 'Expense Type';
            DataClassification = ToBeClassified;
            TableRelation = "Expense Type".Name;
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Store No.", "Staff ID", Date, "Line No.")
        {
            Clustered = true;
        }
    }
}
