xmlport 50301 "Trade Aggrement Data Upload"
{
    Caption = 'Trade Aggrement Data Upload';
    DefaultFieldsValidation = true;
    Direction = Import;
    Format = VariableText;
    FormatEvaluate = Legacy;
    schema
    {
        textelement(RootNodeName)
        {
            tableelement(TradeAggrement; "Trade Aggrement")
            {
                XmlName = 'Import';
                fieldelement(Item; TradeAggrement.Item)
                {
                }
                fieldelement(FromDate; TradeAggrement."From Date")
                {
                }
                fieldelement(ToDate; TradeAggrement."To Date")
                {
                }
                fieldelement(LocationCode; TradeAggrement."Location Code")
                {
                }
                fieldelement(AmountInINR; TradeAggrement."Amount In INR")
                {
                }
                fieldelement(PurchasePrice; TradeAggrement."Purchase Price")
                {
                }
                fieldelement(MRP; TradeAggrement."M.R.P")
                {
                }
                fieldelement(DP; TradeAggrement.DP)
                {
                }
                fieldelement(MOP; TradeAggrement.MOP)
                {
                }
                fieldelement(ManagerDiscection; TradeAggrement."Manager Discection")
                {
                }
                fieldelement(LastSellingPrice; TradeAggrement."Last Selling Price")
                {
                }
                fieldelement(NNLC; TradeAggrement.NNLC)
                {
                }
                fieldelement(FNNLC; TradeAggrement.FNNLC)
                {
                }
                fieldelement(Sellout; TradeAggrement.Sellout)
                {
                }
                fieldelement(SelloutText; TradeAggrement."Sellout Text")
                {
                }
                fieldelement(DetailedNNLC; TradeAggrement."Detailed NNLC")
                {
                }
                fieldelement(SLAB1PRICE; TradeAggrement."SLAB 1 - PRICE")
                {
                }
                fieldelement(SLAB1XPRICE; TradeAggrement."SLAB 1 - X-PRICE")
                {
                }
                fieldelement(SLAB2PRICE; TradeAggrement."SLAB 2 - PRICE")
                {
                }
                fieldelement(SLAB2XPRICE; TradeAggrement."SLAB 2 - X-PRICE")
                {
                }
                fieldelement(SLAB2INC; TradeAggrement."SLAB 2 - INC")
                {
                }
                trigger OnAfterInitRecord()
                begin
                    I += 1;
                    IF I = 1 THEN
                        currXMLport.SKIP;
                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPostXmlPort()
    begin
        Message('Data Uploaded Successfully');
    end;

    var
        I: Integer;

}
