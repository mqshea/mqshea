Attribute VB_Name = "Module1"
Sub stockAnalysis():
        
    Dim total As Double             ' total stock volume
    Dim row As Long                 ' loop control variable that will go through rows in a sheet
    Dim rowCount As Double          ' variable that holds the number of rows in a sheet
    Dim quarterlyChange As Double   ' variable that holds the quarterly change for each stock in a sheet
    Dim percentChange As Double
    Dim summaryTableRow As Long
    Dim stockStarRow As Long
    Dim startValue As Long
    Dim lastTicker As String
    
    'lopp through all worksheets in the excel workbook
    For Each ws In Worksheets
    
        ' Set the Title Row of the Summary Section
        ws.Range("I1").Value = "Ticker"
        ws.Range("J1").Value = "Quarterly Change"
        ws.Range("K1").Value = "Percent Change"
        ws.Range("L1").Value = "Total Stock Volume"
        
        ' Set the aggregate info section
        ws.Range("P1").Value = "Ticker"
        ws.Range("Q1").Value = "Value"
        ws.Range("O2").Value = "Greatest % Increased"
        ws.Range("O3").Value = "Greatest % Decreased"
        ws.Range("O4").Value = "Greatest Total Volume"
        
        ' Initialize values
        summaryTableRow = 0     ' summary table starts at 0 in sheet (add 2) in relation to header
        total = 0               ' total stock volume for a stock starts at 0
        quarterlyChange = 0     'quarterly change starts at 0
        stockStartRow = 2       ' first stock in the sheet is going to be on row 2
        startValue = 2          ' first open of the first stock value is on row 2
        
        ' get the value of the last row in the current sheet
        rowCount = ws.Cells(Rows.Count, "A").End(xlUp).row
        
        lastTicker = ws.Cells(rowCount, 1).Value
        
        ' loop until we get to the end of the sheet
        For row = 2 To rowCount
        
            ' check to see if the ticker changed
            If ws.Cells(row + 1, 1).Value <> ws.Cells(row, 1).Value Then
            
                'If this is the case,
                
                total = total + ws.Cells(row, 7).Value
                
                'check to see if value of total stock volume is zero
                If total = 0 Then
                    'print results in the summary table section (Columns I - L)
                    ws.Range("I" & 2 + summaryTableRow).Value = Cells(row, 1).Value    'prints the ticker value from column A
                    ws.Range("J" & 2 + summaryTableRow).Value = 0                      'prints a 0 in column J (quarterly change)
                    ws.Range("K" & 2 + summaryTableRow).Value = 0                      'prints a 0 in column K (percent Change)
                    ws.Range("L" & 2 + summaryTableRow).Value = 0                      'prints a 0 incolumn L (total stock volume)
                Else
                    'find the first non-zero first open value for the stock
                    If ws.Cells(startValue, 3).Value = 0 Then
                        ' if the first open is 0, search for the first non-zero stock oen value by moving to the next rows
                        For findValue = startValue To row
                        
                            'check to see if the next (or rows afterwards) open value does not equal 0
                            If ws.Cells(findValue, 3).Value <> 0 Then
                                ' once we have a non-zero first open value, that value becomes the row where we track our first open
                                startValue = findValue
                                ' break out of loop
                                Exit For
                            End If
                        
                        Next findValue
                    End If
                
                    ' calculate the quarterly change
                    quarterlyChange = ws.Cells(row, 6).Value - ws.Cells(startValue, 3).Value
                    
                    'calculate percent change
                    percentChange = quarterlyChange / ws.Cells(startValue, 3).Value
                    
                    ' print results
                    ws.Range("I" & 2 + summaryTableRow).Value = ws.Cells(row, 1).Value    'prints the ticker value from column A
                    ws.Range("J" & 2 + summaryTableRow).Value = quarterlyChange        'prints a Value in column J (quarterly change)
                    ws.Range("K" & 2 + summaryTableRow).Value = percentChange          'prints a Value in column K (percent Change)
                    ws.Range("L" & 2 + summaryTableRow).Value = total                  'prints a Value in column L (total stock volume)
                    
                    ' color the Quarterlychange column in summary section depending on its value
                    If quarterlyChange > 0 Then
                        ' color the cell green
                        ws.Range("J" & 2 + summaryTableRow).Interior.ColorIndex = 4
                    ElseIf quarterlyChange < 0 Then
                        'color the cell red
                        ws.Range("J" & 2 + summaryTableRow).Interior.ColorIndex = 3
                    Else
                        ' color the cell clear
                        ws.Range("J" & 2 + summaryTableRow).Interior.ColorIndex = 0
                    End If
                    
                    ' reset / update the values for the next ticker
                    total = 0               ' resets the total stock vol. for the next ticker
                    averageChange = 0       ' resets the average change for the next ticker
                    quarterlyChange = 0     ' resets the quarterly change for the next ticker
                    startValue = row + 1    'moves the start row to the next row in the sheet
                    ' move to the next row in the summary table
                    summaryTableRow = summaryTableRow + 1
                 
                End If
           
                
            Else
                'If we are in the same ticker, add to total stock volume
                total = total + ws.Cells(row, 7).Value
                
            End If
            
        Next row
        
        ' clean up (if needed) to avoid extra data be placed in summary
        ' find the last row of data in the summary table by finding the last ticker in the summary section
            
        ' update the summary table row
        summaryTableRow = ws.Cells(Rows.Count, "I").End(xlUp).row
            
        ' find the last data in the extra rows from columns J-L
        Dim LastExtraRow As Long
        LastExtraRow = ws.Cells(Rows.Count, "J").End(xlUp).row
            
        'loop that clears extra data from columns I-L
        For e = summaryTableRow To LastExtraRow
            ' for loop that goes through columns I - L (9-12)
            For Column = 9 To 12
                ws.Cells(e, Column).Value = ""
                ws.Cells(e, Column).Interior.ColorIndex = 0
            Next Column
        Next e
            
        'print summary aggregates
        'after generating the info in the summary section, find greatest percent increase and decrease then
        'find greatest total stock volume
        ws.Range("Q2").Value = WorksheetFunction.Max(ws.Range("K2:K" & summaryTableRow + 2))
        ws.Range("Q3").Value = WorksheetFunction.Min(ws.Range("K2:K" & summaryTableRow + 2))
        ws.Range("Q4").Value = WorksheetFunction.Max(ws.Range("L2:L" & summaryTableRow + 2))
        
        ' use match()to find the row numbers of the ticker names associated ith the greatest percent increase and decrease,
        ' then find the same thing for the greatest total stock volume
        Dim greatestIncreaseRow As Double
        Dim greatestDecreaseRow As Double
        Dim greatestTotVolRow As Double
        greatestIncreaseRow = WorksheetFunction.Match(WorksheetFunction.Max(ws.Range("K2:K" & summaryTableRow + 2)), ws.Range("K2:K" & summaryTableRow + 2), 0)
        greatestDecreaseRow = WorksheetFunction.Match(WorksheetFunction.Min(ws.Range("K2:K" & summaryTableRow + 2)), ws.Range("K2:K" & summaryTableRow + 2), 0)
        greatestTotVolRow = WorksheetFunction.Match(WorksheetFunction.Max(ws.Range("L2:L" & summaryTableRow + 2)), ws.Range("L2:L" & summaryTableRow + 2), 0)
        
        
        ' display the ticker symbol for the greatest increase, greatest decrease, and greatest total stock volume
        ws.Range("P2").Value = ws.Cells(greatestIncreaseRow + 1, 9).Value
        ws.Range("P3").Value = ws.Cells(greatestDecreaseRow + 1, 9).Value
        ws.Range("P4").Value = ws.Cells(greatestTotVolRow + 1, 9).Value
        
        'format the summary table columns
        For s = 0 To summaryTableRow
            ws.Range("J" & 2 + s).NumberFormat = "0.00"       'Formats the quarterly Change
            ws.Range("K" & 2 + s).NumberFormat = "0.00%"      'Formats the Percent Change
            ws.Range("L" & 2 + s).NumberFormat = "#,###"      'Formats the total stock volume
        Next s
        
        'format summary aggregates
        ws.Range("Q2").NumberFormat = "0.00%"          'format the greatest percent increase
        ws.Range("Q3").NumberFormat = "0.00%"          'format the greatest percent decrease
        ws.Range("Q4").NumberFormat = "#,###"          'format the greatest total stock volume
        
        
        'Autofit the info across all columns
        ws.Columns("A:Q").AutoFit
    
    Next ws
    
End Sub

