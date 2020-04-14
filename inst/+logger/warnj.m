## -*- texinfo -*-
## @deftypefn {Function} logger.warnj (@var{msg}, @var{varargin})
##
## Log a WARN level message from caller, with SLF4J style formatting.
##
## This accepts a message with SLF4J style formatting, using '@{@}' as placeholders for
## values to be interpolated into the message.
##
## Examples:
##
## @example
## logger.warnj('Some message. value1=@{@} value2=@{@}', 'foo', 42);
## @end example
##
## @end deftypefn

function warnj(msg, varargin)

__SLF4O_loggerCallImpl__('warn', msg, varargin, 'j');

end