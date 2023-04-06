tableextension 50303 "Sales Line Retail" extends "Sales Line"
{
    fields
    {
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

    }
    // trigger OnBeforeModify()
    // begin
    //     IF "Approval Status" = "Approval Status"::"Pending for Approval" then
    //         Error('You can not modify Lines if Approval Status is Pending for Approval ');
    // end;

    // trigger OnAfterInsert()
    // begin
    //     IF "Approval Status" = "Approval Status"::"Pending for Approval" then
    //         Error('You can not modify Lines if Approval Status is Pending for Approval ');
    // end;

    trigger OnModify()
    begin
        IF "Approval Status" = "Approval Status"::"Pending for Approval" then
            Error('You can not modify Lines if Approval Status is Pending for Approval ');
    end;

    trigger OnInsert()
    begin
        IF "Approval Status" = "Approval Status"::"Pending for Approval" then
            Error('You can not modify Lines if Approval Status is Pending for Approval ');
    end;

    trigger OnDelete()
    begin
        IF "Approval Status" = "Approval Status"::"Pending for Approval" then
            Error('You can not modify Lines if Approval Status is Pending for Approval ');
    end;
}
