# SLF4O

SLF4O is a simple but flexible logging framework for GNU Octave, built on top of [SLF4J](https://www.slf4j.org/) and [Apache Log4j](https://logging.apache.org/log4j/2.0/). You can use it to do runtime-configurable logging from your Octave scripts and programs. This can be more informative and more manageable than commenting in and out `fprintf()` statements.

SLF4O provides:

* Logging functions (an Octave layer of bindings for SLF4J)
* A "Dispstr" API for customizing object display.
* A Log4j configuration GUI

The API is simple enough that you can get up and running with it quickly, or even use it casually in scripts, but it’s flexible and powerful enough to be useful for larger systems.

(The `dispstr` part is mostly optional; you don't have to learn it in order to use SLF4O logging.)

SLF4O is an Octave port of the [SLF4M](https://github.com/apjanke/SLF4M) package for Matlab.

## Usage

### Installation

You can install SLF4O using Octave's `pkg` command:

```octave
pkg install https://github.com/apjanke/octave-slf4o/archive/master.zip
```

### Use

In your Octave program:

* Call `logger.initSLF4O()` to initialize SLF4O. This needs to be done before any logging calls are made.

The logging functions are in the `+logger` package. Call them from within your Octave
code. In order of logging level, they are:

* logger.error()
* logger.warn()
* logger.info()
* logger.debug()
* logger.trace()

The logging functions take sprintf()-style formatting arguments. You can also pass
an `MException` as the first argument to include the error message and stack
trace in the log message.

```octave
function helloWorld(x)

if nargin < 1 || isempty(x)
    x = 123.456;
    % These debug() calls will only show up if you set log level to DEBUG
    logger.debug('Got empty x input; defaulted to %f', x);
end
z = x + 42;

logger.info('Answer z=%f', z);
if z > intmax('int32')
    logger.warn('Large value z=%f will overflow int32', z);
end

try
    some_bad_operation(x);
catch err
    logger.error(err, 'Something went wrong in some_bad_operation(x=%f)', x);
end

end
```

The output looks like this:

```text
>> helloWorld
16:53:18.279 INFO helloWorld() - Answer z=165.456000
16:53:18.291 ERROR helloWorld() - Something went wrong in some_bad_operation(123.456000)
Undefined function 'some_bad_operation' for input arguments of type 'double'.
Error in helloWorld (line 16)
    some_bad_operation(x);
```

Thanks to `dispstr()`, you can also pass Octave objects to the `%s` conversions.

```text
>> m = containers.Map;
>> m('foo') = 42; m('bar') = struct;
>> logger.info('Hello, world! %s', m)
09:52:29.809 INFO  base - Hello, world! 2-by-1 containers.Map
```

To launch the configuration GUI, run `logger.Log4jConfigurator.showGui`. This GUI lets you set the logging levels and other attributes of the various loggers in your Octave session.

For more details, see the [User's Guide](doc/UserGuide.md).

## Requirements

Octave 4.4.1 or newer, built with Java enabled.

## Implementation

SLF4O is a thin layer built on top of SLF4J and Log4j. It is compatible with any other Java or Octave code that uses SLF4J or Log4j.

Log4j was chosen as the back-end because that’s what ships with Matlab, and SLF4O attempts to be maximally compatible with SLF4M.

## License

SLF4O is licensed under the GNU General Public License, like GNU Octave itself.

## Author

SLF4O is developed by [Andrew Janke](https://apjanke.net). Its home page is [the repo on GitHub](https://github.com/apjanke/SLF4O).
