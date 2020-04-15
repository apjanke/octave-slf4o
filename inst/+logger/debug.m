## -*- texinfo -*-
## @deftypefn {Function} logger.debug (@var{msg}, @var{varargin})
## @deftypefnx {Function} logger.debug (@var{exception}, @var{msg}, @var{varargin})
##
## Log a DEBUG level message from caller, with printf style formatting.
##
## This accepts a message with printf style formatting, using '%...' formatting
## controls as placeholders.
##
## Examples:
##
## @example
## logger.debug ('Some message. value1=%s value2=%d', 'foo', 42);
## @end example
##
## @end deftypefn

function debug (msg, varargin)

__SLF4O_loggerCallImpl__ ('debug', msg, varargin);

end