list_gem_dirs() {
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
        OLDIFS="$IFS"
        IFS=':' gempaths=(`$gem environment gempath`)
        IFS="$OLDIFS"
        for gempath in "${gempaths[@]}"; do
          bindir="${gempath}/bin"
          for file in "${bindir}/"*; do
            echo -n "${file##*/} "
          done
        done
      fi
    done
  done
}

binstubs="`list_gem_dirs | sort -u`"

make_shims $binstubs
