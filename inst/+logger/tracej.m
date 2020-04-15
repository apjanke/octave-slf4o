## -*- texinfo -*-
## @deftypefn {Function} logger.tracej (@var{msg}, @var{varargin})
##
## Log a TRACE level message from caller, with SLF4J style formatting.
##
## This accepts a message with SLF4J style formatting, using '@{@}' as placeholders for
## values to be interpolated into the message.
##
## Examples:
##
## @example
## logger.tracej ('Some message. value1=@{@} value2=@{@}', 'foo', 42);
## @end example
##
## @end deftypefn

function tracej (msg, varargin)

__SLF4O_loggerCallImpl__ ('trace', msg, varargin, 'j');

end