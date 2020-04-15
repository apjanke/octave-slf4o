## -*- texinfo -*-
## @deftypefn {Function} logger.errorj (@var{msg}, @var{varargin})
##
## Log an ERROR level message from caller, with SLF4J style formatting.
##
## This accepts a message with SLF4J style formatting, using '@{@}' as placeholders for
## values to be interpolated into the message.
##
## Examples:
##
## @example
## logger.errorj('Some message. value1=@{@} value2=@{@}', 'foo', 42);
## @end example
##
## @end deftypefn

function errorj (msg, varargin)

__SLF4O_loggerCallImpl__ ('error', msg, varargin, 'j');

end