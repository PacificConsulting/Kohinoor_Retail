codeunit 50302 "POS Event and Subscriber"
{
    Access = Public;
    trigger OnRun()
    begin

    end;

    procedure POSAction("Document No.": Code[20]; "Line No.": integer; POSAction: Text[10]; Parameter: text[10])
    var
        myInt: Integer;
        POSProcedure: Codeunit 50303;
    begin
        case POSAction of
            'VOIDL':
                POSProcedure.SalesLineDeletion("Document No.", "Line No.");
            'VOIDT':
                POSProcedure.SalesOrderDeletion("Document No.");
            'VOIDP':
                POSProcedure.PaymentLineDeletion("Document No.", "Line No.");
            'INVDISC':
                POSProcedure.InvoiceLine();
            'LINEDISC':
                POSProcedure.LineDiscount("Document No.", "Line No.", Parameter);
            'SHIPLINE':
                POSProcedure.ShipLine();
            'INVLINE':
                POSProcedure.InvoiceLine();
            'RECEIPT':
                POSProcedure.ItemReceipt();
            'DELDET':
                POSProcedure.DeliveryDetails();




        end;
    end;



}