function New-TestCsvFile {
    param (
        [Parameter()][int]$NumRows = 10,
        [Parameter()][string]$Path = "test.csv"
    )

    $data = @()

    for ($i = 1; $i -le $numRows; $i++) {
        $data += [PSCustomObject]@{
            Id = "ValueId_$i"
            Column1 = "Value1_$i"
            Column2 = "Value2_$i"
            Column3 = "Value3_$i"
        }
    }

    $data | Export-Csv -Path $Path -NoTypeInformation

    return $Path
} Export-ModuleMember -Function New-TestCsvFile