## -*- texinfo -*-
## @deftp {Class} logger.Logger
##
## Main entry point through which logging happens
##
## The Logger class provides method calls for performing logging, and the ability
## to look up loggers by name. This is the main entry point through which all
## SLF4O logging happens.
##
## Usually you don't need to interact with this class directly, but can just call
## one of the error(), warn(), info(), debug(), or trace() functions in the logger
## namespace. Those will log messages using the calling class's name as the name
## of the logger. Also, don't call the constructor for this class. Use the static
## getLogger() method instead.
##
## Use this class directly if you want to customize the names of the loggers to
## which logging is directed.
##
## Each of the logging methods - error(), warn(), info(), debug(), and
## trace() - takes a sprintf()-style signature, with a format string as
## the first argument, and substitution values as the remaining
## arguments.
## @example
##    logger.info(format, varargin)
## @end example
## You can also insert an MException object at the beginning of the
## argument list to have its message and stack trace included in the log
## message.
## @example
##    logger.warn(exception, format, varargin)
## @end example
##
## See also:
## logger.error
## logger.warn
## logger.info
## logger.debug
## logger.trace
##
## Examples:
##
## @example
## log = logger.Logger.getLogger('foo.bar.FooBar');
## log.info('Hello, world! Running on Octave %s', version);
## @end example
##
## @example
## try
##     some_operation_that_could_go_wrong();
## catch err
##     log.warn(err, 'Caught exception during processing')
## end
## @end example
##
## @end deftp

