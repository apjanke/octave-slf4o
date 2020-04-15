## -*- texinfo -*-
##
## @deftypefn {Function} sprintfds (@var{fmt}, @var{varargin})
##
## A variant of sprintf() that supports dispstr functionality.
##
## This is just like Octave's sprintf(), except you can pass objects
## directly to @code{%s} conversion specifiers, and they will be automatically
## converted using dispstr.
##
## For inputs that are objects, dispstr() is implicitly called on them, so you
## can pass them directly to '%s' conversion specifiers in your format
## string.
##
## Examples:
##
## @example
## bday = Birthday (3, 14);
## str = sprintfds ('The value is: %s', bday)
## @end example
##
## See also:
## FPRINTFDS
##
## @end deftypefn

function out = sprintfds (fmt, varargin)

args = dispstrlib.internal.convertArgsForPrintf (varargin);

out = sprintf (fmt, args{:});

end