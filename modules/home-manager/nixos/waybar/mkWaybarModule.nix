{ lib, ... }:

let
  # Extracts module names defined within a single generated config fragment for a specific bar.
  # Arguments:
  #   - barName: string, the name of the Waybar bar instance (e.g., "main-bar").
  #   - moduleConfig: attrset, a NixOS module configuration fragment,
  #                   typically the output of a module factory function.
  #                   Expected structure: { programs.waybar.settings.<barName> = { ... }; }
  # Returns: list of strings, the module names defined as keys within the settings for the given barName.
  getModuleNamesFromConfig = barName: moduleConfig:
    builtins.attrNames moduleConfig.programs.waybar.settings.${barName};

  # Gets all module names requested by the user across modules-{left,center,right} for a specific bar config.
  # Arguments:
  #   - barConfig: attrset, the user's configuration for a specific bar,
  #                typically found at `config.programs.waybar.settings.<barName>`.
  #                Expected structure: { modules-left = [..], modules-center = [..], modules-right = [..], ... }
  # Returns: list of strings, the concatenated list of module names requested in the bar's layout sections.
  getRequestedModuleNames = barConfig:
    builtins.concatLists [
      (barConfig.modules-left or [])
      (barConfig.modules-center or [])
      (barConfig.modules-right or [])
    ];

  # Checks if a generated module configuration fragment is needed for a bar,
  # by determining if it defines at least one module requested by the user for that bar.
  # Arguments:
  #   - moduleConfig: attrset, a generated NixOS module config fragment (output of a factory).
  #   - requestedNames: list of strings, the list of module names requested by the user for the bar.
  #   - barName: string, the name of the Waybar bar instance.
  # Returns: boolean, true if this moduleConfig defines at least one module listed in requestedNames.
  isModuleNeeded = moduleConfig: requestedNames: barName:
    let
      definedNames = getModuleNamesFromConfig barName moduleConfig;
    in
      builtins.any (name: builtins.elem name requestedNames) definedNames;

  # Processes configurations for a single Waybar bar instance.
  # It generates all possible module configurations from the provided factories for the specific bar,
  # validates that all modules requested by the user in the bar's config are available from the factories,
  # and filters the generated configurations to include only those that provide needed modules.
  # Arguments:
  #   - config: attrset, the overall NixOS configuration (`config`).
  #   - moduleFactories: list of functions, where each function is a module factory.
  #                    Each factory function should accept `barName` (string) and return an attrset
  #                    representing a NixOS module configuration fragment.
  #   - barName: string, the name of the specific Waybar bar instance being processed (e.g., "main-bar").
  # Returns: list of attrsets, containing only the necessary module configuration fragments for this bar.
  # Throws: Error string with details if any requested modules are not defined by any factory.
  processBar = config: moduleFactories: barName:
    let
      allGeneratedConfigs = builtins.map (factory: factory barName) moduleFactories;

      availableNames = builtins.concatMap (getModuleNamesFromConfig barName) allGeneratedConfigs;

      barConfig = config.programs.waybar.settings.${barName};

      requestedNames = getRequestedModuleNames barConfig;

      missing = builtins.filter (name: !(builtins.elem name availableNames)) requestedNames;

      neededConfigs = builtins.filter (moduleConfig: isModuleNeeded moduleConfig requestedNames barName) allGeneratedConfigs;

    in
      if (missing != []) then
        throw ''
          Waybar Config Error for bar '${barName}':
            Requested module(s) not available: ${toString missing}
            Available modules (provided by all factories): ${toString availableNames}
        ''
      else
        neededConfigs;

  # Main entry point to generate the final list of Waybar module configurations for NixOS.
  # It iterates through all bars defined in `config.programs.waybar.settings`,
  # processes each bar using `processBar` to validate and filter module configurations,
  # and finally concatenates the resulting lists of needed configurations from all bars.
  # Arguments:
  #   - config: attrset, the overall NixOS configuration, containing `programs.waybar.settings`.
  #   - moduleFactories: list of functions (module factories), passed through to `processBar`.
  #                    Each factory takes `barName` (string) and returns an attrset module config fragment.
  # Returns: list of attrsets, representing all necessary module configuration fragments merged from all bars.
  mkModuleConfigs = config: moduleFactories:
    let
      barNames = builtins.attrNames config.programs.waybar.settings;
      configsPerBar = builtins.map (barName: processBar config moduleFactories barName) barNames;
      allNeededConfigs = builtins.concatLists configsPerBar;
    in
      allNeededConfigs;

in
  mkModuleConfigs