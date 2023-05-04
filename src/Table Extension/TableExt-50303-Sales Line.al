tableextension 50303 "Sales Line Retail" extends "Sales Line"
{
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                TradeAggre: record "Trade Aggrement";
                SalesHeder: record 36;
            begin
                IF SalesHeder.Get(rec."Document Type", rec."Document No.") then;
                TradeAggre.Reset();
                TradeAggre.SetRange("Item No.", Rec."No.");
                TradeAggre.SetRange("Location Code", SalesHeder."Location Code");
                TradeAggre.SetFilter("From Date", '<=%1', SalesHeder."Posting Date");
                TradeAggre.SetFilter("To Date", '>=%1', SalesHeder."Posting Date");
                IF TradeAggre.FindFirst() then begin
                    Validate("Unit Price Incl. of Tax", TradeAggre."Amount In INR");
                    "Price Inclusive of Tax" := true;
                end;

                // Validate("Unit Price Incl. of Tax", 25000);
                //Validate("Price Inclusive of Tax", true);
                //"Price Inclusive of Tax" := true;
            end;

        }
        modify("Unit Price Incl. of Tax")
        {
            trigger OnAfterValidate()
            var
                TradeAggre: record "Trade Aggrement";
                SalesHeder: record 36;
                SL: Record 37;
            begin
                IF xRec."Unit Price Incl. of Tax" <> Rec."Unit Price Incl. of Tax" then begin
                    Rec."Change Unit Price Incl. of Tax" := Rec."Unit Price Incl. of Tax";
                    //Rec.Modify();
                    IF SalesHeder.Get(rec."Document Type", rec."Document No.") then;
                    TradeAggre.Reset();
                    TradeAggre.SetRange("Item No.", Rec."No.");
                    TradeAggre.SetRange("Location Code", SalesHeder."Location Code");
                    TradeAggre.SetFilter("From Date", '<=%1', SalesHeder."Posting Date");
                    TradeAggre.SetFilter("To Date", '>=%1', SalesHeder."Posting Date");
                    IF TradeAggre.FindFirst() then begin
                        IF TradeAggre."Amount In INR" < Rec."Unit Price Incl. of Tax" then
                            Error('Amount should not be more than %1 INR', TradeAggre."Amount In INR");
                        IF TradeAggre."Last Selling Price" > Rec."Unit Price Incl. of Tax" then begin
                            ApprovalMailSent(Rec);
                            //Rec."Approval Status" := Rec."Approval Status"::"Pending for Approval";
                            Sl.Reset();
                            SL.SetRange("Document No.", Rec."Document No.");
                            SL.SetRange("Line No.", Rec."Line No.");
                            IF SL.FindFirst() then begin
                                SL."Approval Status" := SL."Approval Status"::"Pending for Approval";
                                SL.Modify();
                            end;
                        end;
                    end;
                end;
            end;
        }
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
        field(50303; "Approval Sent By"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50304; "Approval Sent On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50305; "Approved By"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50306; "Approved On"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(50307; "Old Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50308; "Exchange Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Item."No.";
        }
        field(50309; "Serial No."; Code[50])
        {
            DataClassification = ToBeClassified;
        }
        field(50310; "GST Tax Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(50311; "Salesperson Code"; Code[20])
        {
            Caption = 'Salesperson Code';
            DataClassification = ToBeClassified;
            TableRelation = "Salesperson/Purchaser".Code;

        }
        field(50312; "Change Unit Price Incl. of Tax"; Decimal)
        {
            DataClassification = ToBeClassified;

        }

    }

    trigger OnModify()
    begin
        IF "Approval Status" = "Approval Status"::"Pending for Approval" then
            Error('You can not modify Lines if Approval Status is Pending for Approval ');
    end;

    trigger OnInsert()
    var
        RecLoc: Record Location;
        SalesHeader: Record 36;
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("No.", "Document No.");
        IF SalesHeader.FindFirst() then begin
            IF SalesHeader."Store No." <> '' then begin
                RecLoc.Reset();
                RecLoc.SetRange(Store, true);
                RecLoc.SetRange(Code, SalesHeader."Store No.");
                IF RecLoc.FindFirst() then begin
                    Validate("Location Code", RecLoc.Code);
                    "Store No." := RecLoc.Code;

                end;
            end;
        end;
        IF "Approval Status" = "Approval Status"::"Pending for Approval" then
            Error('You can not modify Lines if Approval Status is Pending for Approval ');
    end;


    trigger OnDelete()
    begin
        IF "Approval Status" = "Approval Status"::"Pending for Approval" then
            Error('You can not modify Lines if Approval Status is Pending for Approval ');
    end;

    local procedure ApprovalMailSent(SalesLine: Record "Sales Line")
    var
        txtFile: Text[100];
        Window: Dialog;
        txtFileName: Text[100];
        Char: Char;
        recSalesInvHdr: Record 112;
        Recref: RecordRef;
        recCust: Record 18;
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        Instr: InStream;
        EMail: Codeunit Email;
        Emailmessage: Codeunit "Email Message";
        Pagelink: Text;
        GLSetup: Record "General Ledger Setup";
        ToRecipients: List of [text];
        SL: Record 37;
    begin
        GLSetup.Get();
        GLSetup.TestField("Slab Approval User 1");
        //GLSetup.TestField("Slab Approval User 2");
        //GLSetup.TestField("Slab Approval User 3");
        //Pagelink := GetUrl(ClientType::Current, Rec.CurrentCompany, ObjectType::Page, Page::"Slab Approval List");
        Sl.Reset();
        SL.SetRange("Document No.", SalesLine."Document No.");
        SL.SetRange("Line No.", SalesLine."Line No.");
        IF SL.FindFirst() then
            Pagelink := GETURL(CURRENTCLIENTTYPE, 'Kohinoor Televideo Pvt. Ltd.', ObjectType::Page, 50361, SL, true);

        //  Window.OPEN(
        // 'Sending Mail#######1\');

        ToRecipients.Add(GLSetup."Slab Approval User 1");
        ToRecipients.Add(GLSetup."Slab Approval User 2");
        ToRecipients.Add(GLSetup."Slab Approval User 3");

        Emailmessage.Create(/*ToRecipients*/'niwagh16@gmail.com', 'Approval Slab', '', true);
        Emailmessage.AppendToBody('<p><font face="Georgia">Dear <B>Sir,</B></font></p>');
        Char := 13;
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody('<p><font face="Georgia"> <B>!!!Greetings!!!</B></font></p>');
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody('<p><font face="Georgia"><BR>Please find below Approval Link Approve Date</BR></font></p>');
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody('<a href=' + Pagelink + '/">Web Link!</a>');
        Emailmessage.AppendToBody(Pagelink);
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody(FORMAT(Char));
        Emailmessage.AppendToBody('<p><font face="Georgia"><BR>Thanking you,</BR></font></p>');
        //Emailmessage.AppendToBody('<p><font face="Georgia"><BR>Warm Regards,</BR></font></p>');
        //Emailmessage.AppendToBody('<p><font face="Georgia"><BR><B>For K-TECH (INDIA) LIMITED</B></BR></font></p>');

        // Window.UPDATE(1, STRSUBSTNO('%1', 'Mail Sent'));
        EMail.Send(Emailmessage, Enum::"Email Scenario"::Default);
        //Window.CLOSE;
        Rec."Approval Sent By" := UserId;
        Rec."Approval Sent On" := Today;
        Message('Approval mail sent successfully');
        // Sl.Reset();
        // SL.SetRange("Document No.", SalesLine."Document No.");
        // SL.SetRange("Line No.", SalesLine."Line No.");
        // IF SL.FindFirst() then begin
        //     SL."Approval Status" := SL."Approval Status"::"Pending for Approval";
        //     SL.Modify();
        // end;

    end;

}
