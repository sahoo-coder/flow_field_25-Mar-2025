pageextension 50530 salesOrderListPageEXT extends "Sales Order List"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sell-to Customer No.")
        {
            field(Customer_Phone_Number; Rec.Customer_Phone_Number)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of customer phone number';
                Caption = 'Customer Ph. Number_KSS';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}