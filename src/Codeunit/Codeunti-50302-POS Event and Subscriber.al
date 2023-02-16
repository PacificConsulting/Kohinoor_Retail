codeunit 50302 "POS Event and Subscriber"
{
    Access = Public;
    trigger OnRun()
    begin

    end;

    procedure POSAction(DocumentNo: Code[20]; LineNo: integer; POSAction: Text[10]; Parameter: text[10])
    var
        myInt: Integer;
        POSProcedure: Codeunit 50303;
    begin
        case POSAction of
            'VOIDL':
                POSProcedure.SalesLineDeletion(DocumentNo, LineNo);
            'VOIDT':
                POSProcedure.SalesOrderDeletion(DocumentNo);
            'VOIDP':
                POSProcedure.PaymentLineDeletion(DocumentNo, LineNo);
            'INVDISC':
                POSProcedure.InvoiceLine();
            'LINEDISC':
                POSProcedure.LineDiscount(DocumentNo, LineNo, Parameter);
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