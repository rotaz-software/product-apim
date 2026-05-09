#!/bin/bash
# sync-merge.sh — Executar após prepare-sync.sh
set -e

echo "🔀 Mergeando upstream/master em rotaz/main..."
git checkout rotaz/main

MERGE_MSG="chore: sync WSO2 upstream $(date +%Y-%m-%d)"

if git merge -m "$MERGE_MSG" upstream/master; then
    echo "✅ Merge sem conflitos!"
    git push origin rotaz/main
    echo "🚀 Push realizado com sucesso"
    echo ""
    echo "Execute verify-sync.sh para validar o build"
else
    echo ""
    echo "⚠️  Conflitos detectados nos seguintes arquivos:"
    git diff --name-only --diff-filter=U
    echo ""
    echo "📖 Consulte ROTAZ_CUSTOMIZATIONS.md para guia de resolução"
    echo "   Após resolver: git add . && git commit && git push origin rotaz/main"
    exit 1
fi