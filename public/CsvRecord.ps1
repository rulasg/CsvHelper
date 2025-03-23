
<#
.SYNOPSIS
    Get a record from a CSV file.
.DESCRIPTION
    This function retrieves a record form a database seaded from a CSV file.
    One of the columns of the CSV will be used as primary key.
    This column is specified during Import-CsvFile.
    By default the column is "Id".
    If the database has not been imported yet, the function will import the CSV file.
.PARAMETER Path
    The path to the CSV file.
.PARAMETER KeyColumn
    The column to use as the key for the database.
    Default is "Id".
.PARAMETER Key
    The key for the database.
    You can use this parameter in case you imported the CSV file in advance and captured the key.
.PARAMETER Id
    The ID of the record to retrieve.
    This is the value of the key column in the CSV file. This KeyColumn is specified during Import-CsvFile or using $KeyColumn parameter.
.EXAMPLE

#>
function Get-CsvRecord{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ParameterSetName = "Path", Position = 0)] [string]$Path,
        [Parameter(ParameterSetName = "Path", Position = 1)] [string]$KeyColumn = "Id",
        [Parameter(Mandatory, ParameterSetName = "CsvKey", Position = 1)] [string]$Key,
        [Parameter(Mandatory, Position = 3)] [string]$Id
    )

    # resolve CsvKey if not provided
    if([string]::IsNullOrWhiteSpace($Key)){
        $Key = Get-CsvDatabaseKey -Path $Path -KeyColumn $KeyColumn
    }

    # It DB not exist import csv file
    if(-not $(Test-DatabaseKey -Key $Key) -and ($path | Test-Path )){
        $Key = Import-CsvFile -Path $Path -KeyColumn $KeyColumn
    }

    # Get the database
    $db = Get-CsvDatabase -Key $Key

    if (-Not $db) {
        throw "Database not found for Key[$Key] Path[$Path]"
    }

    $record = $db.$Id
    
    if (-Not $record) {
        # Write-Error "Record not found for ID: $Id in Csv $Path"
        return $null
    }

    return $record
} Export-ModuleMember -Function Get-CsvRecord