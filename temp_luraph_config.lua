return {
    LuaVersion = "Lua51";
    VarNamePrefix = "";
    NameGenerator = "MangledShuffled";
    PrettyPrint = false;
    Seed = 12345;
    Steps = {
        {Name = "Encrypt Strings"; Settings = {};};
        {Name = "Vmify"; Settings = {};};
        {Name = "Anti Tamper"; Settings = {};};
        {Name = "Vmify"; Settings = {};};
        {Name = "Constant Array"; Settings = {};};
        {Name = "Proxify Locals"; Settings = {};};
        {Name = "Numbers To Expressions"; Settings = {};};
        {Name = "Wrap in Function"; Settings = {};};
    };
}
