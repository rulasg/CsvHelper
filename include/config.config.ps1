# CONFIG - PUBLIC
#
# This script defines aliases and functions for configuration management specific to "MyModule".
# It is intended to be included in public-facing scripts.

# Define unique aliases for "MyModule"
$CONFIG_INVOKE_GET_ROOT_PATH_ALIAS = "CsvGetConfigRootPath"
$CONFIG_INVOKE_GET_ROOT_PATH_CMD = "Invoke-CsvGetConfigRootPath"

# Set the alias for the root path command
Set-MyInvokeCommandAlias -Alias $CONFIG_INVOKE_GET_ROOT_PATH_ALIAS -Command $CONFIG_INVOKE_GET_ROOT_PATH_CMD

# Define the function to get the configuration root path
function Invoke-CsvHelperGetConfigRootPath {
    [CmdletBinding()]
    param()

    $configRoot = GetConfigRootPath
    return $configRoot
}

Export-ModuleMember -Function Invoke-CsvHelperGetConfigRootPath

# Extra functions not needed by INCLUDE CONFIG

function Get-CsvHelperConfig{
    [CmdletBinding()]
    param()

    $config = Get-Configuration

    return $config
} Export-ModuleMember -Function Get-CsvHelperConfig

function Save-CsvHelperConfig{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory, ValueFromPipeline, Position = 0)][Object]$Config
    )

    return Save-Configuration -Config $Config
} Export-ModuleMember -Function Save-CsvHelperConfig

function Open-CsvHelperConfig{
    [CmdletBinding()]
    param()

    $path = GetConfigFile -Key "config"

    code $path

} Export-ModuleMember -Function Open-CsvHelperConfig

function Add-CsvHelperConfigAttribute{
    [CmdletBinding()]
    param(
        [Parameter(Mandatory,Position=0)][ValidateSet("Account", "User", "Opportunity")][string]$objectType,

        [Parameter(Mandatory, ValueFromPipeline, Position = 1)][string]$Attribute

    )

    begin{
        $config = Get-Configuration
        $configAttribute = ($objectType + "_attributes").ToLower()

        if(-Not $config){
            $config = @{}
        }
    
        if(-Not $config.$configAttribute){
            $config.$configAttribute = @()
        }
    }

    process{
        $config.$configAttribute += $Attribute
    }
    
    End{
        $ret = Save-Configuration -Config $config
        if(-Not $ret){
            throw "Error saving configuration"
        }

        $config = Get-CsvHelperConfig
        Write-Output $config.$configAttribute
        
    }

} Export-ModuleMember -Function Add-CsvHelperConfigAttribute
