-- Ultra Luraph-Style (3x VM Layer)
return {
    LuaVersion = "Lua51";
    VarNamePrefix = "";
    NameGenerator = "MangledShuffled";
    PrettyPrint = false;
    Seed = 12345;
    
    Steps = {
        -- Layer 1: Encrypt strings
        {
            Name = "Encrypt Strings";
            Settings = {};
        };
        
        -- Layer 2: First VM
        {
            Name = "Vmify";
            Settings = {};
        };
        
        -- Layer 3: Anti-Tamper
        {
            Name = "Anti Tamper";
            Settings = {};
        };
        
        -- Layer 4: Second VM
        {
            Name = "Vmify";
            Settings = {};
        };
        
        -- Layer 5: Constants
        {
            Name = "Constant Array";
            Settings = {};
        };
        
        -- Layer 6: Proxify
        {
            Name = "Proxify Locals";
            Settings = {};
        };
        
        -- Layer 7: Numbers
        {
            Name = "Numbers To Expressions";
            Settings = {};
        };
        
        -- Layer 8: Third VM
        {
            Name = "Vmify";
            Settings = {};
        };
        
        -- Layer 9: Final wrap
        {
            Name = "Wrap in Function";
            Settings = {};
        };
    };
}
