table 50314 "Data Entry "
{
    Caption = 'Data Entry ';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = ToBeClassified;
        }
        field(2; "Item No"; Code[20])
        {
            Caption = 'Item No';
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
            trigger OnValidate()
            begin
                IF Item.Get("Item No") then begin
                    Description := Item.Description;
                end;
            end;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(4; Qty; Decimal)
        {
            Caption = 'Qty';
            DataClassification = ToBeClassified;
        }
        field(5; Location; Code[10])
        {
            Caption = 'Location';
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(6; "From Location"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
            Caption = 'From Location';
        }
    }
    keys
    {
        key(PK; "Document No.")
        {
            Clustered = true;
        }
    }
    var
        Item: Record 27;
        Location: Record 14;
}
