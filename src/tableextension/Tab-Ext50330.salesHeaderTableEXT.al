tableextension 50330 salesHeaderTableEXT extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here
        field(50400; Customer_Phone_Number; Code[30])
        {
            FieldClass = FlowField;
            CalcFormula = lookup(Customer."Phone No." where("No." = field("Sell-to Customer No.")));
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;
}