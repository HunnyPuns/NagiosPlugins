# NagiosPlugins
Plugins that I use with Nagios.

### Powershell/test_check.ps1
I find it handy to have a simple check that can be run on a system. One that doesn't take a bunch of arguments, or rely on anything other than the host you're trying to monitor, and Nagios itself. It accepts two arguments, neither are required.

**-returncode**
Returncode defaults to 2, CRITICAL. You can specify 0 (OK), 1 (WARNING), 2 (CRITICAL), 3,4,6,7,8+ (UNKNOWN), or 5 which will give you a random return code from 0-3.
**-timetowait**
Timetowait defaults to 2, and is the number of seconds that the script will sleep before it actually starts working. Helpful for testing checks that may take some time to complete.

### Powershell/check\_windows\_files.ps1
First serious plugin. I plan to grow this one, and make it useful in the real world, while also being educational. For each of the checks, I want to have a few different examples of how to gather the data. For example, right now I'm mostly using CIM to gather the data, but a lot of this could be captured with a typical Get-ChildItem cmdlet.

In any case, this is a beefier script already, so let's break it down.

**-checkPath**
Required. This is the path you will use for your check. If you are checking that a file exists, or checking the size of a file, this should point directly to a file. E.g. C:\\\My\\\Cool\\\file.txt

Which brings up the second point. I have not validated the path yet, so make sure you use two backslashes. This is required for the CIM queries.

**-exists**
Not required. This is a switch, so just invoking it will get the script started down the path of verifying whether a file exists or not.

**-shouldnotexist**
Not required. Another switch, one to be used with **-exists**. Use this switch if you are checking to see if a file exists, and you want to be alerted that it does exist.

**-size**
Not required. This is a switch, and sets the script down the path of checking a file's size, reported in bytes.

**-sizewarning**
Not required, integer. The number provided here sets the warning threshold, in bytes.

**-sizecritical**
Not required, integer. The number provided here sets the critical threshold, in bytes.

**-number**
Not required, switch. Sets the script down the path of monitoring the number of files in a directory. For this, your **-checkPath** should end in a directory without trailing slashes. E.g. -checkPath C:\\\My\\\Cool

**-numwarning**
Not required, integer. The number provided here sets the warning threshold for number of files in the specified directory.

**-numcritical**
Not required, integer. The number provided here sets the critical threshold for the number of files in the specified directory.
