## -*- texinfo -*-
##
## @deftypefn {Function} warningds (@var{fmt}, @var{varargin})
## @deftypefnx {Function} warningds (@var{warningId}, @var{fmt}, @var{varargin})
##
## A variant of warning() that supports dispstr functionality.
##
## This is just like Octave's warning(), except you can pass objects
## directly to @code{%s} conversion specifiers, and they will be automatically
## converted using dispstr.
##
## @end deftypefn

function warningds (varargin)

args = dispstrlib.internal.convertArgsForPrintf (varargin);
warning (args{:});

end