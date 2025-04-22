{ lib,... }:
let
  ### Helper Functions for Waybar Module Configuration Processing ###

  generateAllModuleConfigs = moduleFactories: barName:
    moduleFactories 
    |> builtins.map (factory: factory barName);

  getModuleNamesFromConfig = barName: moduleConfig:
    builtins.attrNames moduleConfig.programs.waybar.settings.${barName};

  getAvailableModuleNames = barName: allGeneratedModuleConfigs:
    allGeneratedModuleConfigs 
    |> builtins.concatMap (getModuleNamesFromConfig barName);

  getRequestedModuleNames = barConfig:
    barConfig.modules-left ++ barConfig.modules-center ++ barConfig.modules-right;

  findMissingModules = requestedNames: availableNames:
    requestedNames 
    |> builtins.filter (name: !(builtins.elem name availableNames));

  isModuleNeeded = moduleConfig: requestedNames: barName:
    getModuleNamesFromConfig barName moduleConfig              # definedNames
    |> builtins.any (name: builtins.elem name requestedNames); # isNeeded

  filterModuleConfigs = allConfigs: requestedNames: barName:
    allConfigs 
    |> builtins.filter (moduleConfig: isModuleNeeded moduleConfig requestedNames barName);

  ### Main functions
  
  validateAndFilterBarConfigs = config: moduleFactories: barName:
    let
      # Step 1: Generate all possible module configs for this bar
      allGeneratedConfigs = generateAllModuleConfigs moduleFactories barName;

      # Step 2: Extract names of all modules for which configs were generated (across all configs)
      availableNames = getAvailableModuleNames barName allGeneratedConfigs;

      # Step 3: Get the specific configuration for this bar instance
      barConfig = config.programs.waybar.settings.${barName};

      # Step 4: Extract the names of modules requested by this bar
      requestedNames = getRequestedModuleNames barConfig;

      # Step 5: Validate - find any requested modules that are not available
      missing = findMissingModules requestedNames availableNames;

      # Step 6: Filter - select configurations where at least one defined module is requested
      filteredConfigs = filterModuleConfigs allGeneratedConfigs requestedNames barName;

    in
      # Step 7: Return filtered configs or throw error if validation failed
      if (missing != []) then
        throw "Waybar Config Error: For bar '${barName}', requested modules not available: ${toString missing}\nAvailable modules (from all factories): ${toString availableNames}"
      else
        filteredConfigs;

  mkModuleConfigs = config: moduleFactories:
    builtins.attrNames config.programs.waybar.settings                                    # barNames
    |> builtins.map (barName: validateAndFilterBarConfigs config moduleFactories barName) # moduleConfigs
    |> builtins.concatLists;

in
  # Export the main orchestrating function
  mkModuleConfigs