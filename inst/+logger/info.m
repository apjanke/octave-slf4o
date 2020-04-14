## -*- texinfo -*-
## @deftypefn {Function} logger.info (@var{msg}, @var{varargin})
## @deftypefnx {Function} logger.info (@var{exception}, @var{msg}, @var{varargin})
##
## Log an INFO level message from caller, with printf style formatting.
##
## This accepts a message with printf style formatting, using '%...' formatting
## controls as placeholders.
##
## Examples:
##
## @example
## logger.info('Some message. value1=%s value2=%d', 'foo', 42);
## @end example
##
## @end deftypefn

function info(msg, varargin)

__SLF4O_loggerCallImpl__('info', msg, varargin);

end