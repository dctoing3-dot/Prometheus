#!/data/data/com.termux/files/usr/bin/bash

# Auto Luraphify Script
# Usage: ./auto_luraphify.sh <input.lua> [layers]

INPUT=$1
LAYERS=${2:-3}
OUTPUT="${INPUT%.lua}.luraphified.lua"

if [ -z "$INPUT" ]; then
    echo "Usage: ./auto_luraphify.sh <input.lua> [layers]"
    echo "  layers: number of VM layers (default: 3)"
    exit 1
fi

if [ ! -f "$INPUT" ]; then
    echo "Error: File $INPUT not found!"
    exit 1
fi

echo "╔════════════════════════════════════════╗"
echo "║     Luraph-Style Obfuscation v3.0      ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "Input: $INPUT"
echo "Layers: $LAYERS"
echo "Output: $OUTPUT"
echo ""

# Generate config dynamically
cat > temp_luraph_config.lua << DYNCONFIG
return {
    LuaVersion = "Lua51";
    VarNamePrefix = "";
    NameGenerator = "MangledShuffled";
    PrettyPrint = false;
    Seed = 12345;
    Steps = {
        {Name = "Encrypt Strings"; Settings = {};};
DYNCONFIG

# Add VM layers
for ((i=1; i<=LAYERS; i++)); do
    echo "        {Name = \"Vmify\"; Settings = {};};" >> temp_luraph_config.lua
    if [ $i -lt $LAYERS ]; then
        echo "        {Name = \"Anti Tamper\"; Settings = {};};" >> temp_luraph_config.lua
        echo "        {Name = \"Constant Array\"; Settings = {};};" >> temp_luraph_config.lua
    fi
done

cat >> temp_luraph_config.lua << 'DYNCONFIG'
        {Name = "Proxify Locals"; Settings = {};};
        {Name = "Numbers To Expressions"; Settings = {};};
        {Name = "Wrap in Function"; Settings = {};};
    };
}
DYNCONFIG

echo "Step 1: Generating config with $LAYERS VM layers..."
echo "Step 2: Applying obfuscation..."

lua cli.lua "$INPUT" --config temp_luraph_config.lua --out "$OUTPUT" 2>&1 | grep -E "(PROMETHEUS|Done|size)"

if [ -f "$OUTPUT" ]; then
    ORIG_SIZE=$(wc -c < "$INPUT")
    OBFS_SIZE=$(wc -c < "$OUTPUT")
    RATIO=$((OBFS_SIZE * 100 / ORIG_SIZE))
    
    echo ""
    echo "✅ Luraphification Complete!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Original:    $ORIG_SIZE bytes"
    echo "Obfuscated:  $OBFS_SIZE bytes"
    echo "Ratio:       $RATIO%"
    echo "VM Layers:   $LAYERS"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "Test with: lua $OUTPUT"
    
    # Test execution
    echo -e "\nTesting execution..."
    if lua "$OUTPUT" > /dev/null 2>&1; then
        echo "✅ Execution successful!"
    else
        echo "⚠️ Warning: Execution failed, but file was created"
    fi
else
    echo "❌ Obfuscation failed!"
    rm -f temp_luraph_config.lua
    exit 1
fi

# Cleanup
rm -f temp_luraph_config.lua

echo ""
echo "🎉 Done! Your script is now protected with Luraph-style obfuscation"
