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
        field(2; "Store Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date';
            //Editable = false;

        }
        field(3; "Staff ID"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Staff ID';
            TableRelation = "Staff Master".ID;
            trigger OnValidate()
            var
                STFM: Record "Staff Master";
            begin
                IF STFM.Get("Staff ID") then begin
                    "Store No." := STFM."Store No.";
                end;
            end;
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
        field(7; "Bank Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Bank Account"."No." where(Tender = filter(false));
            Caption = 'Bank Account';
        }
        field(8; "Cash Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
            Caption = 'Cash Account';
        }

    }

    keys
    {
        key(Key1; "Store No.", "Staff ID", "Store Date")
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