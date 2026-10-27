# GRUB theme for yoga: Elegant, mojave/window/right at 4K.
{
  stdenv,
  fetchFromGitHub,
  bash,
  coreutils,
}:
stdenv.mkDerivation {
  name = "elegant-grub-theme";
  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Elegant-grub2-themes";
    rev = "8f36b5dde2361c902656bc82890f2902baa3c6c4";
    sha256 = "sha256-M9k6R/rUvEpBTSnZ2PMv5piV50rGTBrcmPU4gsS7Byg=";
  };

  nativeBuildInputs = [
    bash
    coreutils
  ];

  buildPhase = ''
    ls $src
    bash $src/generate.sh \
        --dest build \
        --theme mojave \
        --type window \
        --side right \
        --screen 4k
  '';

  installPhase = ''
    mkdir -p $out
    cp -r build/Elegant-*/* $out
  '';
}
