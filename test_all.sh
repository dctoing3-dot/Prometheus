#!/data/data/com.termux/files/usr/bin/bash

echo "╔═══════════════════════════════════════════════════════════════════╗"
echo "║         COMPLETE OBFUSCATION TEST - ALL CONFIGURATIONS            ║"
echo "╚═══════════════════════════════════════════════════════════════════╝"
echo ""

ORIG=98

echo "Testing all generated files..."
echo ""
printf "%-25s | %10s | %12s | %10s\n" "File" "Size" "Ratio" "Status"
echo "───────────────────────────────────────────────────────────────────"

# Test all files
for file in test.*.lua test.*vm.lua; do
    # Skip original and duplicates
    if [[ "$file" == "test.lua" ]]; then
        continue
    fi
    
    if [ -f "$file" ]; then
        size=$(wc -c < "$file")
        ratio=$((size * 100 / ORIG))
        
        # Format size
        if [ $size -gt 1048576 ]; then
            size_fmt="$(echo "scale=1; $size/1048576" | bc)MB"
        elif [ $size -gt 1024 ]; then
            size_fmt="$(echo "scale=1; $size/1024" | bc)KB"
        else
            size_fmt="${size}B"
        fi
        
        # Test execution with timeout
        if timeout 5 lua "$file" > /tmp/test_out_$$ 2>&1; then
            output=$(cat /tmp/test_out_$$)
            if [[ "$output" == *"Hello World"* ]] && [[ "$output" == *"Termux"* ]]; then
                status="✅ PERFECT"
            else
                status="⚠️  RUNS"
            fi
        else
            error=$(cat /tmp/test_out_$$ 2>&1 | head -1)
            if [[ "$error" == *"too long"* ]]; then
                status="❌ TOO BIG"
            else
                status="❌ TIMEOUT"
            fi
        fi
        
        printf "%-25s | %10s | %11d%% | %10s\n" "$file" "$size_fmt" "$ratio" "$status"
        rm -f /tmp/test_out_$$
    fi
done

echo "───────────────────────────────────────────────────────────────────"
