table 50315 "Request Transfer Line"
{
    DataClassification = ToBeClassified;
    Caption = 'Request Transfer Line';
    //DrillDownPageID = "Transfer Lines";
    //LookupPageID = "Transfer Lines";


    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item WHERE(Type = CONST(Inventory),
                                        Blocked = CONST(false));
            trigger OnValidate()
            var
                RItem: Record 27;
            begin
                IF RItem.Get("Item No.") then begin
                    "Item Description" := RItem.Description;
                end;
            end;
        }
        field(4; "Item Description"; text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Item Unit of Measure".Code WHERE("Item No." = FIELD("Item No."));
        }
        field(6; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }


    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
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