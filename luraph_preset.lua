-- Luraph-Style Preset for Prometheus
return {
    -- Pipeline Steps (Order matters!)
    Steps = {
        -- Layer 1: Base obfuscation
        {
            Name = "Encrypt Strings";
            Settings = {
                StringsEncryptionPercentage = 1.0;
                CustomEncryption = true;
            };
        };
        
        -- Layer 2: First VM layer
        {
            Name = "Vmify";
            Settings = {
                UseDebugLibrary = false;
                VmifyRecursionLimit = 1;
            };
        };
        
        -- Layer 3: Anti-Tamper
        {
            Name = "Anti Tamper";
            Settings = {
                UseDebugLibrary = true;
                MaxLevel = true;
            };
        };
        
        -- Layer 4: Second VM layer (nested)
        {
            Name = "Vmify";
            Settings = {
                UseDebugLibrary = false;
                VmifyRecursionLimit = 2;
            };
        };
        
        -- Layer 5: Constants
        {
            Name = "Constant Array";
            Settings = {
                Shuffle = true;
                Encrypt = true;
                MaxSize = 1000;
            };
        };
        
        -- Layer 6: Control Flow
        {
            Name = "ProxifyLocals";
            Settings = {};
        };
        
        -- Layer 7: Numbers
        {
            Name = "NumbersToExpressions";
            Settings = {};
        };
        
        -- Layer 8: Third VM layer (deep nested)
        {
            Name = "Vmify";
            Settings = {
                UseDebugLibrary = false;
                VmifyRecursionLimit = 3;
            };
        };
        
        -- Layer 9: Final wrap
        {
            Name = "WrapInFunction";
            Settings = {};
        };
    };
    
    -- Variable Renaming
    VarNamePrefix = "";
    NameGenerator = "MangledShuffled";
    LocalsPrefix = "_";
    GlobalsPrefix = "__";
    
    -- Pretty Print (disable for production)
    PrettyPrint = false;
    IndentCount = 0;
    
    -- Seed for randomization
    Seed = os.time();
}
