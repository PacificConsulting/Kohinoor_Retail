table 50307 "Tender Declartion Line "
{
    fields
    {
        field(1; "Store No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Store No.';

        }
        field(2; "Store Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Store Date';

        }
        field(3; "Staff ID"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Staff ID';
            TableRelation = "Staff Master".ID;
        }
        field(4; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No.';
        }

        field(5; "Payment Method code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Method code';
            TableRelation = "Payment Method".Code;
        }
        field(6; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';
        }  // Add changes to table fields here
    }
    keys
    {
        key(Key1; "Store No.", "Store Date", "Staff ID", "Line No.")
        {
            Clustered = true;
        }
    }


    var
        myInt: Integer;
}