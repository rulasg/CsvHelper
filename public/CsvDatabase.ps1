<#
.SYNOPSIS
    This function retrieves the key for a CSV file used to create the database JSON file name.
.DESCRIPTION
    This function retrieves the key for a CSV file used to create the database JSON file name.
    The key is generated based on the path of the CSV file, the specified key column, and the last modified time of the file.
.PARAMETER Path
    The path to the CSV file.
.PARAMETER KeyColumn
    The column to use as the key for the database.
.EXAMPLE
    $key = Get-CsvDatabaseKey -Path "C:\path\to\file.csv" -KeyColumn "Column1"
    This command retrieves the key for the specified CSV file using "Column1" as the key column.
.EXAMPLE
#>
function Get-CsvDatabaseKey {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory=$true,
                   Position=0,
                   ParameterSetName="ParameterSetName",
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   HelpMessage="Path to one or more locations.")]
        [Alias("PSPath")]
        [ValidateNotNullOrEmpty()]
        [string[]]
        $Path,
        [Parameter(Mandatory)][string]$KeyColumn
    )

    process {

        $paths = Get-ChildItem -Path $Path 

        foreach ($path in $paths) {

            if (-not (Test-Path -Path $Path)) {
                throw "The specified path does not exist: $Path"
            }

            $item = Get-Item -Path $Path
            
            $lastmodified = $item.LastWriteTime
            
            $lastmodified = $lastmodified.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
            
            $path = $item | Convert-Path

            $key = "$path - $KeyColumn - $lastmodified"

            $ret = $key | Get-HashCode

            return $ret
        }
    }
} Export-ModuleMember -Function Get-CsvDatabaseKey

function Save-CsvDatabase{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)] [string]$Key,
        [Parameter(Mandatory, Position = 1)] [object]$Data,
        [Parameter(Mandatory, Position = 2)] [string]$KeyColumn
    )

    $CsvDatabase = New-Object System.Collections.Hashtable

    foreach ($row in $Data) {
        $keyValue = $row.$KeyColumn

        if (-not $CsvDatabase.ContainsKey($keyValue)) {
            $CsvDatabase[$keyValue] = @{}
        }

        foreach ($property in $row.PSObject.Properties) {
            $CsvDatabase[$keyValue][$property.Name] = $property.Value
        }
    }

    Save-DatabaseKey -Key $key -Value $CsvDatabase
}

function Get-CsvDatabase{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)] [string]$Key
    )

    $ret = Get-DatabaseKey -Key $key

    return $ret

}