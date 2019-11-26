param (
    [Parameter(Mandatory=$true)][string]$checkPath,
    [bool]$checkFileExists = $true,
    [string]$checkFileName = "",
    [int]$checkFileCount = 0
)

#Setting global error action preference
#Will probably revisit this when I add the verbose switch
$ErrorActionPreference = "SilentlyContinue"

function parseSwitches {
    #TODO: This script will have several ways of monitoring files.
    #Right now it only does 1 thing. But as we add more, I'm going to change
    #how the command line switches work.
}

function sanitizePath {
    #TODO: Need to figure out how to sanitize a path in Powershell.
    #I want people to be able to just do C:\Path\To\File, not C:\\Path\\To\\File
    param (
        [Parameter(Mandatory=$true)][string]$checkPath
    )

    $returnPath = $checkPath

    return $returnPath
}

function checkFileExists {
    param (
        [Parameter(Mandatory=$true)][string]$Path
    )

    $returnBool = $false
        
    if (Get-CimInstance -ClassName CIM_LogicalFile `
        -Filter "Name='$path'" `
        -KeyOnly `
        -Namespace root\cimv2) {

        $returnBool = $true

    }

    return $returnBool
}

function checkFilesInDirectory {
    param (
        [Parameter(Mandatory=$true)][string]$Path
    )
    $returnInt = 0

    return $returnInt
}

## MAIN SCRIPT ##

#Check if a specific file or directory exists
if (checkFileExists -Path $checkPath) {
    echo "I found the file $checkPath!"
}
else {
    echo "I did not find the file, $checkPath"
}

