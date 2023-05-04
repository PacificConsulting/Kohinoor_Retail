tableextension 50312 "General Led.Setup Ext" extends "General Ledger Setup"
{
    fields
    {
        field(50301; "Bank Drop Batch"; Code[10])
        {
            Caption = 'Bank Drop Batch';
            DataClassification = ToBeClassified;
        }
        field(50302; "Slab Approval User 1"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Slab Approval User 1';
            TableRelation = "User Setup"."User ID";
        }
        field(50303; "Slab Approval User 2"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Slab Approval User 2';
            TableRelation = "User Setup"."User ID";
        }
        field(50304; "Slab Approval User 3"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Slab Approval User 3';
            TableRelation = "User Setup"."User ID";
        }
    }
}
