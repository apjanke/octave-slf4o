## -*- texinfo -*-
##
## @deftypefn {Function} {@var{out} =} size2str (@var{sz})
##
## Format a matrix size for display.
##
## Sz is an array of dimension sizes, in the format returned by SIZE.
##
## Returns a charvec.
##
## @end deftypefn

function out = size2str(sz)

strs = cell(size(sz));
for i = 1:numel(sz)
	strs{i} = sprintf('%d', sz(i));
end

out = strjoin(strs, '-by-');
end