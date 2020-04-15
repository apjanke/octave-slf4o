## -*- texinfo -*-
##
## @deftypefn {Function} pp (@var{varargin})
##
## Command wrapper for prettyprint().
##
## PP is a command-oriented wrapper for prettyprint, intended for interactive
## use. Code should not call this.
##
## Right now, it just calls PRETTYPRINT on its input, but the intention is to
## extend it to take variable names as chars in addition to the normal
## prettyprint input, so you can say 'pp foo' instead of 'pp(foo)'. This is
## purely a convenience to save users from typing in parentheses.
##
## @end deftypefn

function pp (varargin)

prettyprint (varargin{:});

end