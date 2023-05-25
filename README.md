# count.php
It's a universal counter script. Still beta (until **you** tested it ;)~ ... v2.5.7.

It's based on one file each HTTP host (without any GET('?')-parameters), with outputting
the counted values as `Content-Type: text/plain;charset=UTF-8` (by default). So you can
embed it via XMLHttpRequest() or the 'Fetch API', e.g.. mainly used in my **kekse.biz**
library project, see [https://github.com/kekse1/kekse.biz/], and also for all my other
websites, where no further configuration or copy of this script is necessary. ;)~

## TODO
* **going to remove any port for the value files, so it's host-only-defined**..
* the clean() routine is still TODO
* Going to extend the CLI functionality! ;)~

## Functionality, Security & Efficiency
**It should be _really_ maximum secure now** (as everyhing got it's own limit, and all the
`$_SERVER` variables are filtered, so no code injection is possible; etc.); ..

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

### Configuration parameters

* `define('AUTO', 255)`
* `define('THRESHOLD', 7200)`
* `define('PATH', 'count')`
* `define('CLIENT', true)`
* `define('SERVER', true)`
* `define('HASH', 'sha3-256')`
* `define('HASH_IP', true)`
* `define('CONTENT', 'text/plain;charset=UTF-8')`
* `define('CLEAN', false)`
* `define('LIMIT', 65535)`
* `define('LOG', 'ERROR.log')`
* `define('ERROR', '/')`
* `define('NONE', '/')`

They are located on top of the file.

### CLI mode
**You can test your configuration's validity by running the script from command line (CLI mode)!**

As it's not possible to do the default shebang `#!/usr/bin/env php`, you've to call the script
as argument to the 'php' executable: `php count.php`. The shebang isn't possible, as web servers
running PHP scripts see them as begin of regular output! So: (a) it's shown in the browser.. and
(b) thus the script can't send any `header()` (necessary inter alia to define the content type,
as defined in 'CONTENT' option)! .. so please, just type `php count.php` in your shell.

#### The argument vector
Just run it without parameters to see all possible argv[] options.
Here's also the current list:

| Short | Long        | Description                               |
| ----: | :---------- | :---------------------------------------: |
|    -? | --help      | Mo' infoz (TODO)..                        |
|    -v | --version   | Print current script's version.           |
|    -C | --copyright | Shows the author of this script. ^_^      |
|    -c | --check     | Verify if current configuration is valid. |
|    -h | --hashes    | Available algorithms for 'HASH' config.   |

#### Default output
Without parameter there WILL be a status output with all host's values and the count of all the
IP/timestamp files of all the available hosts (with a synchronization, if this cache differs from
the real `countFiles(..)` (but still TODO :)~ ...

