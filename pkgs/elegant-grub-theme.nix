{ pkgs }: 

pkgs.stdenv.mkDerivation {
    pname = "elegant-grub-theme";
    version = "0.1";

    src = pkgs.fetchFromGitHub {
        owner = "vinceliuice";
        repo = "Elegant-grub2-themes";
        rev = "7caa304b349ee638481935d5e0d82b33033b0b1c";
        sha256 = "sha256-mBhG3fFYUIE2Sf2h4PVLhbC9PboZaAx1EpaQ7NX9NtE=";
    };

    nativeBuildInputs = [ pkgs.coreutils ];

    installPhase = ''
        runHook preInstall

        # --- Define variants based on assumptions ---
        local theme="mojave"   # [forest|mojave|mountain|wave] (default is forest)
        local type="window"      # [window|float|sharp|blur] (default is window)
        local side="right"       # [left|right] (default is left)
        local color="dark"       # [dark|light] (default is dark)
        local screen="1080p"     # [1080p|2k|4k] (default is 1080p)
        local logoicon="default" # [default|system] (default: a mountain logo)

        # Determine fontsize based on screen (from script)
        local fontsize="16" # Default for 1080p
        if [[ "$screen" == "2k" ]]; then fontsize="24"; fi
        if [[ "$screen" == "4k" ]]; then fontsize="32"; fi

        # Destination is $out
        mkdir -p $out
        echo "Installing Elegant GRUB theme variant:"
        echo "  Theme: $theme, Type: $type, Side: $side, Color: $color, Screen: $screen, Logo: $logoicon"

        # --- Replicate copy_files logic ---

        # 1. Copy Fonts (terminus and specific unifont)
        echo "Copying fonts..."
        cp common/terminus*.pf2 "$out/"
        local unifont_src="common/unifont-$fontsize.pf2"
        if [ -f "$unifont_src" ]; then
            cp "$unifont_src" "$out/"
        else
            echo "Warning: Required font file not found: $unifont_src"
        fi

        # 2. Copy Background image (specific variant, rename to background.jpg)
        echo "Copying background..."
        local background_src="backgrounds/backgrounds-$theme/background-$theme-$type-$side-$color.jpg"
        if [ -f "$background_src" ]; then
            cp "$background_src" "$out/background.jpg"
        else
            echo "ERROR: Required background file not found: $background_src"
            exit 1
        fi

        # 3. Copy Icons (specific color and screen variant)
        echo "Copying icons..."
        local icons_src_dir="assets/assets-icons-$color/icons-$color-$screen"
        if [ -d "$icons_src_dir" ]; then
            # Copy contents of the icons dir into $out/icons
            mkdir -p "$out/icons"
            cp -r "$icons_src_dir"/* "$out/icons/"
        else
            echo "ERROR: Required icons directory not found: $icons_src_dir"
            exit 1
        fi

        # 4. Copy theme.txt (specific variant based on type, side, color, screen)
        # Note: 'blur' type uses 'sharp' theme file according to script
        echo "Copying theme.txt..."
        local theme_txt_src=""
        if [[ "$type" == "blur" ]]; then
            theme_txt_src="config/theme-sharp-$side-dark-$screen.txt" # Uses sharp-dark even for blur
        else
            theme_txt_src="config/theme-$type-$side-$color-$screen.txt"
        fi

        if [ -f "$theme_txt_src" ]; then
            cp "$theme_txt_src" "$out/theme.txt"
        else
            echo "ERROR: Required theme config file not found: $theme_txt_src"
            exit 1
        fi

        # 5. Copy Selection images (select_*.png)
        # Note: 'blur' type uses white versions
        echo "Copying selection images..."
        local select_prefix="assets/assets-other/other-$screen"
        if [[ "$type" == "blur" ]]; then
            cp "$select_prefix/select_e-white.png" "$out/select_e.png"
            cp "$select_prefix/select_c-white.png" "$out/select_c.png"
            cp "$select_prefix/select_w-white.png" "$out/select_w.png"
        else
            cp "$select_prefix/select_e-$theme-$color.png" "$out/select_e.png"
            cp "$select_prefix/select_c-$theme-$color.png" "$out/select_c.png"
            cp "$select_prefix/select_w-$theme-$color.png" "$out/select_w.png"
        fi
        # Add error checking if needed

        # 6. Copy Info image (info.png)
        # Note: 'blur' type uses 'sharp' image according to script
        echo "Copying info image..."
        local info_img_base=""
        if [[ "$type" == "blur" ]]; then
            info_img_base="sharp-$side" # uses sharp even for blur
        else
            info_img_base="$type-$side"
        fi
        # Special case for 'forest' theme (adds '-alt'), but we assume 'mountain'
        local info_src="$select_prefix/$info_img_base.png"
        if [ -f "$info_src" ]; then
            cp "$info_src" "$out/info.png"
        else
            echo "Warning: Info image not found: $info_src"
        fi

        # 7. Copy Logo image (logo.png)
        echo "Copying logo image..."
        local logo_src="$select_prefix/$logoicon.png"
        if [[ -f "$logo_src" ]]; then
            cp "$logo_src" "$out/logo.png"
        elif [[ -f "$select_prefix/Default.png" ]]; then
            echo "Warning: Logo '$logoicon.png' not found, using Default.png"
            cp "$select_prefix/Default.png" "$out/logo.png"
        else
            echo "Warning: Logo '$logoicon.png' and Default.png not found."
        fi

        runHook postInstall
    '';

}
