## -*- texinfo -*-
##
## @deftyp {Class} logger.Log4jConfigurator
##
## A configurator tool for Log4j
##
## This class configures the logging setup for Octave/SLF4O logging. It
## configures the log4j library that SLF4O logging sits on top of.
##
## This class is provided as a convenience. You can also configure SLF4O logging
## by directly configuring log4j using its normal Java interface.
##
## SLF4O does not automatically configure log4j. You must either call a
## configureXxx method on this class or configure log4j directly yourself to get
## logging to work. Otherwise, you may get warnings like this at the console:
##
##   log4j:WARN No appenders could be found for logger (unknown).
##   log4j:WARN Please initialize the log4j system properly.
##
## If that happens, it means you need to call
## logger.Log4jConfigurator.configureBasicConsoleLogging.
##
## This also provides a log4j configuration GUI that you can launch with
## `logger.Log4jConfigurator.showGui`.
##
## Examples:
##
## @example
## logger.Log4jConfigurator.configureBasicConsoleLogging
##
## logger.Log4jConfigurator.setLevels(@{'root','DEBUG'@});
##
## logger.Log4jConfigurator.setLevels(@{
##     'root'    'INFO'
##     'net.apjanke.logger.swing'  'DEBUG'
##     @});
##
## logger.Log4jConfigurator.prettyPrintLogConfiguration
##
## % Display fully-qualified class/category names in the log output:
## logger.Log4jConfigurator.setRootAppenderPattern(...
##    ['%d@{HH:mm:ss.SSS@} %p %c - %m' sprintf('\n')]);
##
## % Bring up the configuration GUI
## logger.Log4jConfigurator.showGui
## @end example
##
## @end deftyp

