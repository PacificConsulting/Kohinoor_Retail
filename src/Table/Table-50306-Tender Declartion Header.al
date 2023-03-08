table 50306 "Tender Declartion Header"
{
    DataClassification = ToBeClassified;
    Caption = 'Tender Declartion';

    fields
    {
        field(1; "Store No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Store No.';
            Editable = false;

        }
        field(2; "Store Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Store Date';
            Editable = false;

        }
        field(3; "Staff ID"; code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Staff ID';
            TableRelation = "Staff Master".ID;
            trigger OnValidate()
            var
                StaffMaster: Record "Staff Master";
                TenderHdr: Record "Tender Declartion Header";
                PagetenderCard: page "Tender Declartion Card";
                TenderInit: Record "Tender Declartion Header";
                TenderInitLine: Record "Tender Declartion Line ";
                Paymethod: Record "Payment Method";
                TenderInitLineNew: Record "Tender Declartion Line ";
            begin
                IF StaffMaster.Get("Staff ID") then begin
                    "Store No." := StaffMaster."Store No.";
                    "Store Date" := Today;
                    Commit();
                    Paymethod.Reset();
                    IF Paymethod.FindSet() then
                        repeat
                            TenderInitLine.Init();
                            TenderInitLine."Store No." := "Store No.";
                            TenderInitLine."Store Date" := Today;
                            TenderInitLine."Staff ID" := "Staff ID";

                            TenderInitLineNew.Reset();
                            TenderInitLineNew.SetRange("Store No.", TenderInitLine."Store No.");
                            TenderInitLineNew.SetRange("Store Date", TenderInitLine."Store Date");
                            TenderInitLineNew.SetRange("Staff ID", TenderInitLine."Staff ID");
                            IF TenderInitLineNew.FindLast() then
                                TenderInitLine."Line No." := TenderInitLineNew."Line No." + 10000
                            else
                                TenderInitLine."Line No." := 10000;

                            TenderInitLine.Insert();
                            TenderInitLine."Payment Method code" := Paymethod.Code;
                            TenderInitLine.Modify();
                        until Paymethod.Next() = 0;

                end;
            end;
        }
        field(4; Status; Enum "Tender Header Dec.Status")
        {
            DataClassification = ToBeClassified;
            Caption = 'Status';
        }

    }

    keys
    {
        key(Key1; "Store No.", "Store Date", "Staff ID")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    var
        TendLine: Record "Tender Declartion Line ";
    begin
        TendLine.Reset();
        TendLine.SetRange("Staff ID", "Staff ID");
        TendLine.SetRange("Store No.", "Store No.");
        TendLine.SetRange("Store Date", "Store Date");
        IF TendLine.FindSet() then
            repeat
                TendLine.Delete();
            until TendLine.Next() = 0;
    end;

    trigger OnRename()
    begin

    end;

}