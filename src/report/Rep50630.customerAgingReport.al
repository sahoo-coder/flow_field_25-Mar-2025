report 50630 customerAgingReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './customerAgingReport.rdl';
    Caption = 'Aging_Report_KSS';

    dataset
    {
        dataitem(customerAgingTable_KSS; customerAgingTable_KSS)
        {
            column(No_; "No.") { }
            column(Name; Name) { }
            column(Before_Interval; Before_Interval) { }
            column(first_interval; first_interval) { }
            column(second_interval; second_interval) { }
            column(third_interval; third_interval) { }
            column(intervalFieldOne; intervalFieldOne) { }
            column(intervalFieldTwo; intervalFieldTwo) { }
            column(intervalFieldThree; intervalFieldThree) { }
            trigger OnPreDataItem()
            var
                custRecord: Record Customer;
                custLedEntry: Record "Cust. Ledger Entry";
                before: Decimal;
                intervalArray: array[3] of Decimal;
                looper: Integer;
                second_Date_Start: Date;
                store_date_started: Date;
            begin
                customerAgingTable_KSS.Reset();
                customerAgingTable_KSS.DeleteAll();
                if Date_start <> 0D then begin
                    intervalFieldOne := Format(Date_start) + '-' + Format(Date_start + 30);
                    intervalFieldTwo := Format(Date_start + 31) + '-' + Format(Date_start + 31 + 30);
                    intervalFieldThree := Format(Date_start + 31 + 31) + '-' + Format(Date_start + 31 + 31 + 30);
                    store_date_started := Date_start;
                    if custRecord.FindSet() then
                        repeat
                            before := 0;
                            for looper := 1 to 3 do begin
                                intervalArray[looper] := 0;
                            end;
                            Date_start := store_date_started;
                            second_Date_Start := 0D;
                            custLedEntry.Reset();
                            custLedEntry.SetRange("Customer No.", custRecord."No.");
                            custLedEntry.SetFilter("Due Date", '..%1', store_date_started);

                            if custLedEntry.FindSet() then
                                repeat
                                    custLedEntry.CalcFields("Remaining Amount");
                                    if custLedEntry."Remaining Amount" <> 0 then begin
                                        before += custLedEntry."Remaining Amount";
                                    end;
                                until custLedEntry.Next() = 0
                            else
                                Message('No Data Found in Cust Led Entry Before the Date');
                            for looper := 1 to 3 do begin
                                if looper <> 1 then begin
                                    Date_start := second_Date_Start + 1;
                                    second_Date_Start += 30;
                                end
                                else begin
                                    second_Date_Start := Date_start + 30;
                                end;
                                custLedEntry.Reset();
                                custLedEntry.SetRange("Customer No.", custRecord."No.");
                                custLedEntry.SetFilter("Due Date", '%1..%2', Date_start, second_Date_Start);

                                if custLedEntry.FindSet() then
                                    repeat
                                        custLedEntry.CalcFields("Remaining Amount");
                                        if custLedEntry."Remaining Amount" <> 0 then begin
                                            intervalArray[looper] += custLedEntry."Remaining Amount";
                                        end;
                                    until custLedEntry.Next() = 0;
                            end;
                            customerAgingTable_KSS."No." := custRecord."No.";
                            customerAgingTable_KSS.Name := custRecord.Name;
                            customerAgingTable_KSS.Before_Interval := before;
                            customerAgingTable_KSS.first_interval := intervalArray[1];
                            customerAgingTable_KSS.second_interval := intervalArray[2];
                            customerAgingTable_KSS.third_interval := intervalArray[3];
                            customerAgingTable_KSS.Insert();

                        until custRecord.Next() = 0;
                end
                else
                    Error('Give Starting Date Please');
            end;
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group("Print Aging_KSS")
                {
                    field(Date_start; Date_start)
                    {
                        Caption = 'Starting Date';
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }
    var
        Date_start: Date;
        intervalFieldOne: Text;
        intervalFieldTwo: Text;
        intervalFieldThree: Text;
}