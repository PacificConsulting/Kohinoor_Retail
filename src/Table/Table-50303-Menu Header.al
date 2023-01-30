table 50303 "Menu Header"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Menu ID"; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; "Menu Name"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Creation ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Creation Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Menu ID")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin
        "Creation ID" := UserId;
        "Creation Date" := Today;
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