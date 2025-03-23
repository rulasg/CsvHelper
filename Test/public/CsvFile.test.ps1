
function Test_GetCsvFile{

    Mock_Database -resetDatabase
    $databaseRoot = Get-Mock_DatabaseStore
    $csvPath = New-TestCsvFile

    # Act
    $key = Import-CsvFile -Path $csvPath -KeyColumn "Column1"

    # Assert
    Assert-IsNotNull -Object $key
    Assert-Count -Expected 1 -Presented (Get-ChildItem -Path $databaseRoot)
    Assert-ItemExist -Path "$databaseRoot/$key.json"

    # read database file from json
    $data = Get-Content -Path "$databaseRoot/$key.json" | ConvertFrom-Json -Depth 10 -AsHashtable

    # Random record
    $i = 5
    $record2 = $data["Value1_$i"]

    Assert-AreEqual -Expected "Value1_$i" -Presented $record2.Column1
    Assert-AreEqual -Expected "Value2_$i" -Presented $record2.Column2
    Assert-AreEqual -Expected "Value3_$i" -Presented $record2.Column3
}

function Test_GetCsvFile_Default_Id{

    Mock_Database -resetDatabase
    $databaseRoot = Get-Mock_DatabaseStore
    $csvPath = New-TestCsvFile

    # Act
    $key = Import-CsvFile -Path $csvPath

    # Assert
    # read database file from json
    $data = Get-Content -Path "$databaseRoot/$key.json" | ConvertFrom-Json -Depth 10 -AsHashtable

    # Random record
    $i = 5
    $record2 = $data["ValueId_$i"]

    Assert-AreEqual -Expected "Value1_$i" -Presented $record2.Column1
    Assert-AreEqual -Expected "Value2_$i" -Presented $record2.Column2
    Assert-AreEqual -Expected "Value3_$i" -Presented $record2.Column3
}

function Test_GetCsvFile_Integration{

    # Assert-SkipTest -Message "Integration test not implemented"

    Mock_Database -resetDatabase
    $databaseRoot = Get-Mock_DatabaseStore
    $csvPath = "~/Downloads/kk2.csv"

    Assert-IsTrue -Condition (Test-Path -Path $csvPath)

    $result = Import-CsvFile -Path $csvPath -KeyColumn "AccountId"

    Assert-NotImplemented

}

