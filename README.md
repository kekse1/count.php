<img src="https://kekse.biz/php/count.php?draw&override=github:count.php&fg=120,130,40&size=48&v=16" />

# [count.php](https://github.com/kekse1/count.php/)
It's a universal counter script. ... v**3.2.0**!

## Index
1. [Installation](#installation)
	* [Dependencies](#dependencies)
2. [Details](#details)
	* [Storage](#storage)
	* [Server and/or Client](#server-andor-client)
	* [Refresh](#refresh)
	* [Override](#override)
	* [Overwrites](#overwrites)
	* [Cleaning](#cleaning)
	* [Privacy](#privacy)
	* [Errors](#errors)
	* [String filter](#string-filter)
3. [Drawing](#drawing)
	* [Parameters](#parameters)
	* [Dependencies](#dependencies-1)
4. [Configuration](#configuration)
	* [No more constants.](#no-more-constants)
	* [Relative Paths](#relative-paths)
	* [Colors](#colors)
	* [Radix/Base](#radixbase)
	* [`AUTO`](#auto)
	* [Per-host config overwrite](#per-host-config-overwrite-1)
6. [Modes](#modes)
	* [Readonly mode](#readonly-mode)
	* [Drawing mode](#drawing-mode)
	* [Zero mode](#zero-mode)
	* [Hide mode](#hide-mode)
	* [Test mode](#test-mode)
	* [RAW mode](#raw-mode)
	* [CLI mode](#cli-mode)
6. [FAQ](#faq)
7. [The original version](#the-original-version)
8. [Copyright and License](#copyright-and-license)

## Installation
The easiest way is to just use this `count.php` with it's default configuration: copy it to some path
in your web root, create a `count/` directory in the same path (with `chmod 1777` maybe - or just make sure that your web server can
access the file system). **That's all!** :)~

The possible, possibly complex rest is described in the [Configuration section](#configuration).

As an important example, hence here's another file system change necessary: if you want to enable the `DRAWING` routines. Then the
HTTPD needs access to a sub directory `fonts/`, with at least one installed `.ttf`(!) font in it (which you need to set as the _default
font_ in the `FONT` setting).

BTW: You can just use the [`fonts/`](fonts/) shipped with(in) this repository. I've setup `Intel One Mono` (or `IntelOne Mono`)
as the default font, btw.. looks great - see the random value on top of this `README.md` (it's random due to `HIDE = true` config).

Now, **that's** all. :D~

_And if you want to edit the default configuration_, see the [Configuration section](#configuration). And to make sure your settings are valid,
you can call this script like this: `php count.php --check/-c`), which will check your own configuration, if it's correct (mostly in it's type).

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

If `THRESHOLD <= 0` or `THRESHOLD === null`, both `SERVER` and `CLIENT` will be overridden (to
`false`); as this seems you don't need a `THRESHOLD` time.

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
`OVERRIDDEN = true`.

*PS: untested atm.*.. AND **JFYI**: If `gettype(OVERRIDE) === 'string'`, then the 'AUTO' is also being
overridden as above, but to the `(true)` state (so the value file will always be created automatically).

### Overwrites
Beneath the default configuration, any host (within the file system, as desribed above at [Storage](#storage))
can have it's own configuration (difference) file, to apply these only to these hosts itself. This is really
_optional_, but could maybe be very useful sometimes.

It came up since in earlier versions I defined the whole configuration via `define()`, which ends up in
globally defined 'variables' (not in the namespace I'm using). BAD.. now everything works even better than
before this way (and nearly **no** `define()` are used now).

For more infos, see the [Per-host config overwrite](#per-host-config-overwrite) sub section (of the
[Configuration](#configuration) section. :-)

### Cleaning
If configured, out-dated ip/timestamp files will be deleted (this and more is also possible in
the CLI (cmd-line) mode), if their timestamps are 'out-dated' (so if they have been written more
than `THRESHOLD` (by default 2 hours) seconds before).

If you define an `(integer)`, the cache will be cleared only if there are more files existing
than the (integer). And if you set it to `(null)`, every cleaning is **forbidden**, if you
want to collect all the IPs or so.. `(false)` would also never call the clean routine, except if
the `LIMIT` is exceeded..!

### Privacy
And if privacy is one of your concerns, the IPs (in their own files with their timestamps) can
also be hashed, so noone can see them (including yourself, or the webmaster(s), .. even with
access to the file system).

Just enable the `PRIVACY` setting.

### Errors

#### Log file
Most errors will be appended to the `count.log` file (configurable via `LOG`), so webmasters etc. can
directly see what's maybe going wrong. _Due to security_, not everything is being logged. Especially
where one could define own `$_GET[*]` or so, which could end up in flooding the log file!

The file is configured via the `LOG` setting (and follows the rule(s) shown in [Relative paths](#relative-paths)), and also encodes timestamps, in the first column (in seconds, unix epoch (January 1st, 1970)).

#### Details
In `RAW` mode, errors won't be logged to file and they won't `die()`, but `throw new Exception(..)`.

But normally you won't use this mode. So normally errors are stopping the execution via `die()` (but
it's an abstracted function to manage exceptions better). So if an error would be shown to the user
who called this script, it's either the `ERROR` string, if set: just looks better and safes space on
the web site, and the user mostly won't need to see the detailed error message.. by default they'll
just see `/` (kinda variant of the numeric value).

Otherwise, without `ERROR` setting, they'll see the error message itself (in shortened form, so clients
won't see file paths). .. When sending an error, the defined `CONTENT` header will be sent; also on drawing
errors.. so the image will break.

BTW @ developers: I'm using two functions for this. Please use them, **never** a regular `die()` nor a
`throw new Exception(..)`. These functions handle it better: `error()`/`log_error()`. Please _log_ errors
only in safe situations, so no client is able to flood the log file..!

### String filter
_All `$_SERVER` and `$_GET` are filtered to reach security_ (please don't ever trust any [user] input!).

I just abstracted both functions `secure_{host,path}()` to only one function, which is partially also
used by the `get_param()`.. both functions stayed: they internally use `secure()`, but the `secure_host()`
additionally does a `strtolower()`.

So here you gotta know which characters you can pass, while the maximum length is 224 characters (by default;
look at the `MAX` constant), btw.

* `a-z`
* `A-Z`
* `0-9`
* `#`
* `,`
* `:`
* `(`
* `)`
* `/` (limited)
* `.` (limited)
* `-` (limited)
* `+` (limited)

That's also important for the *optional* `?override=` GET parameter (see above), e.g., as hosts (etc.)
also won't ever be accepted 'as is'.

So I'm also securing the used `$_SERVER` variables, as e.g. via `Hostname: ...` in the HTTP header the
host could be poisoned as well!

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
To use it, enable the `DRAWING` option and call script with (at least!) `?draw` \[or `?zero`\] (GET)
parameter. More isn't necessary, but there also also some GET parameters to adapt the drawing; as
follows (whereas they need a prefix, which is either `?` for the first parameter, and `&` for any following):

| Variable | Default [Settings](#settings) \[= (value)\]     | Type         | Description / Comment(s) |
| -------: | :---------------------------------------------- | -----------: | -----------------------: |
| `draw`   | (`DRAWING` needs to be enabled!) = `false`      | **No value** | By default _no_ \<img\>  |
| `zero`   | (`DRAWING` again) (overrides the options below) | **No value** | _Alternative_ to `?draw` |
| `size`   | `SIZE` = `24`                                   | **Integer**  | Also see `SIZE_LIMIT`    |
| `font`   | `FONT` = `'IntelOneMono'`                       | **String**   | Also see `FONTS`         |
| `fg`     | `FG` = `'0,0,0,1'`                              | **String**   | See [Colors](#colors)    |
| `bg`     | `BG` = `'255,255,255,0'`                        | **String**   | See [Colors](#colors)    |
| `h`      | `H` = `0`                                       | **Integer**  | Also see `H_LIMIT`       |
| `v`      | `V` = `0`                                       | **Integer**  | Also see `V_LIMIT`       |
| `x`      | `X` = `0`                                       | **Integer**  | >= -512 and <= 512       |
| `y`      | `Y` = `0`                                       | **Integer**  | >= -512 and <= 512       |
| `aa`     | `AA` = `true`                                   | **Boolean**  | Anti Aliasing..          |
| `type`   | `TYPE` = `'png'`                                | **String**   | See `--types/-t`         |

`fg` and `bg` are colors, see the [Colors](#colors) sub section of the [Configuration](#configuration) section.

`x` and `y` are just moving the text along these both axis (in px).
`v` is the space above and below the text, `h` is to the left and the right. They both can also be negative
values.

`size` is a font size (in `pt` or `px`? ..not sure atm). And the selected `font` needs to be installed in
the `FONTS` directory, as `.ttf`. The parameter is normally without '.ttf' extension, but CAN be so, too..

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
The configuration is an associative array of various settings.

Look below at "CLI Mode" to get to know how to verify your own configuration, via `-c/--check [*]`. It's
able to read _optional_ arguments, to also verify concrete [per-host config overwrite](#per-host-config-overwrite).

The [per-host config overwrite](#per-host-config-overwrite)s do allow a subset/difference of the whole configuration
items to be applied, if such host is selected. They reside in the regular `PATH` directory, prefixed by a single `%`
(hash sign), and are encoded in [JSON format](https://www.json.org/). And they'll be loaded automatically if existing,
if such a host is being selected.

### No more constants.
Here are the current _default_ settings, including the possible types (whereas every variable with bold `!` before may
_**never** be overwritten by any '[per-host config overwrite](#per-host-config-overwrite)').

This `DEFAULTS` are stored in the script file itself, in a `const` array.

| Name            | Default value                | Possible types/values                        | Description / Comment(s)                          |
| --------------: | :--------------------------- | -------------------------------------------: | :-----------------------------------------------: |
| **!**`PATH`     | `'count/'`                   | **String** (non-empty)                       | See [Relative paths](#relative-paths) below       |
| `LOG`           | `'count.log'`                | **String** (non-empty)                       | File to log errors to (also see link above)       |
| `THRESHOLD`     | `7200`                       | **Integer** (>= 0) or **Null**               | How long does it take till counting again?        |
| **!**`AUTO`     | `32`                         | **Boolean**, **Integer** (>0) or **null**    | Create count value files automatically?           |
| `HIDE`          | `false`                      | **Boolean** or **String**                    | Show the counted value or hide it?                |
| `CLIENT`        | `true`                       | **Boolean** or **null**                      | Enables Cookies against re-counting               |
| `SERVER`        | `true`                       | **Boolean**                                  | Enables cache/ip/timestamp files, like above      |
| `DRAWING`       | `false`                      | **Boolean**                                  | Essential if using `?draw` or `?zero`!            |
| **!**`OVERRIDE` | `false`                      | **Boolean** or **String** (non-empty)        | Instead of using `$_SERVER[*]` `$_GET`/String     |
| `CONTENT`       | `'text/plain;charset=UTF-8'` | **String** (non-empty)                       | Non-graphical mode produces only value output     |
| `RADIX`         | `10`                         | **Integer**                                  | See [Radix](#radix) below .. change the output(s) |
| `CLEAN`         | `true`                       | **null**, **Boolean** or **Integer** (>0)    | Clean outdated cache files and the FS things?     |
| `LIMIT`         | `32768`                      | **Integer** (>=0)                            | Maximum number of cache files                     |
| `FONTS`         | `'fonts/'`                   | **String** (non-empty)                       | Directory with installed '.ttf' fonts @ path      |
| `FONT`          | `'IntelOneMono'`             | **String** (non-empty) \[see `--fonts/-f`\]  | Default font to use                               |
| `SIZE`          | `24`                         | **Integer** (>=4, and w/in SIZE_LIMIT)       | Font size (`px` or `pt`, not sure atm)            |
| `SIZE_LIMIT`    | `768`                        | **Integer** (>=4 and <=512)                  | Limit for this size (@ traffic and resources)     |
| `FG`            | `'rgb(0, 0, 0)'`             | **String** (non-empty)                       | See [Colors](#colors) below                       |
| `BG`            | `'rgba(255, 255, 255, 0)'`   | **String** (non-empty)                       | See [Colors](#colors) below                       |
| `X`             | `0`                          | **Integer** (<=512 and >=-512)               | Movement of drawed text left/right                |
| `Y`             | `0`                          | **Integer** (<=512 and >=-512)               | Same as above, but for up/down                    |
| `H`             | `0`                          | **Integer** (<=`H_LIMIT` and >=`(-)H_LIMIT`) | Horizontal space from text to end of image        |
| `V`             | `0`                          | **Integer** (<=`V_LIMIT` and >=`(-)V_LIMIT`) | Vertical space, like above                        |
| `H_LIMIT`       | `256`                        | **Integer** (>= 0 and <= 512)                | Limited due to performance and traffic usage      |
| `V_LIMIT`       | `256`                        | **Integer** (>= 0 and <= 512)                | Same as above, but vertical, not horizontal       |
| `AA`            | `true`                       | **Boolean**                                  | Anti Aliasing looks better, but it's optional     |
| `TYPE`          | `'png'`                      | **String** (non-empty) \[see `--types/-t`\]  | Only `png` and `jpg` supported 'atm' (are best!)  |
| `PRIVACY`       | `false`                      | **Boolean**                                  | Hashes the IPs (stored if `SERVER` is enabled)    |
| **!**`HASH`     | `'sha3-256'`                 | **String** (non-empty) \[see `--hashes/-h`\] | This is the hash algorithm. Used for Cookies, too |
| `ERROR`         | `'*'`                        | **null** or **String**                       | If not (null), it will be shown on **any** error  |
| `NONE`          | `'/'`                        | **String**                                   | And this is shown when `!AUTO` w/o value file..   |
| **!**`RAW`      | `false`                      | **Boolean**                                  | See the [RAW mode](#raw-mode) section. _Untested_ |

It'd be better to create a `.htaccess` file with at least `Deny from all` in your `PATH` directory. But consider that not every HTTPD (web server)
supports such a file (e.g. `lighttpd`..)!

### Relative paths
Absolute paths work as usual. But relative paths are used here in two ways.

If you define your `PATH`, `LOG` or `FONTS` as simple directory name like `count` or `count/`, it'll
be resolved from the location of your `count.php` script (using `__DIR__`). But to define this relative
to your current working directory, you've to define those paths with starting `./` (it's where the script
gets called; maybe as symbolic link or by defining a path via e.g. `php ./php/count.php`).

But `../` is relative to the `__DIR__` - if you also want to make this relative to the current working
directory, please use `./../`..

### Colors
Supported formats are:

* `argb()` (with 3x (0-255) and 1x (0.0-1.0));
* `rgb()` (with 3x (0-255));
* `(comma separated list) (of 3x (0-255) and optionally 1x (0.0-1.0));
* `#` hex color strings (w/ and w/o `#` prefix, within a length of [ 3, 4, 6, 8 ]);

### Radix/Base
The `RADIX` configuration should be an **Integer** between **2** and **36**. Default is, of course, **10**! :)~

But it's worth to mention that this parameter can also be changed in the `$_GET`-URL with which this script _can_ (optionally) be called.
Just use the `?radix=10` (here with it's default value, if not defined otherwise in the `RADIX` setting mentioned here above).

### 'AUTO'
By default up to `32` value files will automatically be created, if not existing for a host. With overridden
host this setting is also overwritten: `true` if `OVERRIDE` setting or `$_host` is a String, and `false` in
all other cases.

If amount of value files exceeds limit, or if set to `false`, you can easily initialize (or change..) these
files via the `--set/-t (host) [value=0]` parameter in [CLI mode](#cli-mode), with _optional_ value (integer).
If unspecified, the value defaults to (`0`).

### Per-host config overwrite
The per-host configuration allows a _sub-set_ of settings (look at the `CONFIG_STATIC` const array) to 'overwrite'
the default configuration (see `DEFAULTS`). And they're just 'shifted', which makes it very efficient, and even very
easy to unloaded again. So, they are **differences** to apply if this host with the `%` file is selected.

They get automatically loaded (if the file exists - usually a `%`-prefixed JSON object{} in the `PATH` directory,
beneath the other host files/directories).

Hosts with their own configuration overwrites are marked with an integer on the right of the `--values/-v` table in
[CLI](#cli-mode), which indicates how many settings are being overwritten by this file, per host (checked before).
If it's not prefixed by a `%` and instead of the value there's an `@`, the config file couldn't be read in or parsed
to an (associative) array.. in this case please check the file for this host!

JFYI: maybe in `RAW` mode you eventually will use some functions etc. multiple times (before exit). If you would call
the `make_config()` function (or within multiple `counter()` calls it's also used), and set the `$_reload = null` (instead
of a `Boolean` type), the per-host config file will only be reloaded if the file hash changed (they're stored when loaded)..

So, **BTW**: the configuration files are encoded in the [JSON format](https://json.org/) (and don't need to hold the whole
set of configuration items..)! :)~

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
your `PATH` directory!

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

Last but not least: regular `die()` are replaced by `throw new Exception(..)`.

### CLI mode
**You can test your configuration's validity by running the script from command line (CLI mode)!**
Just define the `--check/-c [*]` (cmdline) parameter. ;)~

As it's not possible to do the default shebang `#!/usr/bin/env php`, you've to call the script
as argument to the `php` executable: `php count.php`. The shebang isn't possible, as web servers
running PHP scripts see them as begin of regular output! So: (a) it's shown in the browser.. and
(b) thus the script can't send any `header()` (necessary inter alia to define the content type,
as defined in `CONTENT` option)! .. so please, just type `php count.php` in your shell.

**BTW**: With enabled `RAW` setting this command line interface won't be shown (because this mode is
for using the script within other PHP scripts) - unless you define one of the parameters shown below!

_**NEW** since v**3.0.3**:_ the default action has changed - from showing the syntax to directly call
like `--values/-v`. The syntax is now shown via `--help/-?`. :)~

##### The argument vector
Just run the script without parameters to see all possible `argv[]` options. Here's the current list
of supported 'functions'.

| Short | Long                     | Description                                               |
| ------: | :--------------------- | :-------------------------------------------------------: |
|  `-?` | `--help`                 | Shows the link to this website..                          |
|  `-V` | `--version`              | Print current script's version.                           |
|  `-C` | `--copyright`            | Shows the author of this script. /me ..                   |
|  `-c` | `--check [*]`            | Verify DEFAULT or, by arguments, per-user configurations  |
|  `-v` | `--values [*]`           | Shows all vales and more.                                 |
|  `-s` | `--sync [*]`             | Same as above, but with cache synchronization..           |
|  `-l` | `--clean [*]`            | Clean all **outdated** (only!) cache files.               |
|  `-p` | `--purge [*]`            | Delete the cache(s) for all or specified hosts.           |
|  `-z` | `--sanitize [-w]`        | Delete file rests.. with `--allow-without-values/-w`..    |
|  `-d` | `--delete [*]`           | Totally remove any host (all, or by arguments)            |
|  `-t` | `--set (host) [value=0]` | Sets the (optional) value for the defined host (only one) |
|  `-f` | `--fonts [*]`            | Available fonts for drawing `<img>`. Globs allowed.       |
|  `-y` | `--types`                | Available image types for drawing output.                 |
|  `-h` | `--hashes`               | Available algorithms for `HASH` config.                   |
|  `-e` | `--errors`               | Counts the error log lines.                               |
|  `-u` | `--unlog`                | Deletes the whole error log file.                         |

Additional arguments within '[]' are optional (and mostly support GLOBs), and those within '()' are
_required_ ones. Most `*` arguments can be defined multiple times, so most times as multiple globs,
to match the hosts (separated by spaces, each as another argv/argc).

**Hint:** using globs requires quoting or escaping most times, as most shells will try to directly
resolve them.. if it works sometimes, it's just because the shell didn't find any match (then the
original glob is being encoded 'as is').

As hint for myself there's the [glob.txt](./docs/glob.txt), JF{M,Y}I..

**NEW** (since v**3.1.3**): the `--check/-c [*]` can get *optional* `host` arguments, to not check the
default/global configuration, but the overrided ones (by a [per-host config overwrite](#per-host-config-overwrite)).

#### Prompts
As some operations are somewhat 'dangerous', especially at deletion of files, there'll be a prompt
to ask you for `yes` or `no` (sometimes/partially). So please confirm this questions, if shown; and
just answer with `y[es]` or `n[o]`, otherwise the `prompt()` will repeat it's question.

## FAQ
This section grew as I got comments on my code. And I hope for your reviews, really! Please contact me,
if you would like to review my code. I don't bite, promised! xD~

### # Why not using a `class`?
Just because it ain't necessary. I've just set a `namespace kekse\counter`, so everything is no longer
in the global namespace.. that should be enough. It could even really be, that using classes would even
end up in more resource consumption.. so, I think it's O.K. as it is now.. 'old skewl'! :)~

bedenke.. why should I just create a `Counter` class instance, where no real member variables are given
(as all are stored on the disk), and to only call a function `count()`, just to let her directly return
a value (and/or print/draw it), and then, directly after this, the instance would get destroyed again!?
... just my two cents. :)~

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

**NEWS**: after cleaning up a bit, removing comments, etc. there are _only_ **_5174_ code lines** left
as of v**3.2.0**! ^\_^

## The original version
**[The original version](php/original.php)** was a very tiny script as little helping hand for my web
projects. It rised a lot - see for yourself! :)~

## Copyright and License
The Copyright is [(c) Sebastian Kucharczyk](./COPYRIGHT.txt),
and it's licensed under the [MIT](./LICENSE.txt) (also known as 'X' or 'X11' license).
