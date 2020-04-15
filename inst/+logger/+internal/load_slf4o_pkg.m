function load_slf4o_pkg
  % Load the SLF4O package
  %
  % This is the code that automatically gets called via PKG_ADD when the package
  % is loaded. It does not include the actual library initialization.

  % We disable the shadowed-function warning because we provide a package-scoped
  % error() function, which causes Octave to mistakenly, repeatedly issue warnings
  % like this:
  %   warning: function [...]/SLF4O/inst/+logger/error.m shadows a built-in function
  %
  % Sorry about this terrible hack.

  warning off Octave:shadowed-function

  pkg_name = "slf4o";
  
  this_dir = fileparts (fullfile (mfilename ("fullpath")));
  inst_dir = fileparts (fileparts (this_dir));
  
  % Load doco
  
  % When a package is installed, the doc/ directory is added as a subdir
  % of the main installation dir, which contains the inst/ files. But when
  % running from the repo, doc/ is a sibling of inst/.
  
  if exist (fullfile (inst_dir, "doc", [pkg_name ".qch"]), "file")
    qhelp_file = fullfile (inst_dir, "doc", [pkg_name ".qch"]);
  elseif exist (fullfile (fileparts (inst_dir), "doc", [pkg_name ".qch"]), "file")
    qhelp_file = fullfile (fileparts (inst_dir), "doc", [pkg_name ".qch"]);
  else
    % Couldn't find doc file. Oh well.
    qhelp_file = [];
  endif
  
  if ! isempty (qhelp_file)
    if compare_versions (version, "4.4.0", ">=") && compare_versions (version, "6.0.0", "<")
      __octave_link_register_doc__ (qhelp_file);
    elseif compare_versions (version, "6.0.0", ">=")
      __event_manager_register_doc__ (qhelp_file);
    endif
  endif
  
endfunction
