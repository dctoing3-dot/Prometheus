#!/data/data/com.termux/files/usr/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Banner
echo -e "${GREEN}╔════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Prometheus Obfuscator Tool     ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════╝${NC}"

# Check arguments
if [ -z "$1" ]; then
    echo -e "${RED}Usage: ./obfuscate.sh <file.lua> [preset]${NC}"
    echo "Available presets: Minify, Weak, Medium, Strong"
    exit 1
fi

INPUT_FILE=$1
PRESET=${2:-Strong}
OUTPUT_FILE="${INPUT_FILE%.lua}.obf.lua"

# Check if file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo -e "${RED}Error: File $INPUT_FILE not found!${NC}"
    exit 1
fi

# Show info
echo -e "${YELLOW}Input:${NC} $INPUT_FILE"
echo -e "${YELLOW}Preset:${NC} $PRESET"
echo -e "${YELLOW}Output:${NC} $OUTPUT_FILE"
echo ""

# Run obfuscation
echo -e "${GREEN}Starting obfuscation...${NC}"
lua ~/Prometheus/cli.lua "$INPUT_FILE" --preset "$PRESET" --out "$OUTPUT_FILE"

# Check result
if [ $? -eq 0 ]; then
    ORIG_SIZE=$(wc -c < "$INPUT_FILE")
    OBF_SIZE=$(wc -c < "$OUTPUT_FILE")
    RATIO=$((OBF_SIZE * 100 / ORIG_SIZE))
    
    echo ""
    echo -e "${GREEN}✅ Success!${NC}"
    echo -e "Original size: ${YELLOW}$ORIG_SIZE bytes${NC}"
    echo -e "Obfuscated size: ${YELLOW}$OBF_SIZE bytes${NC}"
    echo -e "Size ratio: ${YELLOW}$RATIO%${NC}"
    echo ""
    echo -e "${GREEN}Test with: lua $OUTPUT_FILE${NC}"
else
    echo -e "${RED}❌ Obfuscation failed!${NC}"
    exit 1
fi
