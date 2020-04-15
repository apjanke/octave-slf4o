## -*- texinfo -*-
## @deftypefn {Function} logger.trace (@var{msg}, @var{varargin})
## @deftypefnx {Function} logger.trace (@var{exception}, @var{msg}, @var{varargin})
##
## Log a TRACE level message from caller, with printf style formatting.
##
## This accepts a message with printf style formatting, using '%...' formatting
## controls as placeholders.
##
## Examples:
##
## @example
## logger.trace ('Some message. value1=%s value2=%d', 'foo', 42);
## @end example
##
## @end deftypefn

function trace (msg, varargin)

__SLF4O_loggerCallImpl__ ('trace', msg, varargin);

end