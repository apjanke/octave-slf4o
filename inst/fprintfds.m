## -*- texinfo -*-
##
## @deftypefn {Function} fprintfds (@var{fmt}, @var{varargin})
## @deftypefnx {Function} fprintfds (@var{fid}, @var{fmt}, @var{varargin})
##
## A variant of fprintf() that supports dispstr functionality.
##
## This is just like Octave's fprintf(), except you can pass objects
## directly to @code{%s} conversion specifiers, and they will be automatically
## converted using dispstr.
##
## See the documentation for SPRINTFDS for details on how it works.
##
## Examples:
##
## @example
## bday = Birthday(3, 14);
## fprintfds('The value is: %s', bday)
## @end example
##
## See also:
## SPRINTFDS
##
## @end deftypefn

function out = fprintfds(varargin)

args = varargin;
if isnumeric(args{1})
  fid = args{1};
  args(1) = [];
else
  fid = [];
end

fmt = args{1};
args(1) = [];

args = dispstrlib.internal.convertArgsForPrintf(args);

if isempty(fid)
  out = fprintf(fmt, args{:});
else
  out = fprintf(fid, fmt, args{:});
end

if nargout == 0
  clear out
end

end