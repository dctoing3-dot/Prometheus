#!/data/data/com.termux/files/usr/bin/bash

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║              Prometheus VM Obfuscation - FINAL RESULTS             ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

ORIG=98  # test.lua size

printf "%-20s | %12s | %12s | %10s\n" "Configuration" "Size" "Ratio" "Status"
echo "────────────────────────────────────────────────────────────────────"

# Check existing files
declare -A files=(
    ["Minify (0x VM)"]="test.Minify.lua"
    ["Weak (1x VM)"]="test.Weak.lua"
    ["Medium (1x VM)"]="test.Medium.lua"
    ["Strong (2x VM)"]="test.Strong.lua"
    ["Luraph 2x VM"]="test.luraph.lua"
    ["Luraph 3x VM"]="test.3vm.lua"
    ["Luraph 4x VM"]="test.4vm.lua"
)

for label in "Minify (0x VM)" "Weak (1x VM)" "Medium (1x VM)" "Strong (2x VM)" "Luraph 2x VM" "Luraph 3x VM" "Luraph 4x VM"; do
    file="${files[$label]}"
    
    if [ -f "$file" ]; then
        size=$(wc -c < "$file")
        ratio=$((size * 100 / ORIG))
        
        # Format size nicely
        if [ $size -gt 1048576 ]; then
            size_str="$(echo "scale=1; $size/1048576" | bc)M"
        elif [ $size -gt 1024 ]; then
            size_str="$(echo "scale=1; $size/1024" | bc)K"
        else
            size_str="${size}b"
        fi
        
        # Test execution
        if timeout 3 lua "$file" > /dev/null 2>&1; then
            status="✅ OK"
        else
            status="❌ FAIL"
        fi
        
        printf "%-20s | %12s | %11d%% | %10s\n" "$label" "$size_str" "$ratio" "$status"
    fi
done

echo "────────────────────────────────────────────────────────────────────"
echo ""
echo "📊 Analysis:"
echo ""
echo "✅ Working Configurations:"
echo "   • Minify (0x VM):   143 bytes   - Basic minification"
echo "   • Weak (1x VM):     2.8KB       - Light obfuscation"
echo "   • Medium (1x VM):   18KB        - Medium obfuscation"
echo "   • Strong (2x VM):   32KB        - Strong obfuscation"
echo "   • Luraph 2x VM:     89KB        - Very strong (RECOMMENDED)"
echo ""
echo "⚠️  Extreme Configurations:"
echo "   • Luraph 3x VM:     ~250KB+     - May be slow"
echo ""
echo "❌ Too Large (Lua Limitation):"
echo "   • Luraph 4x VM:     3.3MB       - Cannot execute!"
echo "     Error: 'control structure too long'"
echo "     This exceeds Lua's parser limits"
echo ""
echo "🎯 Recommendation:"
echo "   For Luraph-style protection, use 2x VM (89KB)"
echo "   This provides excellent security with working execution"
