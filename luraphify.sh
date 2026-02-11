#!/data/data/com.termux/files/usr/bin/bash

INPUT=$1
VM_LAYERS=${2:-2}

if [ -z "$INPUT" ]; then
    echo "Usage: ./luraphify.sh <input.lua> [vm_layers]"
    echo ""
    echo "Examples:"
    echo "  ./luraphify.sh script.lua 2    # 2 VM layers (89KB)"
    echo "  ./luraphify.sh script.lua 3    # 3 VM layers (huge!)"
    echo "  ./luraphify.sh script.lua 4    # 4 VM layers (EXTREME!)"
    exit 1
fi

if [ ! -f "$INPUT" ]; then
    echo "Error: $INPUT not found!"
    exit 1
fi

OUTPUT="${INPUT%.lua}.luraph${VM_LAYERS}x.lua"

# Generate config with correct step names (CamelCase, no spaces!)
cat > /tmp/luraph_$$.lua << DYNCONFIG
return {
    LuaVersion = "Lua51";
    VarNamePrefix = "";
    NameGenerator = "MangledShuffled";
    PrettyPrint = false;
    Seed = 12345;
    Steps = {
        {Name = "EncryptStrings"; Settings = {};};
DYNCONFIG

# Add VM layers with anti-tamper between them
for ((i=1; i<=VM_LAYERS; i++)); do
    echo "        {Name = \"Vmify\"; Settings = {};};" >> /tmp/luraph_$$.lua
    if [ $i -lt $VM_LAYERS ]; then
        if [ $((i % 2)) -eq 0 ]; then
            echo "        {Name = \"ConstantArray\"; Settings = {};};" >> /tmp/luraph_$$.lua
        else
            echo "        {Name = \"AntiTamper\"; Settings = {};};" >> /tmp/luraph_$$.lua
        fi
    fi
done

# Add final steps
cat >> /tmp/luraph_$$.lua << 'DYNCONFIG'
        {Name = "ProxifyLocals"; Settings = {};};
        {Name = "NumbersToExpressions"; Settings = {};};
        {Name = "WrapInFunction"; Settings = {};};
    };
}
DYNCONFIG

echo "╔══════════════════════════════════════════╗"
echo "║     Luraph-Style Obfuscator v3.0         ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "Input:      $INPUT"
echo "VM Layers:  $VM_LAYERS"
echo "Output:     $OUTPUT"
echo ""
echo "Processing..."

# Run obfuscation
START_TIME=$(date +%s)
lua cli.lua "$INPUT" --config /tmp/luraph_$$.lua --out "$OUTPUT" 2>&1 | \
    grep -E "PROMETHEUS: (Applying|Step|Done|Generated Code size|Writing)"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

# Check result
if [ -f "$OUTPUT" ]; then
    ORIG=$(wc -c < "$INPUT")
    OBFS=$(wc -c < "$OUTPUT")
    RATIO=$((OBFS * 100 / ORIG))
    
    echo ""
    echo "✅ Luraphification Complete!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Original:    $ORIG bytes"
    echo "Obfuscated:  $OBFS bytes"
    echo "Ratio:       $RATIO%"
    echo "Time:        ${ELAPSED}s"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # Test execution
    echo ""
    echo "Testing execution..."
    if timeout 5 lua "$OUTPUT" > /dev/null 2>&1; then
        echo "✅ Execution successful!"
    else
        echo "⚠️  Warning: Execution timeout or failed"
    fi
    
    echo ""
    echo "Output saved to: $OUTPUT"
else
    echo ""
    echo "❌ Obfuscation failed!"
    echo "Generated config:"
    cat /tmp/luraph_$$.lua
fi

# Cleanup
rm -f /tmp/luraph_$$.lua
