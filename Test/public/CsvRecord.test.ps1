
function Test_GetCsvRecord{

    Mock_Database -resetDatabase

    $csvPath = New-TestCsvFile

    $key = Import-CsvFile -Path $csvPath -KeyColumn "Column1"

    Assert-IsNotNull -Object $key

    # Act get record with csv with path
    $record = Get-CsvRecord -Path $csvPath -KeyColumn "Column1" -Id "Value1_2"

    Assert-AreEqual -Expected "Value1_2" -Presented $record.Column1
    Assert-AreEqual -Expected "Value2_2" -Presented $record.Column2
    Assert-AreEqual -Expected "Value3_2" -Presented $record.Column3

    # Call with Key
    $record = Get-CsvRecord -Key $key -Id "Value1_3"

    Assert-AreEqual -Expected "Value1_3" -Presented $record.Column1
    Assert-AreEqual -Expected "Value2_3" -Presented $record.Column2
    Assert-AreEqual -Expected "Value3_3" -Presented $record.Column3
}

function Test_GetCsvRecord_Integration{

    Mock_Database -resetDatabase

    $csvPath = New-TestCsvFile

   # Act get record with csv with path
   $record = Get-CsvRecord -Path $csvPath -KeyColumn "Column1" -Id "Value1_2" 

   Assert-AreEqual -Expected "Value1_2" -Presented $record.Column1
   Assert-AreEqual -Expected "Value2_2" -Presented $record.Column2
   Assert-AreEqual -Expected "Value3_2" -Presented $record.Column3
}

function Test_GetCsvRecord_Integration_Id{

    Mock_Database -resetDatabase

    $csvPath = New-TestCsvFile

   # Act get record with csv with path
   $record = Get-CsvRecord -Path $csvPath -Id "ValueId_2" 

   Assert-AreEqual -Expected "Value1_2" -Presented $record.Column1
   Assert-AreEqual -Expected "Value2_2" -Presented $record.Column2
   Assert-AreEqual -Expected "Value3_2" -Presented $record.Column3
}