# NagiosPlugins
Plugins that I use with Nagios.

Powershell/test_check.ps1
I find it handy to have a simply check that can be run on a system. One that doesn't take a bunch of arguments, or rely on anything other than the host you're trying to monitor, and Nagios itself. It accepts two arguments.
-returncode
-timetowait
Returncode defaults to 2, critical. You can specify 0 (OK), 1 (WARNING), 2 (CRITICAL), 3,4,6,7,8+ (UNKNOWN), or 5 which will give you a random return code from 0-3.
Timetowait defaults to 2, and is the number of seconds that the script will sleep before it actually starts working. Helpful for testing checks that may take some time to complete. 
