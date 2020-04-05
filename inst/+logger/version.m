function out = version
% VERSION Get version info for SLF4O
%
% logger.version
% v = logger.version
%
% Gets version info for the SLF4O library.
%
% If return value is not captured, displays version info for SLF4O and related
% libraries to the console.
%
% If return value is captured, returns the version of the SLF4O library as
% a char vector.

slf4mVersion = getSlf4mVersion;

if nargout > 0
    out = slf4mVersion;
    return
else
    versions.SLF4O = slf4mVersion;
    versions.SLF4J = '?';
    versions.log4j = '?';
    % For now, parse the versions from the JAR filenames, since we're shipping
    % our own JARs and know that they're properly version-labelled. Would be nice
    % if we could extract it from the JAR contents instead.
    instDir = fileparts(fileparts(mfilename('fullpath')));
    javaLibDir = fullfile(instDir, 'lib', 'java');
    d = dir([javaLibDir '/*.jar']);
    jars = javaclasspath;
    map = {
        'SLF4J' 'slf4j-api'
        'log4j' 'log4j'
        };
    for i = 1:numel(jars)
        jarFile = jars{i};
        [~,jarBase,~] = fileparts(jarFile);
        for iLib = 1:size(map, 1)
            [libName, fileStart] = map{iLib,:};
            if strncmp(jarBase, fileStart, numel(fileStart))
                versions.(libName) = jarBase(numel(fileStart)+2:end);
                break
            end
        end
    end
    libnames = fieldnames(versions);
    for i = 1:numel(libnames)
        fprintf('%s version %s\n', libnames{i}, versions.(libnames{i}));
    end
end

end

function out = getSlf4mVersion
instDir = fileparts(fileparts(mfilename('fullpath')));
descrInInstalledPackage = fullfile(instDir, 'packinfo', 'DESCRIPTION');
if exist(descrInInstalledPackage, 'file')
  out = parseVersionFromDescrFile(descrInInstalledPackage);
  return
end
descrInRepo = fullfile(fileparts(instDir), 'DESCRIPTION');
if exist(descrInRepo, 'file')
  out = parseVersionFromDescrFile(descrInRepo);
  return
end
error('%s\n%s', 'Can not determine SLF4O version: Could not find DESCRIPTION file for package.', ...
  'This probably means the package installation or your source repo are broken.');
end

function out = parseVersionFromDescrFile(descrFile)
txt = fileread(descrFile);
[match,tok] = regexp(txt, 'Version: *(\S+)', 'match', 'tokens');
if isempty(match)
  error('Failed parsing Version from package DESCRIPTION file: %s', descrFile);
end
out = tok{1}{1};
end
