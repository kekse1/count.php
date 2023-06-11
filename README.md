<img src="https://kekse.biz/php/count.php?draw&override=github:count.php&fg=120,130,40&size=48&v=16" />

# [count.php](https://github.com/kekse1/count.php/)
It's a universal counter script. ... v**2.20.7**!

## Index
1. [News](#news)
2. [Issues](#issues)
3. [Installation](#installation)
	* [Dependencies](#dependencies)
4. [Details](#details)
	* [Storage](#storage)
	* [Server and/or Client](#server-andor-client)
	* [Refresh](#refresh)
	* [Override](#override)
	* [Cleaning](#cleaning)
	* [More privacy](#more-privacy)
	* [Errors](#errors)
	* [String filter](#string-filter)
5. [Drawing](#drawing)
	* [Parameters](#parameters)
	* [Dependencies](#dependencies-1)
6. [Configuration](#configuration)
	* [Constants](#constants)
	* [Relative paths](#relative-paths)
7. [Modes](#modes)
	* [Readonly mode](#readonly-mode)
	* [Drawing mode](#drawing-mode)
	* [Zero mode](#zero-mode)
	* [Hide mode](#hide-mode)
	* [Test mode](#test-mode)
	* [RAW mode](#raw-mode)
	* [CLI mode](#cli-mode)
8. [FAQ](#faq)
9. [The original version](#the-original-version)
10. [Copyright and License](#copyright-and-license)

## News
* Working on some CLI functions. After that, the major version can be increased (**nearly done!**); ...
* Added **new *default* font [`Intel One Mono`](https://github.com/intel/intel-one-mono/)**. Looks great (see the graphic on top)! :-)

## Issues
* Didn't test against PHP **v8** support (*TODO*)!
* As already mentioned in it's [FAQ entry](#-define-for-the-configurationsettings), I'm going to replace the `define()`. Soon..

**Please** _report any problems_ to me! Either by contacting me via E-Mail (see the
[Copyright and License](#copyright-and-license) section), or use the [Issues](https://github.com/kekse1/count.php/issues)
function of this github web site.. **Thank you**! :)~

## Installation
The easiest way is to just use this `count.php` with it's default configuration: copy it to some path
in your web root, create a `count/` directory in the same path (with `chmod 1777` maybe - or just make sure that your web server can
access the file system). **That's all!** :)~

The possible, possibly complex rest is described in the [Configuration section](#configuration).

As an important example, since there is another file system change necessary: if you want to enable the `DRAWING` routines. Then the
HTTPD needs access to a sub directory `fonts/`, with at least one installed `.ttf`(!) font in it (which you need to set as the _default
font_ in the `FONT` setting).

Now, **that's** all. :D~

### Dependencies
**NO** dependencies.

**Except** if you're enabling the `DRAWING` configuration. In this case it's the
'[**GD Library**](https://www.php.net/manual/en/book.image.php)'. More infos below, in the
[Drawing section](#drawing) and it's [drawing dependencies](#dependencies-1) sub section.

## Details
By default the script generates a `text/plain` output, so you can easily embed the counting value
via `XMLHttpRequest()` or the `Fetch API`. The real (HTTP-)`Content-Type` is configurable via the
`CONTENT` setting (on top of the file - see the '[Configuration](#configuration)' section).

BUT I've finally also managed the `<img>` drawing facilities (see below!), so you can also embed it
now as simple `<img src="..?draw[...]">`! See the '[Drawing](#drawing)' section.

Only in 'RAW mode' (see the '[Modes](#modes)' section) there'll be no real output, so that you can
integrate this script in your own PHP projects; just use the `kekse\counter\counter()` function.

### Storage
Uses the file system to store timestamp files for the client IPs (if actived `SERVER`); and
counting this files (which is a security concern) is done cached via some special files (so
no 'inefficient' `opendir()` etc. is always necessary ;). The values itself are also located in
the file system - one file for each host (secured auto-generation included, if you wish, and
also with a limit in their amount - if you don't create the value files manually; see `AUTO`
setting).

The file system is usually top in performance. A real database would be overload for such a
script. And using only one file and parse/render it by myself is not recommended, as it's very
inefficient.. the file system should be a great choice (and is only being used if `SERVER` is
set to `(true)`! :)~

### Server and/or Client
If a cookie (if actived `CLIENT`) already confirmed that the client connected within the
`THRESHOLD` (2 hours by default), no `SERVER` test will be done after this. And if a cookie
doesn't work, there's still this IP test left (if `SERVER` enabled).

### Refresh
If you are able to reload the counter dynamically on your web sites, please do it.

This would be great, because with every poll the timestamps get updated, so the **`THRESHOLD`** setting
(which gives you the logical, maximum time to refresh, btw.) is not the only prevention against multiple
countings; periodically polled it makes you some 'session' styles by adapting the timestamp, that will
never get too old this way.

So, if you're periodically polling this script (I'm doing it via `XMLHttpRequest()`), the client is not
being counted again after the THRESHOLD time over this 'session', until he disconnects. Then coming
back again _after_ the two hours (by default) he will get counted again. Pretty easy?

### Override
If(`OVERRIDE === true`), one can call the script's URL with `?override=(string)`, so neither regular
`$_SERVER['HTTP_HOST']` nor `$_SERVER['SERVER_NAME']` are being used, but an arbitrary (but filtered)
string (or just another host you define there).

I don't really like it, but if you need this feature, just use it. Works great.

Caution: the `AUTO` setting is also overridden in this case, so it's not possible to always use any
arbitrary parameter (also important for security). Thus, you first have to create a value file to the
corresponding string!

_**NEW** (since v**2.20.4**)_: `OVERRIDE` can also be a (non-empty) String, to define just one fixed
host(name) to use. Last possibility to override is the `counter()` function itself (first argument);
the strings are always filtered (by `secure_host()`), and every of these overrides sets
`OVERRIDDEN = true`. *PS: untested atm.*

### Cleaning
If configured, out-dated ip/timestamp files will be deleted (this and more is also possible in
the CLI (cmd-line) mode), if their timestamps are 'out-dated' (so if they have been written more
than `THRESHOLD` (by default 2 hours) seconds before).

If you define an `(integer)`, the cache will be cleared only if there are more files existing
than the (integer). And if you set it to `(null)`, every cleaning is **forbidden**, if you
want to collect all the IPs or so.. `(false)` would also never call the clean routine, except if
the `LIMIT` is exceeded..!

### More privacy
And if privacy is one of your concerns, the IPs (in their own files with their timestamps) can
also be hashed, so noone can see them (including yourself, or the webmaster(s), .. even with
access to the file system).

### Errors

#### Log file
Most errors will be appended to the `count.log` file (configurable via `LOG`), so webmasters etc. can
directly see what's maybe going wrong. _Due to security_, not everything is being logged. Especially
where one could define own `$_GET[*]` or so, which could end up in flooding the log file!

The file is configured via the `LOG` setting (and follows the rule(s) shown in [Relative Paths](#relative-paths).

#### Details
In `RAW` mode, errors won't be logged to file and they won't `die()`, but `throw new Exception(..)`.

But normally you won't use this mode. In this case errors are stopping the execution via `die()` (but
it's an abstracted function to manage the defails better). So if an error would be shown to the user
who called this script, it's either the `ERROR` string, if set: just looks better and safes space on
the web site, and the user mostly won't need to see the detailed error message.. by default they'll
just see `/` (instead of a numeric counter value).

Otherwise, without `ERROR` setting, they'll see the error message itself. .. When sending an error,
and if not already send, the defined `CONTENT` header will be sent - also on drawing errors.. otherwise
it'll be finally set when printing the value or drawing the image.

I used three functions for this. For you developers: please use them, and please **never** regular `die()`
nor `throw new Exception(..)`. These functions make it easier: `error()`, `log_error()`, `draw_error()`.

### String filter
_All `$_SERVER` and `$_GET` are filtered to reach more security._

I just abstracted both functions `secure_{host,path}()` to only one function, which is also used by
`get_param()`.. both functions stayed: they internally use `secure()`, but the `secure_host()` does
a `strtolower()` and the `secure_path()` also removes the `+`, `-` and `~` from the beginning of the
path string (these special characters to mark file types: `~` are value files, `-` are cache counters;
for amount of ip/timestamp files in the `+` marked directories - all for hosts).

So here you gotta know which characters you can pass, while the maximum length is 255 characters, btw.
(as good as I remember here - please feel free to look in the code for yourself):

* `a-z`
* `A-Z`
* `0-9`
* `,`
* `:`
* `(`
* `)`
* `/` (limited)
* `.` (limited)
* `-` (limited)
* `+` (limited)

That's also important for the *optional* `?override=` GET parameter (see above), e.g., as hosts (etc.)
won't be accepted 'as is' (see below at the [**FQDN**](#fqdns))..

#### **FQDN**'s
The string filter (above) also removes any trailing `.` from the hostnames; so if you call from a
 web browser with a hostname plus trailing dot `.`, which is a **FQDN**, it'll be removed, so the
couting is not disturbed (otherwise it would end up in another file for w/ and w/o `.`. ;-)

## Drawing
The normal way is to return the plain value (by default w/ `Content-Type: text/plain;charset=UTF-8`),
but I've also implemented some drawing routines, to embed the counter value as `<img>`.

If allowed by `DRAWING` setting, just use either `?draw` for all possible options, or just `?zero` to
draw a (nearly) empty output image (hidden counter, e.g. .. whereas there's also the `HIDE` setting!).

### Parameters
To use it, enable the `DRAWING` option and call script with (at least!) `?draw` (GET) parameter. More
isn't necessary, but there also also some GET parameters to adapt the drawing; as follows:

* `?draw`
* `?size=(int)` [24]
* `?font=(string)` [SourceCodePro]
* `?fg=(string)` [rgba(0, 0, 0, 1)]
* `?bg=(string)` [rgba(255, 255, 255, 0)]
* `?h=(int)` [0]
* `?v=(int)` [0]
* `?x=(int)` [0]
* `?y=(int)` [0]
* `?aa=(1|0|y|n)` [true]
* `?type=(string)` [png]

`x` and `y` are just moving the text along this both axis (in px).

`fg` and `bg` can be `rgb()`, `rgba()` or just the 3 bytes and optionally a floating point number
between 0 and 1 for the alpha component.

`v` is the space above and below the text, `h` is to the left and the right. They both can also be
negative values - as long as the resulting image won't rest up with size <1.. in this case there'll
be an error.

`size` is a font size in 'pt' or 'px' (ain't sure atm x)~
And the `font` needs to be installed in the `FONTS` directory, as `.ttf`.

The `aa` parameter needs to be `0`, `1`, `y` or `n` to configure anti-aliased text.

Last but not least, the `?type` can atm be set to `png` and `jpg`, whereas `png` is absolutely
preferred (example given: `jpg` does not have the best alpha-channel (transparency) support)!

**All parameters are optional**, but only the `?draw` isn't, and needs to be set if you want a graphical
output (only if allowed by `DRAWING` configuration). And just to mention it: take a look at `?zero` and
maybe also the `HIDE` setting, described somewhere above.. They are changing the way the output image looks
like.

### Dependencies
Important: the '[**GD Library**](https://www.php.net/manual/en/book.image.php)' has to be installed
for this feature. If it isn't, you can only use the regular `text/plain` output function of this script!

AND the GD library also needs 'FreeType' support with it, as we're drawing with True Type Fonts (this
is **not** checked within `-c/--check`, btw.).

The `-c/--check` test will also check if this library is installed, but MAYBE it's installed, but not
available in the CLI mode, so there'll be a warning there, but nevertheless it's working fine with the
web server..

Runned by a web server with enabled `DRAWING` option and also aktived via `?draw` will only call this
drawing mode if module is installed. If not, the regular (text/plain) output will nevertheless be used;
to avoid error output (even though it's bad that you're using an `<img>` tag..... but error output
wouldn't be visible in this case at all).

The **second dependency** is a configured `FONTS` directory with `.ttf`(!) font(s) installed in it (and
if you don't specify this via `?font` it really *needs* to be pre-set via `FONT` setting); ...

## Configuration
The configuration is just a set of constants. Look below at "CLI Mode" to get to know how to verify
your own configuration (via `-c/--check`)!

### Constants
As already mentioned in it's [FAQ entry](#-define-for-the-configurationsettings), I'm going to replace
these `define()`, very soon.. we don't like that they're being defined in the global namespace this way.

Until then the following list is the current state (I'll also re-order them a bit, btw.):

* `define('RAW', false);`
* `define('AUTO', 32);`
* `define('THRESHOLD', 7200);`
* `define('DIR', 'count');`
* `define('HIDE', false);`
* `define('CLIENT', true);`
* `define('SERVER', true);`
* `define('OVERRIDE', false);`
* `define('HASH', 'sha3-256');`
* `define('HASH_IP', false);`
* `define('CONTENT', 'text/plain;charset=UTF-8');`
* `define('CLEAN', true);`
* `define('LIMIT', 32768);`
* `define('LOG', 'count.log');`
* `define('ERROR', '/');`
* `define('NONE', '/');`
* `define('DRAWING', false);`
* `define('SIZE', 24);`
* `define('SIZE_LIMIT', 512);`
* `define('FONT', 'IntelOneMono');`
* `define('FONTS', 'fonts');`
* `define('H', 0);`
* `define('H_LIMIT', 256);`
* `define('V', 0);`
* `define('V_LIMIT', 256);`
* `define('FG', '0, 0, 0, 1');`
* `define('BG', '255, 255, 255, 0');`
* `define('AA', true);`
* `define('TYPE', 'png');`

It'd be better to create a `.htaccess` file with at least `Deny from all` in your `DIR` directory.
But consider that not every HTTPD (web server) does support such a file (e.g. `lighttpd`)!

### Relative paths
Absolute paths work as usual. But relative paths are used here in two ways.

If you define your `DIR`, `LOG` or `FONTS` as simple directory name like `count` or `count/`, it'll
be resolved from the location of your `count.php` script (using `__DIR__`). But to define this relative
to your current working directory, you've to define those paths with starting `./` (it's where the script
gets called; maybe as symbolic link or by defining a path via e.g. `php ./php/count.php`).

But `../` is relative to the `__DIR__` - if you also want to make this relative to the current working
directory, please use `./../`..

## Modes
Some of the modes are as follows. And they can **partially** be combined as well!

### Readonly mode
You can use the script regularily, but pass `?readonly` or just `?ro`. That will only return/draw the
current value without writing any files or cookies. The value is not changed then. So one can view it
without access to the file system or the CLI mode.

### Drawing mode
By using `?draw`, if `DRAWING` setting is enabled, the output will not be `text/plain` (or whatever you
define in `CONTENT`), but `image/png` or `image/jpeg`, so you can embed the counted value in `<img>`.

Please take a look at the [Drawing section](#drawing).

### Zero mode
The `?zero` should be set instead of `?draw`, just to draw an 'empty' (1px) `<img>`. If not defined
otherwise, it'll count invisible this way. :)~

### Hide mode
By setting `HIDE` to true or a string, this string will be shown instead of the real count value.
This feature is there for private couting, without letting the users known how much visitors you already
had.

Beware: if you _really_ want to hide these values, please create the `.htaccess` w/ `Deny from all` in
your `DIR` directory!

**BTW**: if `HIDE` is not a string, but (true), ouput will be a random integer. :]~

### Test mode
With `?test` there will nothing be counted, and the output (can also be combined with `?draw`) will be
a random integer value.

### RAW mode
This mode is not tested very well yet, could you do it for me, please? **Just for your info**: I used
`namespace kekse\counter`!

By defining `RAW = true` the base counting function won't be called automatically, so that you've the
chance of doing this in your PHP scripts manually. This way there'll be no real output (neither text
nor graphical), and you just get the current value returned by the `counter()` function.

The function to call from your scripts (after `require_once('count.php')` or so) is:

`function counter($_host = null, $_read_only = RAW, $_die = !RAW)`.

The first argument is (null) by default - but in `RAW` _plus_ `CLI` mode, where no `$_SERVER` is available,
you really need to set this argument to a host string, which will overwrite the regular `HOST`, etc.

If called w/ `$_readonly = false` and in `RAW` _plus_ `CLI` mode, every call of `counter()` will increase
the counter value, without `THRESHOLD` testing, etc. (as there's neither cookies available, nor an
IP address).

Last but not least: now in RAW mode every error won't be logged nor ends with `die()`, it's replaced
by a `throw new Exception(..)`! :)~

*PS: Not tested very well atm.. could you do it for me (as you maybe implement own PHP code which would use this)?*

### CLI mode
**You can test your configuration's validity by running the script from command line (CLI mode)!**
Just define the `--test/-t` (cmdline) parameter. ;)~

As it's not possible to do the default shebang `#!/usr/bin/env php`, you've to call the script
as argument to the `php` executable: `php count.php`. The shebang isn't possible, as web servers
running PHP scripts see them as begin of regular output! So: (a) it's shown in the browser.. and
(b) thus the script can't send any `header()` (necessary inter alia to define the content type,
as defined in `CONTENT` option)! .. so please, just type `php count.php` in your shell.

**BTW**: With enabled `RAW` setting this command line interface won't be shown (as this mode is for using
the script within other PHP scripts).

##### The argument vector
**Update**: The following list will change a bit soon, as I'm currently extending the `CLI` mode!

Just run the script without parameters to see all possible `argv[]` options. Here's the current list of
supported 'functions'.

|   Short | Long               | Description                                             |
| ------: | :----------------- | :-----------------------------------------------------: |
|    `-?` | `--help`           | Shows the link to this website..                        |
|    `-V` | `--version`        | Print current script's version.                         |
|    `-C` | `--copyright`      | Shows the author of this script. /me ..                 |
|    `-s` | `--set (... TODO)` | Initialize a value file, or set a specific value (TODO) |
|    `-v` | `--values [*]`     | All runtime status infos. w/ cache synchronization.     |
|    `-n` | `--sync [*]`       | Synchronize the cache with real counts (only)           |
|    `-l` | `--clean [*]`      | Clean all **outdated** (only!) ip/timestamp files..     |
|    `-p` | `--purge [*]`      | Delete any host's ip cache directory (w/ caches)!       |
|    `-c` | `--check`          | Verify if current configuration is valid.               |
|    `-h` | `--hashes`         | Available algorithms for `HASH` config.                 |
|    `-f` | `--fonts [*]`      | Available fonts for drawing `<img>`.                    |
|    `-t` | `--types`          | Available image types for drawing output.               |
|    `-e` | `--errors`         | Count error log lines, if existing..                    |
|    `-u` | `--unlog`          | Deletes the whole error log file, if already exists.    |

The optional `[*]` needs to be defined directly after the parameter; can be multiple arguments by
appending them as new `$argc` (space divided). If not specified, the functions will read in all
available hosts.

#### Prompts
As some operations are somewhat 'dangerous', especially at deletion of files, there'll be a prompt
to ask you for `yes` or `no` (sometimes/partially). So please confirm this questions, if shown; and
just answer with `y[es]` or `n[o]`, otherwise the `prompt()` will repeat it's question.

#### GLOB support
As hint for myself there's the [glob.txt](./docs/glob.txt), JF{M,Y}I..

When _really_ finished this, I'm thinking about managing the IP addresses (if you don't configured to hide them)
this way, in some way.. First idea is to look at their intersect (which hosts were visited by one/some IP(s)) ..
*has anyone other ideas??*

## FAQ
This section grew as I got comments on my code. And I hope for your reviews, really! Please contact me,
if you would like to review my code. I don't bite, promised! xD~

### # `define()` for the configuration/settings?
Yes.. it's not necessary to adapt this constants later. The only reason to change this: the constants
are in the global namespace, that's bad.. but alternatively I'm thinking about a `COUNT_` prefix for
the constants (or just a random value).

And btw.. usually I've always used a `config.inc.php`, but as it's such a 'tiny' script, I decided to
put everything down into just one `.php` file.. that's better here.

**EDIT**: Someone gave me this tip, which I'm going to follow (very soon):
https://stackoverflow.com/questions/18247726/php-define-constants-inside-namespace-clarification/

### # Why not using a `class`?
Just because it ain't necessary. I've just set a `namespace kekse\counter`, so everything is no longer
in the global namespace.. that should be enough. It could even really be, that using classes would even
end up in more resource consumption.. so, I think it's O.K. as it is now.. 'old skewl'! :)~

### # Installation via '[Composer](https://getcomposer.org/)'?
I'm pretty sure there's no real 'installation' necessary here.. additionally, there are also **no real
dependencies** which the 'Composer' would need to install.

A **minimum installation** is described above, in the [Installation section](#installation), jfyi!

### # Isn't this all a little big for such a script?
At least I've heard this from a reviewer..

**Don't panic!** The runtime will never use nor even define all the functions etc.. their existence
is reduced by some `if()` and as some are **sub**-functions of other functions, and also by evaluating
a minimum first, to maybe return earlier; etc..

I promise not to bloat everything too much; it's just a matter of fact that this script has many
features and is highly configurable.. nevertheless there are some optimizations etc., so it really
doesn't consume *that* much cpu time or memory.

*And if you find more possible optimizations, don't be shy and contact me! I'd be really happy. :-)*

**NEWS**: after cleaning up a bit with my commented out, original CLI functions (not yet finished, btw.)
the line count shrank a lot.. with v**2.20.7** there are only **3632 code lines** left. :)~

## The original version
**[The original version](php/original.php)** was a very tiny script as little helping hand for my web
projects. It rised a lot - see for yourself! :)~

## Copyright and License
The Copyright is [(c) Sebastian Kucharczyk](./COPYRIGHT.txt),
and it's licensed under the [MIT](./LICENSE.txt) (also known as 'X' or 'X11' license).
