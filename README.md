# count.php
It's still beta.. v2.5.2.

* have to test the count files again
* not sure about port numbers (maybe a 'PORT' config is necessary?)
* the clean() routine is still TODO
* ..?

## Functionality, Security & Efficiency
My _universal [counter script](scripts/count.php)_ should be **really** maximum secure now,
as everyhing got it's own limit, and handling the `$_SERVER` variables etc. are also running
through a (character) filter; etc.

Uses the file system to store timestamp files for the client IPs (if actived 'SERVER'); and
counting this files (which is a security concern) is done cached via some special files (so
no 'inefficient' `scandir()` is always necessary ;). The values itself are also located in
the file system - one file for each host (secured auto-generation included, if you wish, and
also with a limit in their amount - if you don't create the value files manually ;).

If a cookie (if actived 'CLIENT') already confirmed that the client connected within the
'THRESHOLD' (2 hours atm), no 'SERVER' test will be done after this. And if a cookie doesn't
work, there's still this IP test left. If privacy is one of your concerns, the IPs (in their
own files with timestamps) can also be hashed, so noone can see them. Last feature will be
a clean-up routine, but this is yet (the last) TODO.

Last but not least: every error will be appended to the 'ERROR.log' file, so webmasters can
directly see what's maybe going wrong.. ;)~

Anything else to mention here? Yes, one point: by default the script generates a 'text/plain'
output, so you can easily embed the counting value via 'XMLHttpRequest()' or the 'Fetch API'.

## Configuration
Configuration is (on top of file):
* `define('AUTO', 255)`
* `define('THRESHOLD', 7200)`
* `define('DIRECTORY', 'count')`
* `define('CLIENT', true)`
* `define('SERVER', true)`
* `define('HASH', 'sha3-256')`
* `define('HASH_IP', true)`
* `define('TYPE_CONTENT', 'text/plain;charset=UTF-8')`
* `define('CLEAN', false)`
* `define('LIMIT', 65535)`
* `define('LOG', 'ERROR.log')`
* `define('ERROR', '/')`
* `define('NONE', '/')`

**You can test your own configuration (if it's valid) by running this script from command line
('cli' mode) now!** Additionally I've integrated a check for '--help' or '-?', but the output
is still TODO.

