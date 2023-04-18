pageextension 50313 "General led Setup Ext" extends "General Ledger Setup"
{
    layout
    {
        addafter("Tax Information")
        {
            Group("Bank Drop")
            {
                field("Bank Drop Batch"; Rec."Bank Drop Batch")
                {
                    ApplicationArea = all;
                    Caption = 'Bank Drop Batch';
                }
            }
        }
    }
}
