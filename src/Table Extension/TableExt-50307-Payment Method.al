tableextension 50307 "Payment Method" extends "Payment Method"
{
    fields
    {
        field(50301; Tender; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }

    var
        myInt: Integer;
}