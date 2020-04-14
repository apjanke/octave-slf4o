## -*- texinfo -*-
## @deftypefn {Function} logger.initSLF4M
##
## Initialzie SLF4O
##
## This function must be called once before you use SLF4O.
##
## @end deftypefn

function initSLF4O

% This logic depends on the location of this file relative to the inst/
% dir in the pkg package.
thisFile = mfilename('fullpath');
instDir = fileparts(fileparts(thisFile));
libDir = fullfile(instDir, 'lib');

% Load our dispstr library

if ~isempty(which('dispstr'))
  % Assume caller got Dispstr loaded themselves
else
  % Load Dispstr
  matlabLibDir = fullfile(libDir, 'matlab');
  dispstrDir = fullfile(matlabLibDir, 'dispstr', 'dispstr-1.1.1');
  addpath(fullfile(dispstrDir, 'Mcode'));
end

% Get Java dependencies on the path
% TODO: Only add them if they are not already on the path, so this function
% is idempotent and silent.

javaLibDir = fullfile(libDir, 'java');
javaLibs = {
  'log4j1-config-gui/log4j1-config-gui-0.1.1.jar'
  'log4j-1.2.17.jar'
  'slf4j-api-1.7.30.jar'
  'slf4j-log4j12-1.7.30.jar'
  };
for i = 1:numel(javaLibs)
  jarFile = fullfile(javaLibDir, javaLibs{i});
  javaaddpath(jarFile);
end

logger.Log4jConfigurator.configureBasicConsoleLogging();

end
