#!/data/data/com.termux/files/usr/bin/bash

echo "╔════════════════════════════════════════════════════════════════════╗"
echo "║           Prometheus VM Obfuscation - Final Comparison             ║"
echo "╚════════════════════════════════════════════════════════════════════╝"
echo ""

ORIG=$(wc -c < test.lua 2>/dev/null || echo "0")

if [ "$ORIG" == "0" ]; then
    echo "Error: test.lua not found"
    exit 1
fi

echo "Original: test.lua = $ORIG bytes"
echo ""
printf "%-20s | %12s | %10s | %10s | %8s\n" "Configuration" "Size" "Ratio" "Functions" "Status"
echo "────────────────────────────────────────────────────────────────────"

files=(
    "test.Minify.lua:Minify (0x VM)"
    "test.Weak.lua:Weak (1x VM)"
    "test.Medium.lua:Medium (1x VM)"
    "test.Strong.lua:Strong (2x VM)"
    "test.luraph.lua:Luraph 2x VM"
    "test.luraph2x.lua:Luraph 2x VM"
    "test.3vm.lua:Luraph 3x VM"
    "test.luraph3x.lua:Luraph 3x VM"
    "test.4vm.lua:Luraph 4x VM"
    "test.luraph4x.lua:Luraph 4x VM"
)

for entry in "${files[@]}"; do
    IFS=':' read -r file label <<< "$entry"
    
    if [ -f "$file" ]; then
        size=$(wc -c < "$file")
        ratio=$((size * 100 / ORIG))
        funcs=$(grep -o "function" "$file" | wc -l)
        
        # Test execution (with timeout)
        if timeout 3 lua "$file" > /dev/null 2>&1; then
            status="✅"
        else
            status="❌"
        fi
        
        printf "%-20s | %10db | %9d%% | %10d | %8s\n" "$label" "$size" "$ratio" "$funcs" "$status"
    fi
done

echo "────────────────────────────────────────────────────────────────────"
echo ""
echo "Legend:"
echo "  ✅ = Executes successfully"
echo "  ❌ = Execution failed or timeout"
echo ""
echo "Recommendation:"
echo "  • For production: 2x VM (89KB, good balance)"
echo "  • For maximum security: 3x VM (huge, very slow)"
echo "  • 4x VM: Only for extreme cases (may timeout)"
