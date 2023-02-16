codeunit 50302 "POS Event and Subscriber"
{
    Access = Public;
    trigger OnRun()
    begin

    end;

    procedure POSAction("Document No.": Code[20]; "Line No.": integer; "POSAction": Text[10]; Parameter: text[10])
    var
        myInt: Integer;
        POSProcedure: Codeunit 50303;
    begin
        case POSAction of
            'VOIDL':
                POSProcedure."Sales Line Deletion"("Document No.", "Line No.");
            'VOIDT':
                POSProcedure."Sales Order Deletion"("Document No.");
            'VOIDP':
                POSProcedure."Payment Line Deletion"("Document No.", "Line No.");
            'INVDISC':
                Message('Hi1');
            'LINEDISC':
                Message('Hi2');
            'SHIPLINE':
                Message('Hi3');
            'INVLINE':
                Message('Hi3');
            'RECEIPT':
                Message('Hi3');
            'DELDET':
                Message('Hi3');




        end;
    end;



}