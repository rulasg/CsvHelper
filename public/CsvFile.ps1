<#
.SYNOPSIS
    Module for handling CSV files with a database-like interface.
.DESCRIPTION
    This module provides functions to import CSV files into a database-like structure,
    allowing for easy access and manipulation of the data.
    It includes functions to import CSV files, retrieve records by ID, and save the database.
    The database is stored in JSON format for easy access and manipulation.
.EXAMPLE
    $key = Import-CsvFile -Path "C:\path\to\file.csv" -KeyColumn "Column1"
    This command imports a CSV file and uses the "Column1" column as the key for the database.
    The key is returned for further use.
.EXAMPLE
    $key = Import-CsvFile -Path "C:\path\to\file.csv"
    This command imports a CSV file and uses the default "Id" column as the key for the database.
    The key is returned for further use.
.Note
    Use Invoke-CsvHelperGetDbRootPath to retreive the path where the database is stored.
    Use Get-CsvRecord to retrieve records from the database.
    Use Get-CsvDatabaseKey to retrieve the key for the csv file used to create the database JSON file name for that path.
#>
function Import-CsvFile {
    param (
        [string]$Path,
        [string]$KeyColumn = "Id"
    )

    if (-Not (Test-Path $Path)) {
        Write-Error "File not found: $Path"
        return
    }

    try {

        $key = Get-CsvDatabaseKey -Path $Path -KeyColumn $KeyColumn
        $data = Import-Csv -Path $Path

        Save-CsvDatabase -Key $key -Data $data -KeyColumn $KeyColumn

        return $key

    } catch {
        Write-Error "Failed to load CSV file: $_"
    }
} Export-ModuleMember -Function Import-CsvFile



