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

}
