#!/data/data/com.termux/files/usr/bin/bash

# Luraph-Style Obfuscator - Production Ready
# Only generates working configurations (1-3 VM layers)

INPUT=$1
LEVEL=${2:-2}

if [ -z "$INPUT" ]; then
    cat << HELP
🔒 Luraph-Style Obfuscator for Prometheus

Usage: $0 <input.lua> [level]

Levels:
  1 = Light    (Weak preset, 1x VM, ~2.8KB)
  2 = Strong   (Luraph 2x VM, ~89KB) ⭐ RECOMMENDED
  3 = Maximum  (Luraph 3x VM, ~250KB+, slow)

Examples:
  $0 script.lua 2     # Recommended for production
  $0 script.lua 3     # Maximum security

Note: Level 4+ creates files too large for Lua to execute
HELP
    exit 1
fi

if [ ! -f "$INPUT" ]; then
    echo "Error: $INPUT not found!"
    exit 1
fi

# Determine config based on level
case $LEVEL in
    1)
        PRESET="Weak"
        OUTPUT="${INPUT%.lua}.luraph_light.lua"
        echo "Using: Weak preset (1x VM)"
        lua cli.lua "$INPUT" --preset Weak --out "$OUTPUT"
        ;;
    2)
        CONFIG="luraph_config.lua"
        OUTPUT="${INPUT%.lua}.luraph_strong.lua"
        echo "Using: Luraph 2x VM (recommended)"
        lua cli.lua "$INPUT" --config "$CONFIG" --out "$OUTPUT"
        ;;
    3)
        CONFIG="ultimate_config.lua"
        OUTPUT="${INPUT%.lua}.luraph_max.lua"
        echo "Using: Luraph 3x VM (maximum)"
        lua cli.lua "$INPUT" --config "$CONFIG" --out "$OUTPUT"
        ;;
    *)
        echo "Error: Level must be 1, 2, or 3"
        exit 1
        ;;
esac

# Show results
if [ -f "$OUTPUT" ]; then
    ORIG=$(wc -c < "$INPUT")
    OBFS=$(wc -c < "$OUTPUT")
    
    echo ""
    echo "✅ Success!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Input:  $INPUT ($ORIG bytes)"
    echo "Output: $OUTPUT ($OBFS bytes)"
    echo ""
    
    # Test
    if lua "$OUTPUT" > /dev/null 2>&1; then
        echo "✅ Execution: OK"
    else
        echo "❌ Execution: FAILED"
    fi
fi