classdef Logger
    %LOGGER Main entry point through which logging happens
    
    properties (SetAccess = private)
        % The underlying SLF4J Logger object
        jLogger
    end
    
    properties (Dependent = true)
        % The name of this logger
        name
        % A list of the levels enabled on this logger
        enabledLevels
    end
    
    
    methods (Static)
        ## -*- texinfo -*-
        ## @node Logger.getLogger
        ## @deftypefn {Static Method} {@var{obj} =} logger.Logger.getLogger (@var{identifier})
        ##
        ## Gets the named Logger.
        ##
        ## Returns a logger.Logger object.
        ##
        ## @end deftypefn
        function out = getLogger(identifier)
        % Gets the named Logger
        jLogger = javaMethod('getLogger', 'org.slf4j.LoggerFactory', identifier);
        out = logger.Logger(jLogger);
        end
    end
    
    methods
        ## -*- texinfo -*-
        ## @node Logger.Logger
        ## @deftypefn {Constructor} {@var{obj} =} logger.Logger (@var{jLogger})
        ##
        ## Build a new logger object around an SLF4J Logger object.
        ##
        ## Generally, you shouldn't call this. Use logger.Logger.getLogger() instead.
        ##
        ## @end deftypefn
        function this = Logger(jLogger)
        %LOGGER Build a new logger object around an SLF4J Logger object.
        
        % We cannot actually do this check, because it seems that Octave's isa() function
        % does not respect inherited interface implementation in Java objects.
        % See https://github.com/apjanke/octave-slf4o/issues/9
        % TODO: Report this to the Octave bug tracker. We probably won't be able to
        % change this anyway, because we want to support Octave 4.4.x, and that one won't
        % get fixed.
        % mustBeA(jLogger, 'org.slf4j.Logger');

        this.jLogger = jLogger;
        end
        
        function disp(this)
        %DISP Custom object display.
            disp(dispstr(this));
        end
        
        function out = dispstr(this)
        %DISPSTR Custom object display string.
            if isscalar(this)
                strs = dispstrs(this);
                out = strs{1};
            else
                out = sprintf('%s %s', size2str(size(this)), class(this));
            end
        end
        
        function out = dispstrs(this)
        %DISPSTRS Custom object display strings.
            out = cell(size(this));
            for i = 1:numel(this)
                out{i} = sprintf('Logger: %s (%s)', this(i).name, ...
                    strjoin(this(i).enabledLevels, ', '));
            end
        end
        
        ## -*- texinfo -*-
        ## @node Logger.error
        ## @deftypefn {Method} error (@var{obj}, @var{msg}, @var{varargin})
        ## @deftypefnx {Method} error (@var{obj}, @var{exception}, @var{msg}, @var{varargin})
        ##
        ## Log a message at the ERROR level.
        ##
        ## @end deftypefn
        function error(this, msg, varargin)
        if ~this.jLogger.isErrorEnabled()
            return
        end
        msgStr = formatMessage(msg, varargin{:});
        this.jLogger.error(msgStr);
        end
        
        ## -*- texinfo -*-
        ## @node Logger.warn
        ## @deftypefn {Method} warn (@var{obj}, @var{msg}, @var{varargin})
        ## @deftypefnx {Method} warn (@var{obj}, @var{exception}, @var{msg}, @var{varargin})
        ##
        ## Log a message at the WARN level.
        ##
        ## @end deftypefn
        function warn(this, msg, varargin)
        if ~this.jLogger.isWarnEnabled()
            return
        end
        msgStr = formatMessage(msg, varargin{:});
        this.jLogger.warn(msgStr);
        end
        
        ## -*- texinfo -*-
        ## @node Logger.info
        ## @deftypefn {Method} info (@var{obj}, @var{msg}, @var{varargin})
        ## @deftypefnx {Method} info (@var{obj}, @var{exception}, @var{msg}, @var{varargin})
        ##
        ## Log a message at the INFO level.
        ##
        ## @end deftypefn
        function info(this, msg, varargin)
        % Log a message at the INFO level.
        if ~this.jLogger.isInfoEnabled()
            return
        end
        msgStr = formatMessage(msg, varargin{:});
        this.jLogger.info(msgStr);
        end
        
        ## -*- texinfo -*-
        ## @node Logger.debug
        ## @deftypefn {Method} debug (@var{obj}, @var{msg}, @var{varargin})
        ## @deftypefnx {Method} debug (@var{obj}, @var{exception}, @var{msg}, @var{varargin})
        ##
        ## Log a message at the DEBUG level.
        ##
        ## @end deftypefn
        function debug(this, msg, varargin)
        % Log a message at the DEBUG level.
        if ~this.jLogger.isDebugEnabled()
            return
        end
        msgStr = formatMessage(msg, varargin{:});
        this.jLogger.debug(msgStr);
        end
        
        ## -*- texinfo -*-
        ## @node Logger.trace
        ## @deftypefn {Method} trace (@var{obj}, @var{msg}, @var{varargin})
        ## @deftypefnx {Method} trace (@var{obj}, @var{exception}, @var{msg}, @var{varargin})
        ##
        ## Log a message at the TRACE level.
        ##
        ## @end deftypefn
        function trace(this, msg, varargin)
        % Log a message at the TRACE level.
        if ~this.jLogger.isTraceEnabled()
            return
        end
        msgStr = formatMessage(msg, varargin{:});
        this.jLogger.trace(msgStr);
        end
        
        ## -*- texinfo -*-
        ## @node Logger.errorj
        ## @deftypefn {Method} errorj (@var{obj}, @var{msg}, @var{varargin})
        ##
        ## Log a message at the ERROR level, using SLF4J formatting.
        ##
        ## @end deftypefn
        function errorj(this, msg, varargin)
        if ~this.jLogger.isErrorEnabled()
            return
        end
        this.jLogger.error(msg, varargin{:});
        end
        
        ## -*- texinfo -*-
        ## @node Logger.warnj
        ## @deftypefn {Method} warnj (@var{obj}, @var{msg}, @var{varargin})
        ##
        ## Log a message at the WARN level, using SLF4J formatting.
        ##
        ## @end deftypefn
        function warnj(this, msg, varargin)
        if ~this.jLogger.isWarnEnabled()
            return
        end
        this.jLogger.warn(msg, varargin{:});
        end
        
        ## -*- texinfo -*-
        ## @node Logger.infoj
        ## @deftypefn {Method} infoj (@var{obj}, @var{msg}, @var{varargin})
        ##
        ## Log a message at the INFO level, using SLF4J formatting.
        ##
        ## @end deftypefn
        function infoj(this, msg, varargin)
        if ~this.jLogger.isInfoEnabled()
            return
        end
        this.jLogger.info(msg, varargin{:});
        end
        
        ## -*- texinfo -*-
        ## @node Logger.debugj
        ## @deftypefn {Method} debugj (@var{obj}, @var{msg}, @var{varargin})
        ##
        ## Log a message at the DEBUG level, using SLF4J formatting.
        ##
        ## @end deftypefn
        function debugj(this, msg, varargin)
        if ~this.jLogger.isDebugEnabled()
            return
        end
        this.jLogger.debug(msg, varargin{:});
        end
        
        ## -*- texinfo -*-
        ## @node Logger.tracej
        ## @deftypefn {Method} tracej (@var{obj}, @var{msg}, @var{varargin})
        ##
        ## Log a message at the TRACE level, using SLF4J formatting.
        ##
        ## @end deftypefn
        function tracej(this, msg, varargin)
        % Log a message at the TRACE level, using SLFJ formatting.
        if ~this.jLogger.isTraceEnabled()
            return
        end
        this.jLogger.trace(msg, varargin{:});
        end
        
        ## -*- texinfo -*-
        ## @node Logger.isErrorEnabled
        ## @deftypefn {Method} {@var{out} =} isErrorEnabled (@var{obj})
        ##
        ## True if ERROR level logging is enabled for this logger.
        ##
        ## @end deftypefn
        function out = isErrorEnabled(this)
        out = this.jLogger.isErrorEnabled;
        end
        
        ## -*- texinfo -*-
        ## @node Logger.isWarnEnabled
        ## @deftypefn {Method} {@var{out} =} isWarnEnabled (@var{obj})
        ##
        ## True if WARN level logging is enabled for this logger.
        ##
        ## @end deftypefn
        function out = isWarnEnabled(this)
        out = this.jLogger.isWarnEnabled;
        end
        
        ## -*- texinfo -*-
        ## @node Logger.isInfoEnabled
        ## @deftypefn {Method} {@var{out} =} isInfoEnabled (@var{obj})
        ##
        ## True if INFO level logging is enabled for this logger.
        ##
        ## @end deftypefn
        function out = isInfoEnabled(this)
        out = this.jLogger.isInfoEnabled;
        end
        
        ## -*- texinfo -*-
        ## @node Logger.isDebugEnabled
        ## @deftypefn {Method} {@var{out} =} isDebugEnabled (@var{obj})
        ##
        ## True if DEBUG level logging is enabled for this logger.
        ##
        ## @end deftypefn
        function out = isDebugEnabled(this)
        out = this.jLogger.isDebugEnabled;
        end
        
        ## -*- texinfo -*-
        ## @node Logger.isTraceEnabled
        ## @deftypefn {Method} {@var{out} =} isTraceEnabled (@var{obj})
        ##
        ## True if TRACE level logging is enabled for this logger.
        ##
        ## @end deftypefn
        function out = isTraceEnabled(this)
        out = this.jLogger.isTraceEnabled;
        end
        
        ## -*- texinfo -*-
        ## @node Logger.listEnabledLevels
        ## @deftypefn {Method} {@var{out} =} listEnabledLevels (@var{obj})
        ##
        ## List the levels that are enabled for this logger.
        ##
        ## The enabled levels are listed by name.
        ##
        ## Returns a cellstr vector or empty.
        ##
        ## @end deftypefn
        function out = listEnabledLevels(this)
        out = {};
        if this.isErrorEnabled
            out{end+1} = 'error';
        end
        if this.isWarnEnabled
            out{end+1} = 'warn';
        end
        if this.isInfoEnabled
            out{end+1} = 'info';
        end
        if this.isDebugEnabled
            out{end+1} = 'debug';
        end
        if this.isTraceEnabled
            out{end+1} = 'trace';
        end
        end
        
        function out = get.enabledLevels(this)
        out = this.listEnabledLevels;
        end
        
        function out = get.name(this)
        out = char(this.jLogger.getName());
        end
    end
    
end

function out = formatMessage(format, varargin)
args = varargin;
exceptionStr = [];
if isa(format, 'MException')
    exception = format;
    if isempty(args)
        format = '';
    else
        format = args{1};
        args = args(2:end);
    end
    exceptionStr = getReport(exception, 'extended', 'hyperlinks','off');
    % Remove blank lines for more compact, readable (imho) logs
    exceptionStr = strrep(exceptionStr, sprintf('\n\n'), newline);
end
for i = 1:numel(args)
    if isobject(varargin{i})
        args{i} = dispstr(varargin{i});
    end
end
out = sprintf(format, args{:});
if ~isempty(exceptionStr)
    out = sprintf('%s\n%s', out, exceptionStr);
end
end
