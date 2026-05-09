#!/bin/bash
# prepare-sync.sh — Executar antes de todo sync com upstream WSO2
set -e

echo "📋 Preparando sincronização com WSO2 upstream..."

# 1. Verificar status limpo
if [ -n "$(git status -s)" ]; then
    echo "❌ Repositório com mudanças não commitadas"
    echo "   Execute: git stash"
    exit 1
fi
echo "✅ Working tree limpa"

# 2. Garantir que estamos em rotaz/main
git checkout rotaz/main
git pull origin rotaz/main

# 3. Fetch upstream (WSO2 usa 'master', não 'main')
echo "🔄 Fetching upstream..."
git fetch upstream master
git fetch upstream --tags 2>/dev/null || true

# 4. Resumo de mudanças a incorporar
AHEAD=$(git log --oneline rotaz/main..upstream/master | wc -l | tr -d ' ')
echo ""
echo "📊 upstream/master está $AHEAD commit(s) à frente de rotaz/main"

if [ "$AHEAD" -eq 0 ]; then
    echo "✅ rotaz/main já está sincronizado com upstream/master"
else
    echo ""
    echo "Commits a incorporar:"
    git log --oneline rotaz/main..upstream/master | head -20
fi

echo ""
echo "✅ Preparação completa — execute sync-merge.sh para continuar"