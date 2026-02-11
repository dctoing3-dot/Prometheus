return {
    -- Lua Version (Lua51 / LuaU)
    LuaVersion = "Lua51";
    
    -- Minify Settings
    VarNamePrefix = "";
    NameGenerator = "MangledShuffled";
    PrettyPrint = false;
    
    -- Obfuscation Steps
    Vmify = true;
    ConstantArray = true;
    ProxifyLocals = true;
    EncryptStrings = true;
    AntiTamper = true;
    
    -- Extra Security
    MaxSecurityLevel = true;
    RandomizeNames = true;
    BytecodeSafe = true;
}
