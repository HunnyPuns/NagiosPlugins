param (
    [int] $returncode = 2,
    [int] $timetowait = 2
)

Start-Sleep -Seconds $timetowait

if ($returncode -ge 5) {
    $returncode = Get-Random -Minimum 0 -Maximum 3
}

switch ($returncode) {
    0 {echo "OK: Return code = $returncode.<br />This is fine."}
    1 {echo "WARNING: Return code = $returncode.<br />This is less fine."}
    2 {echo "CRITICAL: Return code = $returncode.<br />This is not fine."}
    default {echo "UNKNOWN: The requested code, $returncode, doesn't make sense."}
}

exit $returncode
