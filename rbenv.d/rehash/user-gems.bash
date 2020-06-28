# This plugin lists all available gem commands for the current user
# and creates shims for these commands.
# It works by iterating over all installed version and gathering the list
# of executables. For each gem path of the installed Ruby version,
# we ask Rubygems for the corresponding bin path. For each bin path
# we list the executable files.

list_executable_names() {
  local version file
  local -a version_dirs
  rbenv-versions --bare --skip-aliases | \
  while read -r version; do
    version_dirs=("${RBENV_ROOT}/versions/${version}")
    if [ -n "$RBENV_SYSTEM_VERSIONS_DIR" ]; then
      version_dirs+=("$RBENV_SYSTEM_VERSIONS_DIR/${version}")
    fi
    for version_dir in "${version_dirs[@]}"; do
      gem="${version_dir}/bin/gem"
      if [ -x "$gem" ]; then
        "${version_dir}/bin/ruby" -e \
          'puts (Gem.path.map(&Gem.method(:bindir)) - [Gem.default_bindir]).join("\n")' 2>/dev/null | \
        while read -r bindir; do
          for file in "${bindir}/"*; do
            [ -x "$file" ] && echo "${file##*/}"
          done
        done
      fi
    done
  done
}

make_shims $(list_executable_names | sort -u)
