function unload_slf4o_pkg
  % Unload the SLF4O package
  %
  % This is what gets called by PKG_DEL.
  
  pkg_name = "slf4o";
  
  this_dir = fileparts (fullfile (mfilename ("fullpath")));
  inst_dir = fileparts (fileparts (this_dir));
  shims_dir = fullfile (inst_dir, "shims", "compat");

  % Unregister doco
  
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
      __octave_link_unregister_doc__ (qhelp_file);
    elseif compare_versions (version, "6.0.0", ">=")
      __event_manager_unregister_doc__ (qhelp_file);
    endif
  endif
    
endfunction
