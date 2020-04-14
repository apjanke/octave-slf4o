## -*- texinfo -*-
## @deftypefn {Function} logger.initSLF4M
##
## SLF4M compatibility shim for initSLF4O
##
## This is an alias for initSLF4O. Calling it just results in initSLF4O()
## being called.
##
## This function is provided as a compatibility shim so that code which is
## expecting SLF4M will still work with SLF4O.
##
## @end deftypefn

function initSLF4M

initSLF4O();

end