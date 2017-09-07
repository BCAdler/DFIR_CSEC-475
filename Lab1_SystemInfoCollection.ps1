<#
    .SYNOPSIS
    Short Description

    .DESCRIPTION
    Long Description

    .PARAMETER RemoteComputers
    Remote Computers

    .PARAMETER OutputCSV
    Output CSV

    .PARAMETER EmailCSV
    Email CSV

    .EXAMPLE
    An example

    .NOTES
    Notes
#>
Param (
    [string[]]$RemoteComputers,
    [string]$OutputCSV = $null,
    [switch]$EmailCSV
)

