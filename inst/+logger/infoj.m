## -*- texinfo -*-
## @deftypefn {Function} logger.infoj (@var{msg}, @var{varargin})
##
## Log an INFO level message from caller, with SLF4J style formatting.
##
## This accepts a message with SLF4J style formatting, using '@{@}' as placeholders for
## values to be interpolated into the message.
##
## Examples:
##
## @example
## logger.infoj ('Some message. value1=@{@} value2=@{@}', 'foo', 42);
## @end example
##
## @end deftypefn

function infoj (msg, varargin)

__SLF4O_loggerCallImpl__ ('info', msg, varargin, 'j');

end