param (
    [Parameter(Mandatory=$true)][string]$checkPath,

    [Parameter(Mandatory=$false,ParameterSetName='exists')][switch]$exists,
    [Parameter(Mandatory=$false,ParameterSetName='exists')][bool]$shouldexist,

    [Parameter(Mandatory=$false,ParameterSetName='size')][switch]$size,
    [Parameter(Mandatory=$false,ParameterSetName='size')][int]$sizewarning,
    [Parameter(Mandatory=$false,ParameterSetName='size')][int]$sizecritical,

    [Parameter(Mandatory=$false,ParameterSetName='number')][switch]$number,
    [Parameter(Mandatory=$false,ParameterSetName='number')][int]$numwarning,
    [Parameter(Mandatory=$false,ParameterSetName='number')][int]$numcritical

)

#Setting global error action preference
#Will probably revisit this when I add the verbose switch
$ErrorActionPreference = "SilentlyContinue"
[int]$exitCode = 2
[string]$exitMessage = "CRITICAL: something wicked happened"
[decimal]$version = 1.0

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
    [int]$returnInt = 0

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

function processCheck {
    param (
        [Parameter(Mandatory=$true)][int]$checkResult,
        [Parameter(Mandatory=$true)][int]$warningThresh,
        [Parameter(Mandatory=$true)][int]$criticalThresh,
        [Parameter(Mandatory=$false)][string]$returnMessage
    )

    [array]$returnArray

    if ($checkResult -gt $criticalThresh) {
        
        $returnArray = @(2, "CRITICAL: $returnMessage")
    }
    elseif ($checkResult -le $criticalThresh -and $checkResult -gt $warningThresh) {
        
        $returnArray = @(1, "WARNING: $returnMessage")
    }
    else {
        
        $returnArray = @(0, "OK: $returnMessage")
    }

    return $returnArray

}


## MAIN SCRIPT ##

if ($exists -eq $true) {
    #Check if a specific file or directory exists
    if (checkFileExists -Path $checkPath) {
        $exitMessage = "OK: I found the file $checkPath!"
        $exitCode = 0
    }
    else {
        $exitMessage = "CRITICAL: I did not find the file, $checkPath"
        $exitCode = 2
    }
}
elseif ($size -eq $true) {
    #Check the size of a specific file
    #Write-Output (checkFileSize -Path $checkPath)

    $cimObj = Get-CimInstance -ClassName CIM_LogicalFile `
            -Filter "Name='$checkPath'" `
            -KeyOnly `
            -Namespace root\cimv2 
    
    if ($cimObj.FileType -eq "File Folder") {
        $exitMessage = "UNKNOWN: $checkPath, is a directory. Directories are not currently supported"
        $exitCode = 3
    }
    else {
        $processArray = processCheck -checkResult $cimObj.FileSize `
                     -warningThresh $sizeWarning `
                     -criticalThresh $sizeCritical `
                     -returnMessage "File size is $($cimObj.FileSize)"
        
        #Come back to this and find out why an array with 2 elements isn't starting from 0
        $exitCode = $processArray[1]
        $exitMessage = $processArray[2]
    }
    
}
elseif ($number -eq $true) {
    #Check the number of files in a directory
    
    if ((Get-CimInstance -ClassName CIM_LogicalFile `
            -Filter "Name='$checkPath'" `
            -KeyOnly `
            -Namespace root\cimv2).FileType -ne "File Folder") {

        Write-Outpute "The path specified is not a directory."

    }
    else {
        $numFiles = (checkFilesInDirectory -Path $checkPath)
        $processArray = processCheck -checkResult $numFiles `
                        -warningThresh $numwarning `
                        -criticalThresh $numcritical `
                        -returnMessage "Number of files is $numFiles"

        $exitCode = $processArray[1]
        $exitMessage = $processArray[2]
    }
}


Write-Output $exitMessage
exit [int]$exitCode