#region Measure
$items = Get-ChildItem $args[0]
foreach($item in $items) {
    if ($item.Attributes -eq "Directory") {        
        $size = (Get-ChildItem $item.FullName -recurse -ErrorAction SilentlyContinue | Measure-Object -property length -sum).sum
    } else {        
        $size = $item.Length
    }

    $item | Add-Member -type NoteProperty -name Size -Value $size    
    Write-Progress -Activity "Calculating Disk Usage" -Status $item.Name -PercentComplete (($i++ / $items.length)  * 100)
}
#endregion

#region Output
if(($items | Measure-Object -property Size -Average).Average -gt 1GB) {
    $label = "Size (GB)"
    $divider = 1GB
} else {
    $label = "Size (MB)"
    $divider = 1MB
}
$items | Sort Size | Format-Table Name, @{Label=$label;Expression={$_.Size / $divider};FormatString="N2"}
#endregion