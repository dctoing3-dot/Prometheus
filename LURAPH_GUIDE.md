# 🔒 Luraph-Style VM Obfuscation Guide

## Quick Commands

### Basic Usage
```bash
# 2 VM layers (recommended)
./luraphify.sh yourscript.lua 2

# 3 VM layers (maximum security)
./luraphify.sh yourscript.lua 3

# 4 VM layers (extreme - may be slow)
./luraphify.sh yourscript.lua 4

# 2 VM layers
lua cli.lua script.lua --config luraph_config.lua --out output.lua

# 3 VM layers
lua cli.lua script.lua --config ultimate_config.lua --out output.lua

# 4 VM layers
lua cli.lua script.lua --config extreme_config.lua --out output.lua



cat > luraphify.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash

INPUT=$1
VM_LAYERS=${2:-2}

if [ -z "$INPUT" ]; then
    echo "Usage: ./luraphify.sh <input.lua> [vm_layers]"
    echo ""
    echo "Examples:"
    echo "  ./luraphify.sh script.lua 2    # 2 VM layers (89KB) ✅"
    echo "  ./luraphify.sh script.lua 3    # 3 VM layers (huge) ⚠️"
    echo "  ./luraphify.sh script.lua 4    # 4 VM layers (TOO BIG!) ❌"
    exit 1
fi

if [ ! -f "$INPUT" ]; then
    echo "Error: $INPUT not found!"
    exit 1
fi

OUTPUT="${INPUT%.lua}.luraph${VM_LAYERS}x.lua"
TEMP_CONFIG=".luraph_config_$$.lua"

# Generate config in current directory (not /tmp)
cat > "$TEMP_CONFIG" << DYNCONFIG
return {
    LuaVersion = "Lua51";
    VarNamePrefix = "";
    NameGenerator = "MangledShuffled";
    PrettyPrint = false;
    Seed = 12345;
    Steps = {
        {Name = "EncryptStrings"; Settings = {};};
DYNCONFIG

# Add VM layers
for ((i=1; i<=VM_LAYERS; i++)); do
    echo "        {Name = \"Vmify\"; Settings = {};};" >> "$TEMP_CONFIG"
    if [ $i -lt $VM_LAYERS ]; then
        if [ $((i % 2)) -eq 0 ]; then
            echo "        {Name = \"ConstantArray\"; Settings = {};};" >> "$TEMP_CONFIG"
        else
            echo "        {Name = \"AntiTamper\"; Settings = {};};" >> "$TEMP_CONFIG"
        fi
    fi
done

# Add final steps
cat >> "$TEMP_CONFIG" << 'DYNCONFIG'
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

if [ "$VM_LAYERS" -ge 4 ]; then
    echo "⚠️  WARNING: 4+ VM layers may be too large to execute!"
    echo ""
fi

echo "Processing..."
START_TIME=$(date +%s)

lua cli.lua "$INPUT" --config "$TEMP_CONFIG" --out "$OUTPUT" 2>&1 | \
    grep -E "PROMETHEUS: (Step|Done|Generated Code size|Writing)"

END_TIME=$(date +%s)
ELAPSED=$((END_TIME - START_TIME))

# Check result
if [ -f "$OUTPUT" ]; then
    ORIG=$(wc -c < "$INPUT")
    OBFS=$(wc -c < "$OUTPUT")
    RATIO=$((OBFS * 100 / ORIG))
    
    echo ""
    echo "✅ Obfuscation Complete!"
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
        echo "❌ Execution failed or timeout"
        echo "   (File may be too large for Lua to parse)"
    fi
    
    echo ""
    echo "Output: $OUTPUT"
else
    echo ""
    echo "❌ Obfuscation failed!"
fi

# Cleanup
rm -f "$TEMP_CONFIG"
