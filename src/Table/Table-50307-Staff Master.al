table 50307 "Staff Master"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "E-Mail"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Store No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Phone No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; ID)
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