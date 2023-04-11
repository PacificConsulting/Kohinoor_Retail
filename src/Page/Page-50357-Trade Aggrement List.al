page 50357 "Trade Aggrement List"
{
    ApplicationArea = All;
    Caption = 'Trade Aggrement List';
    PageType = List;
    SourceTable = "Trade Aggrement";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Item; Rec.Item)
                {
                    ToolTip = 'Specifies the value of the Item field.';
                }
                field("From Date"; Rec."From Date")
                {
                    ToolTip = 'Specifies the value of the From Date field.';
                }
                field("To Date"; Rec."To Date")
                {
                    ToolTip = 'Specifies the value of the To Date field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Amount In INR"; Rec."Amount In INR")
                {
                    ToolTip = 'Specifies the value of the Amount In INR field.';
                }
                field(DP; Rec.DP)
                {
                    ToolTip = 'Specifies the value of the DP field.';
                }
                field("Detailed NNLC"; Rec."Detailed NNLC")
                {
                    ToolTip = 'Specifies the value of the Detailed NNLC field.';
                }
                field(FNNLC; Rec.FNNLC)
                {
                    ToolTip = 'Specifies the value of the FNNLC field.';
                }
                field("Last Selling Price"; Rec."Last Selling Price")
                {
                    ToolTip = 'Specifies the value of the Last Selling Price field.';
                }
                field("M.R.P"; Rec."M.R.P")
                {
                    ToolTip = 'Specifies the value of the M.R.P field.';
                }
                field(MOP; Rec.MOP)
                {
                    ToolTip = 'Specifies the value of the MOP field.';
                }
                field("Manager Discection"; Rec."Manager Discection")
                {
                    ToolTip = 'Specifies the value of the Manager Discection field.';
                }
                field(NNLC; Rec.NNLC)
                {
                    ToolTip = 'Specifies the value of the NNLC field.';
                }
                field("Purchase Price"; Rec."Purchase Price")
                {
                    ToolTip = 'Specifies the value of the Purchase Price field.';
                }
                field("SLAB 1 - PRICE"; Rec."SLAB 1 - PRICE")
                {
                    ToolTip = 'Specifies the value of the SLAB 1 - PRICE field.';
                }
                field("SLAB 1 - X-PRICE"; Rec."SLAB 1 - X-PRICE")
                {
                    ToolTip = 'Specifies the value of the SLAB 1 - X-PRICE field.';
                }
                field("SLAB 2 - INC"; Rec."SLAB 2 - INC")
                {
                    ToolTip = 'Specifies the value of the SLAB 2 - INC field.';
                }
                field("SLAB 2 - PRICE"; Rec."SLAB 2 - PRICE")
                {
                    ToolTip = 'Specifies the value of the SLAB 2 - PRICE field.';
                }
                field("SLAB 2 - X-PRICE"; Rec."SLAB 2 - X-PRICE")
                {
                    ToolTip = 'Specifies the value of the SLAB 2 - X-PRICE field.';
                }
                field(Sellout; Rec.Sellout)
                {
                    ToolTip = 'Specifies the value of the Sellout field.';
                }
                field("Sellout Text"; Rec."Sellout Text")
                {
                    ToolTip = 'Specifies the value of the Sellout Text field.';
                }
            }
        }
    }
}
