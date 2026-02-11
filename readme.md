# Edit README
echo "" >> readme.md
echo "## 🔒 Luraph-Style Obfuscation" >> readme.md
echo "" >> readme.md
echo "This fork includes Luraph-style multi-layer VM configurations:" >> readme.md
echo "" >> readme.md
echo '```bash' >> readme.md
echo '# 2x VM (Recommended)' >> readme.md
echo 'lua cli.lua script.lua --config luraph_config.lua --out output.lua' >> readme.md
echo '' >> readme.md
echo '# 3x VM (Maximum Security)' >> readme.md
echo 'lua cli.lua script.lua --config ultimate_config.lua --out output.lua' >> readme.md
echo '```' >> readme.md

# Commit & push
git add readme.md
git commit -m "Update README with Luraph-style instructions"
git push origin master