classdef Log4jConfigurator
    
    methods (Static)

        ## -*- texinfo -*-
        ## @node logger.Log4jConfigurator.configureBasicConsoleLogging
        ## @deftypefn {Static Method} logger.Log4jConfigurator.configureBasicConsoleLogging ()
        ##
        ## Configures log4j to do basic logging to the console
        ##
        ## This sets up a basic log4j configuration, with log output going to the
        ## console, and the root logger set to the INFO level.
        ##
        ## This method can safely be called multiple times. If there's already an
        ## appender on the root logger (indicating logging has already been
        ## configured), it silently does nothing.
        ##
        ## @end deftypefn
        function configureBasicConsoleLogging
            rootLogger = javaMethod('getRootLogger', 'org.apache.log4j.Logger');
            rootAppenders = rootLogger.getAllAppenders();
            isConfiguredAlready = rootAppenders.hasMoreElements;
            if ~isConfiguredAlready
                javaMethod('configure', 'org.apache.log4j.BasicConfigurator');
                rootLogger = javaMethod('getRootLogger', 'org.apache.log4j.Logger');
                level_INFO = java_get('org.apache.log4j.Level', 'INFO');
                rootLogger.setLevel(level_INFO);
                rootAppender = rootLogger.getAllAppenders().nextElement();
                % Use \n instead of %n because the Matlab console wants Unix-style line
                % endings, even on Windows.
                pattern = ['%d{HH:mm:ss.SSS} %-5p %c{1} %x - %m' sprintf('\n')];
                myLayout = javaObject('org.apache.log4j.PatternLayout', pattern);
                rootAppender.setLayout(myLayout);
            end
            
        end
        
        ## -*- texinfo -*-
        ## @node logger.Log4jConfigurator.setRootAppenderPattern
        ## @deftypefn {Static Method} logger.Log4jConfigurator.setRootAppenderPattern (@var{pattern})
        ##
        ## Sets the pattern on the root appender
        ##
        ## This is just a convenience method. Assumes there is a single
        ## appender on the root logger.
        ##
        ## @end deftypefn
        function setRootAppenderPattern(pattern)
            rootLogger = javaMethod('getRootLogger', 'org.apache.log4j.Logger');
            rootAppender = rootLogger.getAllAppenders().nextElement();
            myLayout = org.apache.log4j.PatternLayout(pattern);
            rootAppender.setLayout(myLayout);
        end
        
        ## -*- texinfo -*-
        ## @node logger.Log4jConfigurator.getLog4jLevel
        ## @deftypefn {Static Method} logger.Log4jConfigurator.getLog4jLevel (@var{levelName})
        ##
        ## Gets the log4j Level Java enum value for a named level.
        ##
        ## @var{levelName} is a charvec containing the name of the log level, such as
        ## @code{'INFO'} or @code{'DEBUG'}. It may also be one of the special names
        ## @code{'OFF'} or @code{'ALL'}.
        ##
        ## Returns a Java org.apache.log4j.Level enum object.
        ##
        ## @end deftypefn
        function out = getLog4jLevel(levelName)
            validLevels = {'OFF' 'FATAL' 'ERROR' 'WARN' 'INFO' 'DEBUG' 'TRACE' 'ALL'};
            levelName = upper(levelName);
            if ~ismember(levelName, validLevels)
                error('Invalid levelName: ''%s''', levelName);
            end
            out = eval(['org.apache.log4j.Level.' levelName]);
        end
        
        ## -*- texinfo -*-
        ## @node logger.Log4jConfigurator.setLevels
        ## @deftypefn {Static Method} logger.Log4jConfigurator.setLevels (@var{levels})
        ##
        ## Set the logging levels for multiple loggers
        ##
        ## logger.Log4jConfigurator.setLevels(levels)
        ##
        ## This is a convenience method for setting the logging levels for multiple
        ## loggers.
        ##
        ## The levels input is an n-by-2 cellstr with logger names in column 1 and
        ## level names in column 2.
        ##
        ## Examples:
        ##
        ## @example
        ## logger.Log4jConfigurator.setLevels(@{'root','DEBUG'@});
        ##
        ## logger.Log4jConfigurator.setLevels(@{
        ##     'root'    'INFO'
        ##     'net.apjanke.logger.swing'  'DEBUG'
        ##     @});
        ## @end example
        ##
        ## @end deftypefn
        function setLevels(levels)
            for i = 1:size(levels, 1)
                [logName,levelName] = levels{i,:};
                logger = javaMethod('getLogger', 'org.apache.log4j.LogManager', logName);
                level = logger.Log4jConfigurator.getLog4jLevel(levelName);
                logger.setLevel(level);
            end
        end
        
        ## -*- texinfo -*-
        ## @node logger.Log4jConfigurator.prettyPrintLogConfiguration
        ## @deftypefn {Static Method} logger.Log4jConfigurator.prettyPrintLogConfiguration ()
        ## @deftypefnx {Static Method} logger.Log4jConfigurator.prettyPrintLogConfiguration (@var{verbose})
        ##
        ## Displays the current log configuration to the console.
        ##
        ## @var{verbose} is a logical flag indicating whether verbose mode should be used.
        ## Defaults to false.
        ##
        ## @end deftypefn
        function prettyPrintLogConfiguration(verbose)
            
            if nargin < 1 || isempty(verbose);  verbose = false;  end
            
            function out = getLevelName(lgr)
                level = lgr.getLevel();
                if isempty(level)
                    out = '';
                else
                    out = char(level.toString());
                end
            end
            
            % Get all names first so we can display in sorted order
            loggers = javaMethod('getCurrentLoggers', 'org.apache.log4j.LogManager');
            loggerNames = {};
            while loggers.hasMoreElements()
                logger = loggers.nextElement();
                loggerNames{end+1} = char(logger.getName()); %#ok<AGROW>
            end
            loggerNames = sort(loggerNames);
            
            % Display the hierarchy
            rootLogger = javaMethod('getRootLogger', 'org.apache.log4j.LogManager');
            fprintf('Root (%s): %s\n', char(rootLogger.getName()), getLevelName(rootLogger));
            for i = 1:numel(loggerNames)
                logger = javaMethod('getLogger', 'org.apache.log4j.LogManager', loggerNames{i});
                appenders = logger.getAllAppenders();
                appenderStrs = {};
                while appenders.hasMoreElements
                    appender = appenders.nextElement();
                    if isa(appender, 'org.apache.log4j.varia.NullAppender')
                        appenderStr = 'NullAppender';
                    else
                        appenderStr = sprintf('%s (%s)', char(appender.toString()), ...
                            char(appender.getName()));
                    end
                    appenderStrs{end+1} = ['appender: ' appenderStr]; %#ok<AGROW>
                end
                appenderList = strjoin(appenderStrs, ' ');
                if ~verbose
                    if isempty(logger.getLevel()) && isempty(appenderList) ...
                            && logger.getAdditivity()
                        continue
                    end
                end
                items = {};
                if ~isempty(getLevelName(logger))
                    items{end+1} = getLevelName(logger); %#ok<AGROW>
                end
                if ~isempty(appenderStr)
                    items{end+1} = appenderList; %#ok<AGROW>
                end
                if ~logger.getAdditivity()
                    items{end+1} = sprintf('additivity=%d', logger.getAdditivity()); %#ok<AGROW>
                end
                str = strjoin(items, ' ');
                fprintf('%s: %s\n',...
                    loggerNames{i}, str);
            end
        end
        
        ## -*- texinfo -*-
        ## @node logger.Log4jConfigurator.showGui
        ## @deftypefn {Static Method} logger.Log4jConfigurator.showGui ()
        ##
        ## Display the Log4j configuration GUI provided by SLF4O.
        ##
        ## BROKEN!!!
        ##
        ## This tool is currently broken, and will probably crash Octave if you call it.
        ##
        ## @end deftypefn
        function showGui()
            % Display the log4j configuration GUI
            
            % Octave doesn't seem to have javaObjectEDT(). Use regular javaObject() and hope
            % we don't have concurrency problems.
            %gui = javaObjectEDT('net.apjanke.log4j1gui.Log4jConfiguratorGui');
            gui = javaObject('net.apjanke.log4j1gui.Log4jConfiguratorGui');
            gui.initializeGui();
            frame = gui.showInFrame();
            frame.setVisible(true);
        end
    end
    
end