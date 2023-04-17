tableextension 50303 "Sales Line Retail" extends "Sales Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                TradeAggre: record "Trade Aggrement";
                SalesHeder: record 36;
            begin
                /*
                IF SalesHeder.Get(rec."Document Type", rec."Document No.") then;
                TradeAggre.Reset();
                TradeAggre.SetRange(Item, Rec."No.");
                TradeAggre.SetRange("Location Code", SalesHeder."Location Code");
                TradeAggre.SetFilter("From Date", '<=%1', SalesHeder."Posting Date");
                TradeAggre.SetFilter("To Date", '>=%1', SalesHeder."Posting Date");
                IF TradeAggre.FindFirst() then begin
                    Validate("Unit Price Incl. of Tax", TradeAggre."M.R.P");
                    Validate("Price Inclusive of Tax", true);
                end;
                */
                Validate("Unit Price Incl. of Tax", 25000);
                Validate("Price Inclusive of Tax", true);
            end;
        }
        field(50301; "Store No."; Code[20])
        {
            Caption = 'Store No.';
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;

        }
        field(50302; "Approval Status"; Enum "Sales Line Approval Status")
        {
            DataClassification = ToBeClassified;

        }
        field(50303; "Approval Sent By"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50304; "Approval Sent On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50305; "Approved By"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50306; "Approved On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50307; "Old Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50308; "Exchange Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
        }
        field(50309; "Serial No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50310; "GST Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }

    }

    trigger OnModify()
    begin
        IF "Approval Status" = "Approval Status"::"Pending for Approval" then
            Error('You can not modify Lines if Approval Status is Pending for Approval ');
    end;

    trigger OnInsert()
    var
        RecLoc: Record Location;
        SalesHeader: Record 36;
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("No.", "Document No.");
        IF SalesHeader.FindFirst() then begin
            IF SalesHeader."Store No." <> '' then begin
                RecLoc.Reset();
                RecLoc.SetRange(Store, true);
                RecLoc.SetRange(Code, SalesHeader."Store No.");
                IF RecLoc.FindFirst() then begin
                    Validate("Location Code", RecLoc.Code);
                    "Store No." := RecLoc.Code;

                end;
            end;
        end;
        IF "Approval Status" = "Approval Status"::"Pending for Approval" then
            Error('You can not modify Lines if Approval Status is Pending for Approval ');
    end;


    trigger OnDelete()
    begin
        IF "Approval Status" = "Approval Status"::"Pending for Approval" then
            Error('You can not modify Lines if Approval Status is Pending for Approval ');
    end;
}
