pageextension 50310 "Sales & Receivables Setup Ext" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("GST Dependency Type")
        {
            field("Default Warehouse"; Rec."Default Warehouse")
            {
                ApplicationArea = all;
            }
            field("Exchange Item G/L"; Rec."Exchange Item G/L")
            {
                ApplicationArea = all;
            }
        }
    }
}
