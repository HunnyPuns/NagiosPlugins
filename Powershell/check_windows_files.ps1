param (
    [Parameter(Mandatory=$true)][string]$checkPath,

    [Parameter(Mandatory=$false,ParameterSetName='exists')][switch]$exists,
    [Parameter(Mandatory=$false,ParameterSetName='exists')][bool]$shouldexist,

    [Parameter(Mandatory=$false,ParameterSetName='size')][switch]$size,
    [Parameter(Mandatory=$false,ParameterSetName='size')][string]$sizewarning,
    [Parameter(Mandatory=$false,ParameterSetName='size')][string]$sizecritical,

    [Parameter(Mandatory=$false,ParameterSetName='number')][switch]$number,
    [Parameter(Mandatory=$false,ParameterSetName='number')][int]$numwarning,
    [Parameter(Mandatory=$false,ParameterSetName='number')][int]$numcritical

)

#Setting global error action preference
#Will probably revisit this when I add the verbose switch
$ErrorActionPreference = "SilentlyContinue"
[int]$exitcode = 2
[decimal]$version = 0.5

function sanitizePath {
    #TODO: Need to figure out how to sanitize a path in Powershell.
    #I want people to be able to do C:\Path\To\File, not C:\\Path\\To\\File
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
        -Filter "Name='$Path'" `
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

    $returnInt = ((Get-ChildItem $Path) | Where-Object Mode -NotLike 'd*').Count
    
    return $returnInt
}

function checkFileSize {
    param (
        [Parameter(Mandatory=$true)][string]$Path
    )
    $returnInt = 0

    $returnint = (Get-CimInstance -ClassName CIM_LogicalFile `
                    -Filter "Name='$Path'" `
                    -KeyOnly `
                    -Namespace root\cimv2).FileSize

    return $returnInt
}

<#
function processOutput {
    param (
        [Parameter(Mandatory=$true)][string]$
    )
}
#>

## MAIN SCRIPT ##

if ($exists -eq $true) {
    #Check if a specific file or directory exists
    if (checkFileExists -Path $checkPath) {
        echo "I found the file $checkPath!"
        $exitcode = 0
    }
    else {
        echo "I did not find the file, $checkPath"
        $exitcode = 2
    }
}
elseif ($size -eq $true) {
    #Check the size of a specific file
    echo (checkFileSize -Path $checkPath)

    #Need to go through processOutput to return Nagios data
    
}
elseif ($number -eq $true) {
    #Check the number of files in a directory
    
    if ((Get-CimInstance -ClassName CIM_LogicalFile `
            -Filter "Name=$checkPath'" `
            -KeyOnly `
            -Namespace root\cimv2).FileType -ne "File Folder") {

        echo "The path specified is not a directory."

    }
    else {
        $myvar = (checkFilesInDirectory -Path $checkPath)
        echo "The number of files in $checkPath is: $myvar"    
    }
}




exit $exitcode