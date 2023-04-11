table 50317 "Trade Aggrement"
{
    Caption = 'Trade Aggrement';
    DataClassification = ToBeClassified;


    fields
    {
        field(1; Item; Code[20])
        {
            Caption = 'Item';
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
        }
        field(2; "From Date"; Date)
        {
            Caption = 'From Date';
            DataClassification = ToBeClassified;
        }
        field(3; "To Date"; Date)
        {
            Caption = 'To Date';
            DataClassification = ToBeClassified;
        }
        field(4; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(5; "Amount In INR"; Decimal)
        {
            Caption = 'Amount In INR';
            DataClassification = ToBeClassified;
        }
        field(6; "Purchase Price"; Decimal)
        {
            Caption = 'Purchase Price';
            DataClassification = ToBeClassified;
        }
        field(7; "M.R.P"; Decimal)
        {
            Caption = 'M.R.P';
            DataClassification = ToBeClassified;
        }
        field(8; DP; Decimal)
        {
            Caption = 'DP';
            DataClassification = ToBeClassified;
        }
        field(9; MOP; Decimal)
        {
            Caption = 'MOP';
            DataClassification = ToBeClassified;
        }
        field(10; "Manager Discection"; Decimal)
        {
            Caption = 'Manager Discection';
            DataClassification = ToBeClassified;
        }
        field(11; "Last Selling Price"; Decimal)
        {
            Caption = 'Last Selling Price';
            DataClassification = ToBeClassified;
        }
        field(12; NNLC; Decimal)
        {
            Caption = 'NNLC';
            DataClassification = ToBeClassified;
        }
        field(13; FNNLC; Decimal)
        {
            Caption = 'FNNLC';
            DataClassification = ToBeClassified;
        }
        field(14; Sellout; Decimal)
        {
            Caption = 'Sellout';
            DataClassification = ToBeClassified;
        }
        field(15; "Sellout Text"; Text[50])
        {
            Caption = 'Sellout Text';
            DataClassification = ToBeClassified;
        }
        field(16; "Detailed NNLC"; Text[50])
        {
            Caption = 'Detailed NNLC';
            DataClassification = ToBeClassified;
        }
        field(17; "SLAB 1 - PRICE"; Decimal)
        {
            Caption = 'SLAB 1 - PRICE';
            DataClassification = ToBeClassified;
        }
        field(18; "SLAB 1 - X-PRICE"; Decimal)
        {
            Caption = 'SLAB 1 - X-PRICE';
            DataClassification = ToBeClassified;
        }
        field(19; "SLAB 2 - PRICE"; Decimal)
        {
            Caption = 'SLAB 2 - PRICE';
            DataClassification = ToBeClassified;
        }
        field(20; "SLAB 2 - X-PRICE"; Decimal)
        {
            Caption = 'SLAB 2 - X-PRICE';
            DataClassification = ToBeClassified;
        }
        field(21; "SLAB 2 - INC"; Decimal)
        {
            Caption = 'SLAB 2 - INC';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; Item, "From Date", "To Date", "Location Code")
        {
            Clustered = true;
        }
    }
}
