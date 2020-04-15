## -*- texinfo -*-
## @deftypefn {Function} logger.error (@var{msg}, @var{varargin})
## @deftypefnx {Function} logger.error (@var{exception}, @var{msg}, @var{varargin})
##
## Log an ERROR level message from caller, with printf style formatting.
##
## This accepts a message with printf style formatting, using '%...' formatting
## controls as placeholders.
##
## Examples:
##
## @example
## logger.error ('Some message. value1=%s value2=%d', 'foo', 42);
## @end example
##
## @end deftypefn

function error (msg, varargin)

__SLF4O_loggerCallImpl__ ('error', msg, varargin);

end