#!/data/data/com.termux/files/usr/bin/bash

# Simplified Luraphify
INPUT=$1
LAYERS=${2:-2}

if [ -z "$INPUT" ]; then
    echo "Usage: ./luraphify_simple.sh <input.lua> [layers]"
    exit 1
fi

OUTPUT="${INPUT%.lua}.luraph${LAYERS}.lua"

echo "🔒 Luraphifying: $INPUT with $LAYERS VM layers"

# Use the working config as base
if [ "$LAYERS" == "2" ]; then
    # 2 layers (like luraph_config.lua yang berhasil)
    lua cli.lua "$INPUT" --config luraph_config.lua --out "$OUTPUT"
elif [ "$LAYERS" == "3" ]; then
    # 3 layers
    lua cli.lua "$INPUT" --config ultra_luraph_config.lua --out "$OUTPUT"
else
    # Custom layers
    cat > temp_config_$$.lua << 'CONF'
return {
    LuaVersion = "Lua51";
    VarNamePrefix = "";
    NameGenerator = "MangledShuffled";
    PrettyPrint = false;
    Seed = 12345;
    Steps = {
CONF
    
    # Add string encryption first
    echo '        {Name = "Encrypt Strings"; Settings = {};};' >> temp_config_$$.lua
    
    # Add VM layers
    for ((i=1; i<=$LAYERS; i++)); do
        echo '        {Name = "Vmify"; Settings = {};};' >> temp_config_$$.lua
        if [ $i -lt $LAYERS ]; then
            echo '        {Name = "Anti Tamper"; Settings = {};};' >> temp_config_$$.lua
        fi
    done
    
    # Add final steps
    cat >> temp_config_$$.lua << 'CONF'
        {Name = "Constant Array"; Settings = {};};
        {Name = "Proxify Locals"; Settings = {};};
        {Name = "Numbers To Expressions"; Settings = {};};
        {Name = "Wrap in Function"; Settings = {};};
    };
}
CONF
    
    lua cli.lua "$INPUT" --config temp_config_$$.lua --out "$OUTPUT"
    rm -f temp_config_$$.lua
fi

# Show results
if [ -f "$OUTPUT" ]; then
    echo "✅ Success: $OUTPUT"
    ls -lh "$OUTPUT"
    lua "$OUTPUT" > /dev/null 2>&1 && echo "✅ Execution: OK" || echo "⚠️  Execution: Failed"
else
    echo "❌ Failed to generate output"
fi
