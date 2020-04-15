## -*- texinfo -*-
## @deftypefn {Function} logger.debugj (@var{msg}, @var{varargin})
##
## Log a DEBUG level message from caller, with SLF4J style formatting.
##
## This accepts a message with SLF4J style formatting, using '@{@}' as placeholders for
## values to be interpolated into the message.
##
## Examples:
##
## @example
## logger.debugj ('Some message. value1=@{@} value2=@{@}', 'foo', 42);
## @end example
##
## @end deftypefn

function debugj (msg, varargin)

__SLF4O_loggerCallImpl__ ('debug', msg, varargin, 'j');

end