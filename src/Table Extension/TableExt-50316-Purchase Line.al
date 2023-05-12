tableextension 50316 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                TradeAggre: record "Trade Aggrement";
                PurchHeder: record 38;
            begin
                IF PurchHeder.Get(rec."Document Type", rec."Document No.") then;
                TradeAggre.Reset();
                TradeAggre.SetRange("Item No.", Rec."No.");
                TradeAggre.SetRange("Location Code", PurchHeder."Location Code");
                TradeAggre.SetFilter("From Date", '<=%1', PurchHeder."Posting Date");
                TradeAggre.SetFilter("To Date", '>=%1', PurchHeder."Posting Date");
                IF TradeAggre.FindFirst() then begin
                    Validate("Direct Unit Cost", TradeAggre."Purchase Price");
                    //"Price Inclusive of Tax" := true;
                end else begin
                    TradeAggre.SetRange("Location Code");
                    IF TradeAggre.FindFirst() then begin
                        Validate("Direct Unit Cost", TradeAggre."Purchase Price");
                        // "Price Inclusive of Tax" := true
                    end;
                end;

                // Validate("Unit Price Incl. of Tax", 25000);
                //Validate("Price Inclusive of Tax", true);
                //"Price Inclusive of Tax" := true;
            end;

        }
    }


    var
        myInt: Integer;
}