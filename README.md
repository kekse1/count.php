# count.php
It's a universal counter script. Still beta (until **you** tested it ;)~ ... v**2.6.2**!

It's based on one file each HTTP host (without any GET('?')-parameters), with outputting
the counted values as `Content-Type: text/plain;charset=UTF-8` (by default). So you can
embed it via XMLHttpRequest() or the 'Fetch API', e.g.. mainly used in my **kekse.biz**
library project, see [https://github.com/kekse1/kekse.biz/], and also for all my other
websites, where no further configuration or copy of this script is necessary. ;)~

In the (near) future there will also be the option to DRAW an `<img>`, so embedding would
be even easier. x)~

## TODO
* the clean() routine is still TODO!!
* MAYBE the ip-counter doesn't work correctly?? test even more, pls..
* Still going to extend the CLI functionality. ;)~
* To simply embed as `<img>` I'll implement some drawing routines for this.. it'd be great! ;)~

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

* `define('AUTO', 32)`
* `define('THRESHOLD', 10800)`
* `define('PATH', 'count')`
* `define('CLIENT', true)`
* `define('SERVER', true)`
* `define('HASH', 'sha3-256')`
* `define('HASH_IP', true)`
* `define('CONTENT', 'text/plain;charset=UTF-8')`
* `define('CLEAN', false)`
* `define('LIMIT', 32768)`
* `define('LOG', 'ERROR.log')`
* `define('ERROR', '/')`
* `define('NONE', '/')`
* `define('DRAW', false)` (TODO!)
* `define('DRAW_PARAMS', true)`
* `define('SIZE', 24)` (?)
* `define('SIZE_LIMIT', 96)`;
* `define('FONT', 'Source Code Pro')`
* `define('FONT_LIMIT', [ 'Candara', 'Open Sans', 'Source Code Pro' ])`
* `define('COLOR_FG', 'rgba(0, 0, 0, 1)')`
* `define('COLOR_BG', 'rgba(255, 255, 255, 0)')`

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

| Short | Long        | Description                                         |
| ----: | :---------- | :-------------------------------------------------: |
|    -? | --help      | Mo' helping infoz, pls. (TODO)..                    |
|    -v | --version   | Print current script's version.                     |
|    -C | --copyright | Shows the author of this script. /me ..             |
|    -h | --hashes    | Available algorithms for 'HASH' config.             |
|    -t | --test      | Verify if current configuration is valid.           |
|    -s | --stats     | All runtime status infos. w/ cache synchronization. |
|    -l | --clean     | Clean all **outdated** (only!) ip/timestamp files.. |
|    -p | --purge     | Delete any host's ip cache directory (w/ caches)!   |
|    -i | --init      | Reset the _whole_ count directory (**CAUTION**)!    |

All of these functions which are still TODO are marked as it in the default 'syntax' output..

#### Default output
Without parameter, a helping 'syntax' output will be written to STDOUT. If you define one of these,
please select only one in each call (otherwise any first occurence will select the called function).

