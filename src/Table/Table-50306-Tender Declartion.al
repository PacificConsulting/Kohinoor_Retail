table 50306 "Tender Declartion"
{
    DataClassification = ToBeClassified;
    Caption = 'Tender Declartion';

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
        field(3; "Payment Method code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Method code';

        }
        field(4; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';

        }
    }

    keys
    {
        key(Key1; "Store No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}