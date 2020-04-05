function warn(msg, varargin)
% Log a WARN level message from caller, with printf style formatting.
%
% logger.warn(msg, varargin)
% logger.warn(exception, msg, varargin)
%
% This accepts a message with printf style formatting, using '%...' formatting
% controls as placeholders.
%
% Examples:
%
% logger.warn('Some message. value1=%s value2=%d', 'foo', 42);

__SLF4O_loggerCallImpl__('warn', msg, varargin);

end