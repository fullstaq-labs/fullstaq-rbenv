if [ "$RBENV_VERSION" == "system" ]; then
  PATH="$(remove_from_path "${RBENV_ROOT}/shims")" \
  gem=("$(command -v "gem" || true)")
  if [ -x "$gem" ]; then
    OLDIFS="$IFS"
    IFS=':' gempaths=(`$gem environment gempath`)
    IFS="$OLDIFS"
    for gempath in "${gempaths[@]}"; do
      path="${gempath}/bin/${RBENV_COMMAND}"
      if [ -x "$path" ]; then
        RBENV_COMMAND_PATHS+=("$path")
      fi
    done
  fi
else
  gem="${RBENV_ROOT}/versions/${RBENV_VERSION}/bin/gem"
  if [ -x "$gem" ]; then
    OLDIFS="$IFS"
    IFS=':' gempaths=(`$gem environment gempath`)
    IFS="$OLDIFS"
    for gempath in "${gempaths[@]}"; do
      path="${gempath}/bin/${RBENV_COMMAND}"
      if [ -x "$path" ]; then
        RBENV_COMMAND_PATHS+=("$path")
      fi
    done
  fi
  if [ -n "$RBENV_SYSTEM_VERSIONS_DIR" ]; then
    gem="${RBENV_SYSTEM_VERSIONS_DIR}/${RBENV_VERSION}/bin/gem"
    if [ -x "$gem" ]; then
      OLDIFS="$IFS"
      IFS=':' gempaths=(`$gem environment gempath`)
      IFS="$OLDIFS"
      for gempath in "${gempaths[@]}"; do
        path="${gempath}/bin/${RBENV_COMMAND}"
        if [ -x "$path" ]; then
          RBENV_COMMAND_PATHS+=("$path")
        fi
      done
    fi
  fi
fi
