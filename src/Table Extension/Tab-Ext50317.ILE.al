// tableextension 50317 MyExtension extends "Item Ledger Entry"
// {
//     fields
//     {

//     }

//     var
//         myInt: Integer;

//     trigger OnInsert()
//     var
//         IR: Record "Item Register";
//         ILE: Record 32;
//     begin
//         ILE.RESET;
//         ile.SetRange("Entry No.", rec."Entry No.");
//         IF ILE.FindFirst() THEN Begin
//             IR.RESET;
//             IR.SETFILTER("From Entry No.", '<=%1', ILE."Entry No.");
//             IR.SETFILTER("To Entry No.", '>=%1', ILE."Entry No.");
//             IF IR.FINDFIRST THEN BEGIN
//                 "External Document No." := IR."User ID";
//             END;
//         End;

//     end;
// }