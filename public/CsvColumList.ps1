<#
.SYNOPSIS
Returns a list of column names from a CSV file.

.DESCRIPTION
This function reads a CSV file and returns a list of its column names.

.PARAMETER FilePath
The path to the CSV file.

.EXAMPLE
Get-CsvColumnList -FilePath "C:\path\to\file.csv"

.NOTES
#>
function Get-CsvColumnList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][string]$Path
    )

    $csv = Import-Csv -Path $Path
    $csv | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name
} Export-ModuleMember -Function Get-CsvColumnList