## -*- texinfo -*-
## @deftypefn {Function} logger.warn (@var{msg}, @var{varargin})
## @deftypefnx {Function} logger.warn (@var{exception}, @var{msg}, @var{varargin})
##
## Log a WARN level message from caller, with printf style formatting.
##
## This accepts a message with printf style formatting, using '%...' formatting
## controls as placeholders.
##
## Examples:
##
## @example
## logger.warn('Some message. value1=%s value2=%d', 'foo', 42);
## @end example
##
## @end deftypefn

function warn(msg, varargin)

__SLF4O_loggerCallImpl__('warn', msg, varargin);

end