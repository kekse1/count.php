<img src="https://kekse.biz/php/count.php?zero&override=github:count.php" />
<img src="https://kekse.biz/php/count.php?draw&test&fg=120,130,40&size=48" />

# count.php
It's a universal counter script. ... v**2.15.2**!

## Index
* [Functionality, Security & Efficiency](#functionality-security--efficiency)
* [Configuration](#configuration)
* [Drawing](#drawing)
* [CLI Mode](#cli-mode)
* [Original](#original)

## Functionality, Security & Efficiency
**It should be _really_ maximum secure now** (as everyhing got it's own limit, and all the
`$_SERVER` and `$_GET` variables are filtered, so no code injection or file hijacking is
possible; etc.); ..

Uses the file system to store timestamp files for the client IPs (if actived `SERVER`); and
counting this files (which is a security concern) is done cached via some special files (so
no 'inefficient' `scandir()` is always necessary ;). The values itself are also located in
the file system - one file for each host (secured auto-generation included, if you wish, and
also with a limit in their amount - if you don't create the value files manually ;).

If a cookie (if actived `CLIENT`) already confirmed that the client connected within the
`THRESHOLD` (2 hours atm), no `SERVER` test will be done after this. And if a cookie doesn't
work, there's still this IP test left. If privacy is one of your concerns, the IPs (in their
own files with timestamps) can also be hashed, so noone can see them.

If configured, out-dated ip/timestamp files will be deleted (this and more is also possible in
the CLI (cmd-line) mode).

Last but not least: every error will be appended to the `count.log` file (configurable in it's
path), so webmasters can directly see what's maybe going wrong.. ;)~

Anything else to mention here? Yes, one point: by default the script generates a `text/plain`
output, so you can easily embed the counting value via `XMLHttpRequest()` or the `Fetch API`;
BUT I've finally managed now the `<img>` drawing facilities (see below!), so you can also embed
it now as simple `<img src="..?draw[...]">`! :D~

### Refresh
If you are able to reload the counter dynamically on your web sites, please do it.

This would be great, because with every poll the timestamps get updated, so the **`THRESHOLD`** setting
(which gives you the logical, maximum time to refresh, btw.) is not the only prevention against multiple
countings; periodically polled it makes you some 'session' styles by adapting the timestamp, that will
never get too old this way.

So, if you're periodically polling this script (I'm doing it via `XMLHttpRequest()`), the client is not
being counted again after the THRESHOLD time over this 'session', until he disconnects. Then coming
back again _after_ the two hours (by default) he will get counted again. Pretty easy?

### Readonly mode
You can use the script regularily, but pass `?readonly` or just `?ro`. That will only return/draw the
current value without writing any files or cookies. The value is not changed then. So one can view it
without access to the file system or the CLI mode.

### Zero mode
The `?zero` should be set instead of `?draw`, just to draw an 'empty' (1px) `<img>`. If not defined
otherwise, it'll count invisible this way. :)~

### Private ('hide') mode
By setting `HIDE` from (null) to a string, this string will be shown instead of the real count value.
This feature is there for private couting, without letting the users known how much visitors you already
had.

Beware: if you _really_ want to hide these values, please create the `.htaccess` w/ `Deny from all` in
your `DIR` directory!

### Test mode
With `?test` there will nothing be counted, and the output (can also be combined with `?draw`) will be
a random integer value.

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
* `.` (limited)
* `,`
* `:`
* `-` (partially)
* `+` (partially)
* `(`
* `)`
* `/` (limited)
* `\` (limited)

That's also important for the *optional* `?override=` GET parameter (see above).

### ...
...TODO.

## Configuration
The configuration is just a set of constants. Look below at "CLI Mode" to get to know how to verify
your own configuration (via `-c/--config`)!

### Configuration parameters
They are located on top of the file.

* `define('AUTO', 32);`
* `define('THRESHOLD', 7200);`
* `define('DIR', 'count');`
* `define('HIDE', null);`
* `define('OVERRIDE', false);`
* `define('CLIENT', true);`
* `define('SERVER', true);`
* `define('HASH', 'sha3-256');`
* `define('HASH_IP', true);`
* `define('CONTENT', 'text/plain;charset=UTF-8');`
* `define('CLEAN', true);`
* `define('LIMIT', 32768);`
* `define('LOG', 'count.log');`
* `define('ERROR', '/');`
* `define('NONE', '/');`
* `define('DRAWING', true);`
* `define('SIZE', 24);`
* `define('SIZE_LIMIT', 512);`
* `define('SPACE', 1);`
* `define('SPACE_LIMIT', 256);`
* `define('PAD', 1);`
* `define('PAD_LIMIT', 256);`
* `define('FONT', 'SourceCodePro');`
* `define('FONTS', 'fonts');`
* `define('FG', '0, 0, 0, 1');`
* `define('BG', '255, 255, 255, 0');`
* `define('AA', true);`
* `define('TYPE', 'png');`

It'd be better to create a `.htaccess` file with at least `Deny from all` in your `DIR` directory
and maybe also in the `FONTS` directory, to be absolutely sure. But consider that not every HTTPD
supports such a file..

### Relative and absolute paths
Absolute paths work as usual, but relative paths are used here in two ways; so there's a difference
between `count` and `./count`.

The first one is a relative path from the current working directory of the running `php` process.

So, if you have `./php/count.php`, but call a symlink `./count.php`, the configured `DIR` needs to
be in e.g. `./count/`, **not** `./php/count/` (where the .php _file_ itself is).

But if you configure it like the second version `./count` (with `./` start), then the script will
resolve via `__DIR__` - so it's also a relative view, but from the directory the script is really
installed in. .. so if you again call `./count.php` (the symlink to `./php/count.php`), this time
the `count/` directory will be searched in the script's location, so `./php/count/`!

`../` is not affected by this. If you need a path above script's directory, use `./../`! :)~

## Drawing
Just finished the `<img>` drawing support. As follows..

### Usage
To use it, enable the `DRAWING` option and call script with (at least!) `?draw` GET parameter. The
available GET parameters are:

* `?draw`
* `?size=(int)` [18]
* `?space=(int)` [8]
* `?pad=(int)` [4]
* `?font=(string)` [SourceCodePro]
* `?fg=(string)` [rgba(0, 0, 0, 1)]
* `?bg=(string)` [rgba(255, 255, 255, 0)]
* `?x=(int)` [0]
* `?y=(int)` [0]
* `?aa=(1|0|y|n)` [true]
* `?type=(string)` [png]

`x` and `y` are just moving the text along this both axis (in px).
`fg` and `bg` can be `rgb()`, `rgba()` or just the 3 bytes and optionally a floating point number
between 0 and 1 for the alpha component.
`pad` is the space above and below the text, `space` is to the left and the right.
`size` is a font size in 'pt' or 'px' (ain't sure atm x)~, and the `font` needs to be installed in
the `FONTS` directory, as `.ttf`. The `aa` parameter needs to be `0`, `1`, `y` or `n` to configure
 anti-aliased text. Last but not least, the `?type` can atm be set to 'png' and 'jpg', whereas 'png'
is absolutely recommended! Example given: 'jpg' does not have the best alpha-channel (transparency)
support..

All parameters are optional, but the `?draw` needs to be set if you want a graphical output (only
if allowed by `DRAWING` configuration).

And just to mention it: take a look at `?zero` and maybe also the `HIDE` setting, described somewhere
above. They are changing the way the output image looks like.

#### Dependencies
Important: the GD library has to be installed for this feature. If it isn't, you can only use the
regular `text/plain` output function of this count.php! AND the GD library also needs "FreeType"
support, as we're drawing with True Type Fonts (this is **not** checked within `-c/--config`, btw.).

The `-c/--config` test will also check if this library is installed, but MAYBE it's installed, but not
available in the CLI mode, so there'll be a warning there, but nevertheless it's working fine with the
web server..

Runned by a web server with enabled `DRAWING` option and also aktived via `?draw` will only call this
drawing mode if module is installed. If not, the regular (text/plain) output will nevertheless be used;
to avoid error output (even though it's bad that you're using an `<img>` tag..... but error output
wouldn't be visible in this case at all).

The second dependency is a configured `FONTS` directory with '.ttf' fonts installed in it! ..

## CLI Mode
**You can test your configuration's validity by running the script from command line (CLI mode)!**
Just define the `--test/-t` (cmdline) parameter. ;)~

As it's not possible to do the default shebang `#!/usr/bin/env php`, you've to call the script
as argument to the `php` executable: `php count.php`. The shebang isn't possible, as web servers
running PHP scripts see them as begin of regular output! So: (a) it's shown in the browser.. and
(b) thus the script can't send any `header()` (necessary inter alia to define the content type,
as defined in `CONTENT` option)! .. so please, just type `php count.php` in your shell.

### The argument vector
Just run it without parameters to see all possible `argv[]` options. Here's the current list of
supported 'functions' (in CLI just call the script without arguments to see this list):

| Short | Long               | Description                                         |
| ----: | :----------------- | :-------------------------------------------------: |
|    `-?` | `--help`             | Mo' helping infoz, pls. (TODO)..                    |
|    `-V` | `--version`          | Print current script's version.                     |
|    `-C` | `--copyright`        | Shows the author of this script. /me ..             |
|    `-h` | `--hashes`           | Available algorithms for `HASH` config.             |
|    `-f` | `--fonts`            | Available fonts for drawing `<img>`.                |
|    `-t` | `--types`            | Available image types for drawing output.           |
|    `-c` | `--config`           | Verify if current configuration is valid.           |
|    `-v` | `--values [*]`       | All runtime status infos. w/ cache synchronization. |
|    `-n` | `--sync [*]`         | Synchronize the cache with real counts (only)       |
|    `-l` | `--clean [*]`        | Clean all **outdated** (only!) ip/timestamp files.. |
|    `-p` | `--purge [*]`        | Delete any host's ip cache directory (w/ caches)!   |
|    `-e` | `--errors`           | Count error log lines, if existing..                |
|    `-u` | `--unlog`            | Deletes the whole error log file, if already exists.|

The optional `[*]` needs to be defined directly after the parameter; can be multiple arguments by
appending them as new `$argc` (space divided). If not specified, the functions will read in all
available hosts.

### GLOB support
This is yet partially done, and will be continued to all the \[`-v`,`-n`,`-l`,`-p`\] (maybe more??).
At the moment it's already integrated in `--values/-v`. Worx so far..

As hint for myself there's the [glob.txt](./docs/glob.txt), JFMY.

After finishing this, I'll maybe start to implement `glob()` searches for IPs, to kinda manage them.
Idea is to look at the intersect, which hosts were visited by one/some IP(s). .. **anyone other ideas??**

## Original
The **[original version](php/original.php)** was a very tiny script as little helping hand for my web
projects. It rised a lot - see for yourself! :)~

