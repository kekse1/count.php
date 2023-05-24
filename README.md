# count.php
It's a universal counter script. And it's still beta.. v2.5.4.

* have to test the count files again (but they seem to work correctly)
* maybe a 'PORT' config necessary? and have to set the cookie-[domain] w/o port!
* the clean() routine is still TODO
* Going to extend the CLI functionality! ;)~

## Functionality, Security & Efficiency
It should be **really** maximum secure now (as everyhing got it's own limit, and all the
`$_SERVER` variables are filtered, so no code injection is possible; etc.

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

### CLI mode
**You can test your own configuration (if it's valid) by running this script from command line
(CLI mode) now!** Additionally I've integrated a check for '--help' or '-?', but the output
is still TODO. And there'll be more CLI possibilities and argv parameters, including a short
output of all the counted values and also a synchronisation of count files (if they differ from
the real file count).

### Config parameters (define())

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

They are located on top of the file.

