# Script: Full Technical PC Specs for Web Dev & Cybersecurity
# Output: F:\pc-specs\Full_PC_Specs.html
# -------------------------------

# Create folder
$folderPath = "F:\pc-specs"
if (-not (Test-Path $folderPath)) { New-Item -Path $folderPath -ItemType Directory | Out-Null }

# --- SYSTEM & OS INFO ---
$OS = Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber, OSArchitecture, LastBootUpTime, RegisteredUser, SerialNumber

# --- CPU INFO ---
$CPU = Get-CimInstance Win32_Processor | Select-Object Name, Manufacturer, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed, L2CacheSize, L3CacheSize

# --- RAM INFO ---
$RAM = Get-CimInstance Win32_PhysicalMemory | 
    Select-Object Manufacturer, PartNumber, SerialNumber, @{Name="Capacity(GB)";Expression={[math]::Round($_.Capacity/1GB,2)}}, Speed, MemoryType

# --- GPU INFO ---
$GPU = Get-CimInstance Win32_VideoController | Select-Object Name, DriverVersion, VideoProcessor, AdapterCompatibility, @{Name="VRAM(GB)";Expression={[math]::Round($_.AdapterRAM/1GB,2)}}

# --- DISK INFO ---
$Disk = Get-CimInstance Win32_DiskDrive | 
    Select-Object Model, MediaType, SerialNumber, @{Name="Size(GB)";Expression={[math]::Round($_.Size/1GB,2)}}

# --- PARTITION INFO ---
$Partitions = Get-Partition | 
    Select-Object DriveLetter, Size, @{Name="FreeSpace(GB)";Expression={[math]::Round(($_.Size - (($_ | Get-Volume).SizeRemaining))/1GB,2)}}, @{Name="FileSystem";Expression={(Get-Volume -DriveLetter $_.DriveLetter).FileSystem}}

# --- MOTHERBOARD & BIOS ---
$Motherboard = Get-CimInstance Win32_BaseBoard | Select-Object Manufacturer, Product, SerialNumber
$BIOS = Get-CimInstance Win32_BIOS | Select-Object Manufacturer, SMBIOSBIOSVersion, ReleaseDate, SerialNumber

# --- NETWORK INFO ---
$Network = Get-CimInstance Win32_NetworkAdapter | Where-Object {$_.NetEnabled -eq $true} | 
    Select-Object Name, MACAddress, Speed, AdapterType, Manufacturer

# --- FIREWALL STATUS ---
$Firewall = Get-NetFirewallProfile | Select-Object Name, Enabled

# --- ANTIVIRUS STATUS ---
$AV = Get-CimInstance -Namespace "root\SecurityCenter2" -ClassName AntiVirusProduct | Select-Object displayName, pathToSignedProductExe, productState

# --- INSTALLED SOFTWARE (useful for devs/security) ---
$Software = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | 
    Select-Object DisplayName, DisplayVersion, Publisher, InstallDate | Where-Object { $_.DisplayName -ne $null } | Sort-Object DisplayName

# --- POWER SHELL MODULES ---
$Modules = Get-Module -ListAvailable | Select-Object Name, Version

# --- ENVIRONMENT VARIABLES ---
$EnvVars = Get-ChildItem Env: | Select-Object Name, Value

# --- Generate HTML ---
$html = @"
<html>
<head>
    <title>Full Technical PC Specs</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        h1 { color: #2E86C1; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #2E86C1; color: white; }
        tr:nth-child(even){background-color: #f2f2f2;}
        pre { background-color: #f4f4f4; padding: 10px; }
    </style>
</head>
<body>
    <h1>Full Technical PC Specs Report</h1>

    <h2>Operating System</h2>
    $($OS | ConvertTo-Html -Fragment)

    <h2>CPU</h2>
    $($CPU | ConvertTo-Html -Fragment)

    <h2>RAM</h2>
    $($RAM | ConvertTo-Html -Fragment)

    <h2>GPU</h2>
    $($GPU | ConvertTo-Html -Fragment)

    <h2>Disk Drives</h2>
    $($Disk | ConvertTo-Html -Fragment)

    <h2>Partitions</h2>
    $($Partitions | ConvertTo-Html -Fragment)

    <h2>Motherboard</h2>
    $($Motherboard | ConvertTo-Html -Fragment)

    <h2>BIOS</h2>
    $($BIOS | ConvertTo-Html -Fragment)

    <h2>Network Adapters</h2>
    $($Network | ConvertTo-Html -Fragment)

    <h2>Firewall Status</h2>
    $($Firewall | ConvertTo-Html -Fragment)

    <h2>Antivirus Status</h2>
    $($AV | ConvertTo-Html -Fragment)

    <h2>Installed Software</h2>
    $($Software | ConvertTo-Html -Fragment)

    <h2>PowerShell Modules</h2>
    $($Modules | ConvertTo-Html -Fragment)

    <h2>Environment Variables</h2>
    $($EnvVars | ConvertTo-Html -Fragment)

</body>
</html>
"@

# Save HTML file
$filePath = "$folderPath\Full_PC_Specs.html"
$html | Out-File -FilePath $filePath -Encoding UTF8

Write-Host "Full technical PC specs saved successfully to $filePath"

Full technical PC specs saved successfully to F:\pc-specs\Full_PC_Specs.html
