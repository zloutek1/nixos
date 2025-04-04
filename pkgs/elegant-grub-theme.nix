{ pkgs }: 

pkgs.stdenv.mkDerivation {
    pname = "elegant-grub-theme";
    version = "0.1";

    src = pkgs.fetchFromGithub {
        owner = "vinceliuice";
        repo = "Elegant-grub2-themes";
        rev = "7caa304b349ee638481935d5e0d82b33033b0b1c";
        sha256 = "";
    };

}
