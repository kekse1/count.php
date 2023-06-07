<img src="https://kekse.biz/php/count.php?draw&override=github:count.php&fg=120,130,40&size=48&v=16" />

# [count.php](https://github.com/kekse1/count.php/)
It's a universal counter script. ... v**2.18.6**!

## Index
1. [News](#news)
2. [Issues](#issues)
4. [Description](#description)
	* [Installation](#installation)
	* [Dependencies](#dependencies)
	* [Output](#output)
	* [Storage](#storage)
	* [Server and/or Client](#server-andor-client)
	* [More privacy](#more-privacy)
	* [Cleaning](#cleaning)
	* [Logging](#logging)
	* [Errors](#errors)
	* [Refresh](#refresh)
	* [Override](#override)
	* [String filter](#string-filter)
5. [Modes](#modes)
	* [Readonly mode](#readonly-mode)
	* [Drawing mode](#drawing-mode)
	* [Zero mode](#zero-mode)
	* [Hide mode](#hide-mode)
	* [Test mode](#test-mode)
	* [RAW mode](#raw-mode)
	* [CLI mode](#cli-mode)
6. [Drawing](#drawing)
	* [Parameters](#parameters)
	* [`DRAWING` dependencies](#drawing-dependencies)
8. [Configuration](#configuration)
	* [Constants](#constants)
	* [Relative paths](#relative-paths)
9. [FAQ](#faq)
10. [The original version](#the-original-version)
11. [Copyright and License](#copyright-and-license)

## News
* Currently working on some last CLI functions. After that, the major version can be increased.
* And some minor performance and security upgrades are also in progress.. and a bit more!
* Everything is in the `namespace counter` now (so all the functions are not defined globally)!

## Issues
* Didn't test against PHP **v8** support (TODO);
* **You** should also test this script, including it's security.. **thx**.
* After the `namespace` I'm thinking about using a `class` - but not sure if this is necessary...

## Description
**It should be _really_ maximum secure now** (as everyhing got it's own limit, and all the
`$_SERVER` and `$_GET` variables are filtered, so no code injection or file hijacking is
possible; etc.); .. see also the '[String filter](#string-filter)' sub section below. :)~

### Installation
The easiest way is to just use this `count.php` with it's default configuration: copy it to some path
in your web root, create a 'count/' directory in the same path (with `chmod 1777` maybe), and that's
all! :)~

The possible, possibly complex rest is described in the [Configuration section](#configuration).

### Dependencies
**NO** dependencies.

**Except** if you're enabling the `DRAWING` configuration. In this case it's the
'[**GD Library**](https://www.php.net/manual/en/book.image.php)'. More infos below, in the
[Drawing section](#drawing) and it's [`DRAWING dependencies`](#drawing-dependencies) sub section.

### Output
By default the script generates a `text/plain` output, so you can easily embed the counting value
via `XMLHttpRequest()` or the `Fetch API`. The real (HTTP-)`Content-Type` is configurable via the
`CONTENT` setting (on top of the file - see the '[Configuration](#configuration)' section).

BUT I've finally also managed the `<img>` drawing facilities (see below!), so you can also embed it
now as simple `<img src="..?draw[...]">`! See the '[Drawing](#drawing)' section.

Only in 'RAW mode' (see the '[Modes](#modes)' section) there'll be no real output, so that you can
integrate this script in your own PHP projects; just use the `counter()` function.

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

### More privacy
And if privacy is one of your concerns, the IPs (in their own files with their timestamps) can
also be hashed, so noone can see them (including yourself, or the webmaster(s), .. even with
access to the file system).

### Cleaning
If configured, out-dated ip/timestamp files will be deleted (this and more is also possible in
the CLI (cmd-line) mode), if their timestamps are 'out-dated' (so if they have been written more
than `THRESHOLD` (by default 2 hours) seconds before).

If you define an `(integer)`, the cache will be cleared only if there are more files existing
than the (integer). And if you set it to `(null)`, every cleaning is **forbidden**, if you
want to collect all the IPs or so.. `(false)` would also never call the clean routine, except if
the `LIMIT` is exceeded..!

### Logging
Most errors will be appended to the `count.log` file (configurable via `LOG`), so webmasters
etc. can directly see what's maybe going wrong.

Due to security, not everything is being logged. Especially where one could define own `$_GET[*]`
or so, which could end up in floating the log file..

### Errors
_TODO_: In RAW mode errors **will** be thrown via `throw`, never `die()` or so.

//**TODO**/describe `ERROR` and `NONE` settings.
//**TODO**/describe sending headers, etc.
//**TODO**/all in one my three error functions!
//**TODO**/there was even more..

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

### String filter
All `$_SERVER` and `$_GET` are filtered to reach more security.

I just abstracted both functions `secure_{host,path}()` to only one function, which is also used by
`get_param()`.. both functions stayed: they internally use `secure()`, but the `secure_host()` does
a `strtolower()` and the `secure_path()` also removes the `+`, `-` and `~` from the beginning of the
path string (these special characters to mark file types: `~` are value files, `-` are cache counters;
for amount of ip/timestamp files in the `+` marked directories - all for hosts).

So here you gotta know which characters you can pass (maximum string length is 255 characters, btw.):

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

That's also important for the *optional* `?override=` GET parameter (see above).

#### **FQDN**'s
The string filter (above) also removes any trailing `.` from the hostnames; so if you call from a
 web browser with a hostname plus trailing dot `.`, which is a **FQDN**, it'll be removed, so the
couting is not disturbed (otherwise it would end up in another file for w/ and w/o `.`. ;-)

### (TODO)
...

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
This mode is not tested very well yet, could you do it for me, please?

By defining `RAW = true` the base counting function won't be called automatically, so that you've the
chance of doing this in your PHP scripts manually. This way there'll be no real output (neither text
nor graphical), and you just get the current value returned by the `counter()` function.

The function to call from your scripts (after `require_once('count.php')` or so) is:

`function counter($_host = null, $_read_only = RAW, $_die = !RAW)`.

The first argument is (null) by default - but in RAW mode, where no `$_SERVER` is available, you really
need to set this argument to a host string, which will overwrite the regular `HOST`, etc.

If called w/ `$_readonly = false` and in RAW mode, every call of `counter()` will increase the counter
value, without `THRESHOLD` testing, etc. (as there's neither cookies available, nor an IP address).

And btw: I'll extend it this way, that in `RAW` mode any `die()` are going to be replaced by `throw`
(which is easily managed in my abstract function(s) for this).

### CLI mode
**You can test your configuration's validity by running the script from command line (CLI mode)!**
Just define the `--test/-t` (cmdline) parameter. ;)~

As it's not possible to do the default shebang `#!/usr/bin/env php`, you've to call the script
as argument to the `php` executable: `php count.php`. The shebang isn't possible, as web servers
running PHP scripts see them as begin of regular output! So: (a) it's shown in the browser.. and
(b) thus the script can't send any `header()` (necessary inter alia to define the content type,
as defined in `CONTENT` option)! .. so please, just type `php count.php` in your shell.

#### The argument vector
Just run it without parameters to see all possible `argv[]` options. Here's the current list of
supported 'functions' (in CLI just call the script without arguments to see this list):

|   Short | Long               | Description                                             |
| ------: | :----------------- | :-----------------------------------------------------: |
|    `-?` | `--help`           | Shows the link to this website..                        |
|    `-V` | `--version`        | Print current script's version.                         |
|    `-C` | `--copyright`      | Shows the author of this script. /me ..                 |
|    `-c` | `--config`         | Verify if current configuration is valid.               |
|    `-h` | `--hashes`         | Available algorithms for `HASH` config.                 |
|    `-f` | `--fonts`          | Available fonts for drawing `<img>`.                    |
|    `-t` | `--types`          | Available image types for drawing output.               |
|    `-s` | `--set (... TODO)` | Initialize a value file, or set a specific value (TODO) |
|    `-v` | `--values [*]`     | All runtime status infos. w/ cache synchronization.     |
|    `-n` | `--sync [*]`       | Synchronize the cache with real counts (only)           |
|    `-l` | `--clean [*]`      | Clean all **outdated** (only!) ip/timestamp files..     |
|    `-p` | `--purge [*]`      | Delete any host's ip cache directory (w/ caches)!       |
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
This is yet partially done, and will be continued to all the \[`-v`,`-n`,`-l`,`-p`\] (maybe more??).
At the moment it's already integrated in `--values/-v`. Worx so far..

As hint for myself there's the [glob.txt](./docs/glob.txt), JFMY.

After finishing this, I'll maybe start to implement `glob()` searches for IPs, to kinda manage them.
Idea is to look at the intersect, which hosts were visited by one/some IP(s). .. **anyone other ideas??**

## Drawing
The normal way is to return the plain value (by default w/ `Content-Type: text/plain;charset=UTF-8`),
but I've also implemented some drawing routines, to embed the counter value as `<img>`.

If allowed by `DRAWING` setting, just use either `?draw` for all possible options, or just `?zero` to
draw a (nearly) empty output image (hidden counter, e.g. .. whereas there's also the `HIDE` setting!).

### Parameters
To use it, enable the `DRAWING` option and call script with (at least!) `?draw` GET parameter. More
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

**All parameters are optional**, but the `?draw` needs to be set if you want a graphical output
(only if allowed by `DRAWING` configuration). And just to mention it: take a look at `?zero`
and maybe also the `HIDE` setting, described somewhere above.. They are changing the way the
output image looks like.

### `DRAWING` dependencies
Important: the '[**GD Library**](https://www.php.net/manual/en/book.image.php)' has to be installed
for this feature. If it isn't, you can only use the regular `text/plain` output function of this script!

AND the GD library also needs 'FreeType' support with it, as we're drawing with True Type Fonts (this
is **not** checked within `-c/--config`, btw.).

The `-c/--config` test will also check if this library is installed, but MAYBE it's installed, but not
available in the CLI mode, so there'll be a warning there, but nevertheless it's working fine with the
web server..

Runned by a web server with enabled `DRAWING` option and also aktived via `?draw` will only call this
drawing mode if module is installed. If not, the regular (text/plain) output will nevertheless be used;
to avoid error output (even though it's bad that you're using an `<img>` tag..... but error output
wouldn't be visible in this case at all).

The second dependency is a configured `FONTS` directory with `.ttf` fonts installed in it! ..

## Configuration
The configuration is just a set of constants. Look below at "CLI Mode" to get to know how to verify
your own configuration (via `-c/--config`)!

### Constants
They are located on top of the file.

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
* `define('FONT', 'SourceCodePro');`
* `define('FONTS', 'fonts');`
* `define('H', 0);`
* `define('H_LIMIT', 256);`
* `define('V', 0);`
* `define('V_LIMIT', 256);`
* `define('FG', '0, 0, 0, 1');`
* `define('BG', '255, 255, 255, 0');`
* `define('AA', true);`
* `define('TYPE', 'png');`

It'd be better to create a `.htaccess` file with at least `Deny from all` in your `DIR` directory
and maybe also in the `FONTS` directory, to be absolutely sure. But consider that not every HTTPD
supports such a file.

### Relative paths
Absolute paths work as usual. But relative paths are used here in two ways.

If you define your `DIR`, `LOG` or `FONTS` as simple directory name like `count` or `count/`, it'll
be resolved from the location of your `count.php` script (using `__DIR__`). But to define this relative
to your current working directory, you've to define those paths with starting `./` (it's where the script
gets called; maybe as symbolic link or by defining a path via e.g. `php ./php/count.php`).

But `../` is relative to the `__DIR__` - if you also want to make this relative to the current working
directory, please use `./../`..

## FAQ
This section grew as I got comments on my code. And I hope for your reviews, really! Please contact me,
if you would like to review my code. I don't bite, promised! xD~

##### * `define()` for the configuration/settings?
Yes.. **if I don't upgrade to a `class`** it's not necessary to adapt this constants later. The only
reason to change this: the constants are in the global namespace, that's bad.. but as I said: maybe
I'm 'upgrading' to classes, so the config could be defined in there.

Alternatively I'm thinking about a `COUNT_` prefix for all these constants, as they're defined in the
global scope..

And btw.. usually I've always used a `config.inc.php`, but as it's such a 'tiny' script, I decided to
put everything down into just one `.php` file..!

##### * Why not a `class`?
Just because it ain't necessary. But **maybe** I'll upgrade.. not sure atm.
I've just set a `namespace`, so everything is no longer in the global namespace.. maybe that's enough.

##### * Installation via '[Composer](https://getcomposer.org/)'?
I'm pretty sure there's no real 'installation' necessary here.. additionally, there are also **no real
dependencies** which the 'Composer' would need to install.

A **minimum installation** is described above, in the [Installation section](#installation), jfyi!

## The original version
**[The original version](php/original.php)** was a very tiny script as little helping hand for my web
projects. It rised a lot - see for yourself! :)~

## Copyright and License
The Copyright is [(c) Sebastian Kucharczyk](./COPYRIGHT.txt),
and it's licensed under the [MIT](./LICENSE.txt) (also known as 'X' or 'X11' license).
