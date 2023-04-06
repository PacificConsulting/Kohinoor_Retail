// tableextension 50305 "Gen Led Setup Ext" extends 98
// {
//     fields
//     {
//         field(50301; "Access Token"; Text[2048])
//         {
//             DataClassification = ToBeClassified;
//         }
//     }

//     var
//         myInt: Integer;
// }
// pageextension 50307 "Gen Led. Setup Card" extends "General Ledger Setup"
// {
//     layout
//     {
//         addafter("Bank Account Nos.")
//         {
//             field("Access Token"; Rec."Access Token")
//             {
//                 ApplicationArea = all;
//             }
//         }
//     }

//     actions
//     {
//         // Add changes to page actions here
//     }

//     var
//         myInt: Integer;
// }