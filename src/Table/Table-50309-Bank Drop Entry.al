table 50309 "Bank Drop Entry"
{
    DataClassification = ToBeClassified;
    Caption = 'Bank Drop Entry';

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
        field(4; Amount; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount';
        }
        field(5; Status; Enum "Bank Drop Status")
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
        }
        field(6; Description; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }

    }

    keys
    {
        key(Key1; "Store No.", "Staff ID", Date)
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