table 50101 "Payment Lines"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
            trigger OnValidate()
            var
                PayMeth: Record "Payment Method";
            begin
                IF PayMeth.Get(Rec."Payment Method Code") then begin
                    Description := PayMeth.Description;
                end;
            end;
        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(7; Posted; Boolean)
        {
            Caption = 'Posted';
        }
    }


    keys
    {
        key(Key1; "Document Type", "Document No.", "Line No.")
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