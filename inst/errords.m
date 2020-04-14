## -*- texinfo -*-
##
## @node errords
## @deftypefn {Function} errords (@var{fmt}, @var{varargin})
## @deftypefnx {Function} errords (@var{errorId}, @var{fmt}, @var{varargin})
##
## A variant of error() that supports dispstr functionality.
##
## This is just like Octave's error(), except you can pass objects
## directly to @code{%s} conversion specifiers, and they will be automatically
## converted using dispstr.
##
## @end deftypefn

function errords(varargin)

args = dispstrlib.internal.convertArgsForPrintf(varargin);

if dispstrlib.internal.isErrorIdentifier(args{1})
  id = args{1};
  args = args(2:end);
else
  id = '';
end

err = MException(id, args{:});
throwAsCaller(err);

end