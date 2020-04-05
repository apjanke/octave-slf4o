function info(msg, varargin)
% Log an INFO level message from caller, with printf style formatting.
%
% logger.info(msg, varargin)
% logger.info(exception, msg, varargin)
%
% This accepts a message with printf style formatting, using '%...' formatting
% controls as placeholders.
%
% Examples:
%
% logger.info('Some message. value1=%s value2=%d', 'foo', 42);

__SLF4O_loggerCallImpl__('info', msg, varargin);

end