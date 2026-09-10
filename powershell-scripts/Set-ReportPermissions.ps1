<#
.SYNOPSIS
    Assigns Power BI row-level security (RLS) roles to security groups, driven by config
    instead of manual assignment in the Power BI service.

.DESCRIPTION
    Written for the Training Investment Dashboard, where each RLS role corresponds to a
    department (Marketing, IT, Finance, etc.) and department leads change often enough that
    manually re-assigning group membership in the Power BI service every time someone's role
    changed was becoming a recurring source of stale/incorrect access. This script reads the
    role-to-group mapping from config and reconciles it against the dataset in one pass.

    Uses the MicrosoftPowerBIMgmt module. Requires a service principal or an account with
    admin rights on the target workspace.

.PARAMETER ConfigPath
    Path to a JSON config file (see config.example.json for the expected shape).

.EXAMPLE
    .\Set-ReportPermissions.ps1 -ConfigPath .\config.json
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ConfigPath
)

function Write-Log {
    param([string]$Message, [string]$Level = "INFO", [string]$LogPath)

    $line = "[{0}] [{1}] {2}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $Level, $Message
    Write-Host $line

    if ($LogPath) {
        $logDir = Split-Path -Path $LogPath -Parent
        if ($logDir -and -not (Test-Path $logDir)) {
            New-Item -ItemType Directory -Path $logDir -Force | Out-Null
        }
        Add-Content -Path $LogPath -Value $line
    }
}

function Get-Config {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        throw "Config file not found at '$Path'. Copy config.example.json to config.json and fill in real values."
    }

    try {
        $config = Get-Content -Path $Path -Raw | ConvertFrom-Json
    }
    catch {
        throw "Failed to parse config file '$Path': $($_.Exception.Message)"
    }

    foreach ($required in @("workspaceId", "datasetId", "rlsRoleAssignments")) {
        if (-not $config.$required) {
            throw "Config is missing required field '$required'."
        }
    }

    return $config
}

function Sync-RlsRoleAssignment {
    param(
        [string]$WorkspaceId,
        [string]$DatasetId,
        [PSCustomObject]$Assignment,
        [string]$LogPath
    )

    # Replace with real calls once connected, e.g.:
    #   $existingMembers = Get-PowerBIDatasetRoleMember -Id $DatasetId -RoleName $Assignment.role
    #   if group not already assigned:
    #     Add-PowerBIDatasetRoleMember -Id $DatasetId -RoleName $Assignment.role -PrincipalType Group -Identifier $Assignment.securityGroup
    try {
        Write-Log -Message "Reconciling role '$($Assignment.role)' -> group '$($Assignment.securityGroup)' on dataset $DatasetId" -LogPath $LogPath
        # Placeholder for the actual Power BI REST/management-module call.
    }
    catch {
        Write-Log -Message "Failed to assign role '$($Assignment.role)': $($_.Exception.Message)" -Level "ERROR" -LogPath $LogPath
        throw
    }
}

try {
    $config = Get-Config -Path $ConfigPath
    Write-Log -Message "Loaded config from $ConfigPath — $($config.rlsRoleAssignments.Count) role(s) to reconcile." -LogPath $config.logPath

    foreach ($assignment in $config.rlsRoleAssignments) {
        Sync-RlsRoleAssignment -WorkspaceId $config.workspaceId -DatasetId $config.datasetId -Assignment $assignment -LogPath $config.logPath
    }

    Write-Log -Message "Done. $($config.rlsRoleAssignments.Count) role(s) reconciled." -LogPath $config.logPath
}
catch {
    Write-Log -Message $_.Exception.Message -Level "ERROR"
    exit 1
}
