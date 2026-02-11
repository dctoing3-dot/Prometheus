-- Luraph-Style Preset
return {
    -- Pipeline Steps
    Steps = {
        {
            Name = "Vmify";
            Settings = {};
        };
        {
            Name = "Encrypt Strings";
            Settings = {};
        };
        {
            Name = "Anti Tamper";
            Settings = {};
        };
        {
            Name = "Vmify";
            Settings = {};
        };
        {
            Name = "Constant Array";
            Settings = {};
        };
        {
            Name = "Numbers To Expressions";
            Settings = {};
        };
        {
            Name = "Wrap in Function";
            Settings = {};
        };
    };
    
    -- Variable Renaming
    VarNamePrefix = "";
    NameGenerator = "MangledShuffled";
    
    -- Pretty Print
    PrettyPrint = false;
}
