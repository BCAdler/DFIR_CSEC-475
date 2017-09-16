<#
    .SYNOPSIS
    Can parse output from $MFT CSV dump and can list all of the file paths found for a specific file.

    .DESCRIPTION
    Can parse output from $MFT CSV dump and can list all of the file paths found for a specific file.

    .PARAMETER Parse
    Switch used to parse $MFT CSV dump if true or list all file paths of a file if false.

    .PARAMETER CsvPath
    Path of the $MFT CSV dump.

    .PARAMETER InputFile
    Path to file to list all paths for.
#>

Param (
    [switch]$Parse = $false,
    $CsvPath = 'C:\dump.csv',
    $InputFile = 'C:\file.txt'
)

if ($Parse -eq $true){
    # Import CSV
    $Files = Import-Csv -Path $CsvPath
    
    # Get each file and print them in a table format
    foreach ($File in $Files){
        $File | Select-Object -Property Timestamp, FileType, Path | Format-Table -Auto
    }
}
else {
    $data = "$(((Get-ChildItem $Path -Include "*$InputFile" -Recurse).FullName).Replace("[","``[").Replace("]","``]").Replace("$InputFile ", "$InputFile    "))".Split("    ") 
    $data | Format-Table -Auto
}
