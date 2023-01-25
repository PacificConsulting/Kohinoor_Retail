table 50102 "Posted Payment Lines"
{
    DataClassification = ToBeClassified;
    Caption = 'Posted Payment Lines';
    Extensible = false;

    fields
    {
        field(1; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
            Editable = false;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type"));
            Editable = false;
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(4; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
            Editable = false;

        }
        field(5; Description; Text[100])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
            Editable = false;
        }
        field(7; Posted; Boolean)
        {
            Caption = 'Posted';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }


    procedure InitFromPaymentLine(PostedpaymentLine: Record "Posted Payment Lines"; PaymentLine: Record "Payment Lines"; SalesInvHdr: Record "Sales Invoice Header")
    begin
        PostedpaymentLine.Init();
        PostedpaymentLine.TransferFields(PaymentLine);
        PostedpaymentLine."Document No." := SalesInvHdr."No.";
        PostedpaymentLine.Insert();
    end;

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