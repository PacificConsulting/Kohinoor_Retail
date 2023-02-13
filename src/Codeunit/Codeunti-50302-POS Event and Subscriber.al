codeunit 50302 "POS Event and Subscriber"
{
    Access = Public;
    trigger OnRun()
    begin

    end;

    procedure POSAction("Document No.": Code[20]; "Line No.": integer; "POSAction": Text[10]; Parameter: text[10])
    var
        myInt: Integer;
    begin


    end;

}