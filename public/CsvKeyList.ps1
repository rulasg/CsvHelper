<#
.SYNOPSIS
Returns a list of key values derived from CSV data.

.DESCRIPTION
This function reads a CSV file and returns a list of unique values from a specified key column.

.EXAMPLE
Get-CsvKeyList -Path "C:\path\to\file.csv" -KeyColumn "Id"
#>
function Get-CsvKeyList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$Path,
        [Parameter(Mandatory=$true)][string]$KeyColumn
    )

    $csv = Import-Csv -Path $Path
    $csv | Select-Object -ExpandProperty $KeyColumn | Sort-Object -Unique

} Export-ModuleMember -Function Get-CsvKeyList