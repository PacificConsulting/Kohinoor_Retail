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
            // trigger OnValidate()
            // var
            //     StaffMaster: Record "Staff Master";
            //     TenderHdr: Record "Tender Declartion Header";
            //     PagetenderCard: page "Tender Declartion Card";
            // begin
            //     IF StaffMaster.Get("Staff ID") then begin
            //         TenderHdr.SetRange("Staff ID", StaffMaster.ID);
            //         TenderHdr.SetRange("Store No.", StaffMaster."Store No.");
            //         TenderHdr.SetRange("Store Date", Today);
            //         IF not TenderHdr.FindFirst() then begin
            //             "Store No." := StaffMaster."Store No.";
            //             "Store Date" := Today;
            //         end else begin
            //             TenderHdr.SetRange("Staff ID", StaffMaster.ID);
            //             TenderHdr.SetRange("Store No.", StaffMaster."Store No.");
            //             TenderHdr.SetRange("Store Date", Today);
            //             IF TenderHdr.FindFirst() then begin
            //                 PagetenderCard.SetTableView(TenderHdr);
            //                 PagetenderCard.Run();
            //                 Rec.Delete();
            //                 PagetenderCard.SetTableView(rec);
            //                 PagetenderCard.Close();
            //             end;

            // end;
            //end;
            // end;
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
    begin

    end;

    trigger OnRename()
    begin

    end;

}