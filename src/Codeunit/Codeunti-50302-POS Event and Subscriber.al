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
                Message('Apply Invoice Discount on Sales Order');
            'LINEDISC':
                POSProcedure."Apply Line Discount"("Document No.", "Line No.", Parameter);
            'SHIPLINE':
                Message('Post Shipment for a specific order Line / TO Line');
            'INVLINE':
                Message('Post ship & Invoice for a specific Order line');
            'RECEIPT':
                Message('Receive GRN or Transfer Receipt');
            'DELDET':
                Message('Adding delivery details like delivery method on Sales Order');




        end;
    end;



}