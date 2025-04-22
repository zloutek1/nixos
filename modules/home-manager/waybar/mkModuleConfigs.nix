{ lib, ... }: 
let
  # Helper function to process a single bar
  processBar = config: modules: barName:
    let 
      allGeneratedFragments = builtins.map (moduleFunc: moduleFunc barName) modules;
      availableModuleNames = allGeneratedFragments |> builtins.concatMap 
        (fragment: builtins.attrNames fragment.programs.waybar.settings.${barName});
      
      barConfig = config.programs.waybar.settings.${barName};
      requestedModuleNames = barConfig.modules-left ++ barConfig.modules-center ++ barConfig.modules-right;
    
      missingModules = requestedModuleNames |> builtins.filter (name: !(builtins.elem name availableModuleNames));
      filteredFragments = allGeneratedFragments |> builtins.filter (fragment:
        let
          fragmentModuleNames = builtins.attrNames fragment.programs.waybar.settings.${barName};
        in
          fragmentModuleNames |> builtins.all (name: builtins.elem name requestedModuleNames)
      );
    in
      if (missingModules == []) then 
        filteredFragments 
      else 
        throw "Error: The following modules were requested but are not available: ${toString missingModules}\nAvailable modules are: ${toString availableModuleNames}";

  # Main function to create module configurations
  mkModuleConfigs = config: modules:
    config.programs.waybar.settings
    |> builtins.attrNames
    |> map (processBar config modules)
    |> builtins.concatLists;
in
  mkModuleConfigs