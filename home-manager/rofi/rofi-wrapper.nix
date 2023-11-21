pkgs:

pkgs.rofi.overrideAttrs (old: {
  postBuild = ''
    rm -rf $out/bin
    mkdir $out/bin
    ln -s ${pkgs.rofi-unwrapped}/bin/* $out/bin
    rm $out/bin/rofi

    mkdir -p $ROFI_PLUGIN_PATH
    gappsWrapperArgsHook
    makeWrapper ${pkgs.rofi-unwrapped}/bin/rofi $out/bin/rofi \
      ''${gappsWrapperArgs[@]} \
      --prefix XDG_DATA_DIRS : ${pkgs.hicolor-icon-theme}/share \
      --add-flags "-plugin-path $ROFI_PLUGIN_PATH"

    rm $out/bin/rofi-theme-selector
    makeWrapper ${pkgs.rofi-unwrapped}/bin/rofi-theme-selector $out/bin/rofi-theme-selector \
      --prefix XDG_DATA_DIRS : $out/share
  '';
})