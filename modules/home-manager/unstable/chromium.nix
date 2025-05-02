{ config, lib, inputs, ... }: {

  disabledModules = [ 
    "${inputs.home-manager}/modules/programs/chromium.nix"
  ];
  imports = [ 
    "${inputs.home-manager-unstable}/modules/programs/chromium.nix"
  ];

  config = lib.mkIf config.programs.chromium.enable  {
    
    programs.chromium = {
      # enable = true;
      
      extensions = [
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
        { id = "nffaoalbilbmmfgbnbgppjihopabppdk"; } # Video Speed Controller
        { id = "fdpohaocaechififmbbbbbknoalclacl"; } # GoFullPage - Full Page Screen Capture
        { id = "cmpdlhmnmjhihmcfnigoememnffkimlk"; } # Catppuccin Chrome Theme - Macchiato
      ];
    };

  };
}