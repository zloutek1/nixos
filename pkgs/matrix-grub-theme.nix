{ pkgs }: 

pkgs.stdenv.mkDerivation {
    pname = "matrix-grub-theme";
    version = "0.1";

    src = pkgs.fetchFromGitHub {
        owner = "yeyushengfan258";
        repo = "Matrix-grub-theme";
        rev = "3aed8ee042e540246ee5b02d61d21c1d7889a208";
        sha256 = "sha256-sn7bAVlFwuwmCjmzKDALeSuuUV7awiZlLpqPUpXpWGI=";
    };

    nativeBuildInputs = [ pkgs.coreutils ];

    installPhase = ''
        runHook preInstall

        # --- Define variants based on assumptions ---
        local theme="sidebar"
        local screen="2k"     
        
        # Destination directory is $out
        mkdir -p $out
        echo "Installing Matrices GRUB theme variant:"
        echo "  Theme style: $theme, Screen: $screen"

        # --- Replicate copy_files logic from the script ---

        # 1. Copy Fonts (all .pf2 from common/)
        echo "Copying fonts..."
        cp common/*.pf2 "$out/"

        # 2. Copy Background image (based on theme style, renamed to background.jpg)
        echo "Copying background..."
        local background_src="backgrounds/backgrounds/background-$theme.jpg"
        if [ -f "$background_src" ]; then
            cp "$background_src" "$out/background.jpg"
        else
            echo "ERROR: Required background file not found: $background_src"
            exit 1
        fi

        # 3. Copy Icons (based on screen resolution)
        echo "Copying icons..."
        local icons_src_dir="assets/assets-icons/icons-$screen"
        if [ -d "$icons_src_dir" ]; then
            mkdir -p "$out/icons"
            cp -r "$icons_src_dir"/* "$out/icons/"
        else
            echo "ERROR: Required icons directory not found: $icons_src_dir"
            exit 1
        fi

        # 4. Copy theme.txt (based on theme style and screen resolution)
        echo "Copying theme.txt..."
        local theme_txt_src="config/theme-$theme-$screen.txt"
        if [ -f "$theme_txt_src" ]; then
            cp "$theme_txt_src" "$out/theme.txt"
        else
            echo "ERROR: Required theme config file not found: $theme_txt_src"
            exit 1
        fi

        # 5. Copy Selection images (select_*.png, based on screen resolution)
        echo "Copying selection images..."
        local select_prefix="assets/assets-other/other-$screen"
        if [ -d "$select_prefix" ]; then
            cp "$select_prefix/select_e.png" "$out/"
            cp "$select_prefix/select_c.png" "$out/"
            cp "$select_prefix/select_w.png" "$out/"
        else
            echo "ERROR: Required assets directory not found: $select_prefix"
            exit 1
        fi
        # Add more specific file existence checks if needed

        # 6. Copy Info image (based on screen res and theme style, renamed to info.png)
        echo "Copying info image..."
        local info_src="$select_prefix/$theme.png" # e.g., assets/assets-other/other-1080p/window.png
        if [ -f "$info_src" ]; then
            cp "$info_src" "$out/info.png"
        else
            echo "Warning: Info image not found: $info_src"
            # The theme might still work, but the info box could be empty/broken
        fi

        # Final check
        if [ ! -f $out/theme.txt ]; then
            echo "ERROR: Final theme.txt is missing in $out."
            exit 1
        fi


        runHook postInstall
    '';

}
