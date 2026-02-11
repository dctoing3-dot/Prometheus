#!/data/data/com.termux/files/usr/bin/bash

echo "=== VM Complexity Analysis ==="

for file in test.Strong.lua test.luraph.lua test.ultra_luraph.lua; do
    if [ -f "$file" ]; then
        echo -e "\n$file:"
        echo "  Size: $(wc -c < $file) bytes"
        echo "  Lines: $(wc -l < $file)"
        echo "  Functions: $(grep -o "function" $file | wc -l)"
        echo "  Tables: $(grep -o "{" $file | wc -l)"
        echo "  Unique vars: $(grep -o "[a-zA-Z_][a-zA-Z0-9_]*" $file | sort -u | wc -l)"
    fi
done
