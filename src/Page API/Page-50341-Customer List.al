page 50341 "Customer List API"
{
    APIGroup = 'CustomerGroup';
    APIPublisher = 'Pacific';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'customerList';
    DelayedInsert = true;
    EntityName = 'CustomerList';
    EntitySetName = 'CustomerLists';
    PageType = API;
    SourceTable = Customer;
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'SystemID';
                }
                field(No; Rec."No.")
                {
                    Caption = 'No.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        NoSeries: Codeunit NoSeriesManagement;
                        SR: Record "Sales & Receivables Setup";
                    begin
                        SR.Get();
                        SR.TestField("Customer Nos.");
                        Rec."No." := NoSeries.GetNextNo(SR."Order Nos.", Today, true);
                        Rec.Modify();
                    end;
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(Address1; Rec.Address)
                {
                    Caption = 'Address 1';
                }
                field(Address2; Rec."Address 2")
                {
                    Caption = 'Address 2';
                }
                field(City; Rec.City)
                {
                    Caption = 'City';
                }
                field(State; Rec."State Code")
                {
                    Caption = 'State Code';
                }
                field(Country; Rec."Country/Region Code")
                {
                    Caption = 'Country/Region Code';
                }
                field(ZipCode; Rec."Post Code")
                {
                    Caption = 'Post Code';
                }
                field(GSTINNumber; Rec."GST Registration No.")
                {
                    Caption = 'GST Registration No.';
                }
                field(phoneNo; Rec."Phone No.")
                {
                    Caption = 'Phone No.';
                }
                field(eMail; Rec."E-Mail")
                {
                    Caption = 'Email';
                }
                field(PanNo; Rec."P.A.N. No.")
                {
                    Caption = 'P.A.N. No.';
                }



            }
        }
    }
}
