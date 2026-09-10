<#
.SYNOPSIS
    Migrates a Power BI report + its dataset from one workspace to another (e.g. Dev -> Prod).

.DESCRIPTION
    On Power BI Pro licensing (no Premium capacity), there's no deployment pipeline feature
    available, so promoting a report from a dev/test workspace to production has to be done
    via the REST API instead. This script wraps that process: export the report from the
    source workspace, import it into the target, and log the result so migrations are
    traceable instead of being an undocumented manual click-through.

.PARAMETER ConfigPath
    Path to a JSON config file. Uses sourceWorkspaceId / targetWorkspaceId from config.example.json.

.PARAMETER ReportName
    Display name of the report to migrate (must exist in the source workspace).

.EXAMPLE
    .\Move-ReportBetweenWorkspaces.ps1 -ConfigPath .\config.json -ReportName "Training Investment Dashboard"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$ConfigPath,

    [Parameter(Mandatory = $true)]
    [string]$ReportName
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

    $config = Get-Content -Path $Path -Raw | ConvertFrom-Json

    foreach ($required in @("sourceWorkspaceId", "targetWorkspaceId")) {
        if (-not $config.$required) {
            throw "Config is missing required field '$required'."
        }
    }

    return $config
}

try {
    $config = Get-Config -Path $ConfigPath
    Write-Log -Message "Migrating report '$ReportName' from workspace $($config.sourceWorkspaceId) to $($config.targetWorkspaceId)" -LogPath $config.logPath

    # 1. Locate the report in the source workspace.
    #    $report = Get-PowerBIReport -WorkspaceId $config.sourceWorkspaceId -Name $ReportName

    # 2. Export it (report + dataset) as a .pbix to a temp path.
    #    Export-PowerBIReport -Id $report.Id -WorkspaceId $config.sourceWorkspaceId -OutFile $tempPath

    # 3. Import into the target workspace, overwriting if it already exists there.
    #    New-PowerBIReport -Path $tempPath -WorkspaceId $config.targetWorkspaceId -ConflictAction CreateOrOverwrite

    # 4. Re-point the migrated dataset's data source credentials if the target workspace
    #    uses a different gateway/connection than source (common gap — flagged here rather
    #    than silently left on stale credentials).

    Write-Log -Message "Migration steps are stubbed above — wire up the real Power BI REST/management-module calls before using this against a live tenant." -Level "WARN" -LogPath $config.logPath
    Write-Log -Message "Done." -LogPath $config.logPath
}
catch {
    Write-Log -Message $_.Exception.Message -Level "ERROR"
    exit 1
}
