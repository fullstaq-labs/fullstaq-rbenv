# List all gem bindirs for specified ruby executable
list_gem_bindirs() {
  local ruby="$1"
  "$ruby" -e \
          'puts (Gem.path.map(&Gem.method(:bindir)) - [Gem.default_bindir]).join("\n")' 2>/dev/null || true
}

if [ "$RBENV_VERSION" == "system" ]; then
  PATH="$(remove_from_path "${RBENV_ROOT}/shims")" \
  gem="$(command -v "gem" || true)" \
  ruby="$(command -v "ruby" || true)"
  if [ -x "$gem" ]; then
    OLDIFS="$IFS"
    IFS=$'\n' bindirs=(`list_gem_bindirs "$ruby"`)
    IFS="$OLDIFS"
    for bindir in "${bindirs[@]}"; do
      RBENV_COMMAND_PATHS+=("${bindir}/${RBENV_COMMAND}")
    done
  fi
else
  gem="${RBENV_ROOT}/versions/${RBENV_VERSION}/bin/gem"
  if [ -x "$gem" ]; then
    OLDIFS="$IFS"
    IFS=$'\n' bindirs=(`list_gem_bindirs "${RBENV_ROOT}/versions/${RBENV_VERSION}/bin/ruby"`)
    IFS="$OLDIFS"
    for bindir in "${bindirs[@]}"; do
      RBENV_COMMAND_PATHS+=("${bindir}/${RBENV_COMMAND}")
    done
  fi
  if [ -n "$RBENV_SYSTEM_VERSIONS_DIR" ]; then
    gem="${RBENV_SYSTEM_VERSIONS_DIR}/${RBENV_VERSION}/bin/gem"
    if [ -x "$gem" ]; then
      OLDIFS="$IFS"
      IFS=$'\n' bindirs=(`list_gem_bindirs "${RBENV_SYSTEM_VERSIONS_DIR}/${RBENV_VERSION}/bin/ruby"`)
      IFS="$OLDIFS"
      for bindir in "${bindirs[@]}"; do
        RBENV_COMMAND_PATHS+=("${bindir}/${RBENV_COMMAND}")
      done
    fi
  fi
fi
