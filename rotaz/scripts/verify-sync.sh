#!/bin/bash
# verify-sync.sh — Executar após sync-merge.sh para validar build e segurança
ERRORS=0

echo "✔️  Verificando sincronização..."

echo ""
echo "🔨 Compilando (sem testes)..."
if mvn clean install -DskipTests -q --file all-in-one-apim/pom.xml; then
    echo "✅ Build OK"
else
    echo "❌ Erro na compilação"
    ((ERRORS++))
fi

echo ""
echo "🧪 Rodando testes..."
if mvn test -q --file all-in-one-apim/pom.xml; then
    echo "✅ Testes OK"
else
    echo "❌ Testes falharam"
    ((ERRORS++))
fi

echo ""
echo "🔐 Security scan (vulnerabilidades críticas)..."
if command -v trivy &>/dev/null; then
    if trivy fs . \
        --severity CRITICAL \
        --scanners vuln \
        --skip-dirs all-in-one-apim,target \
        --offline-scan \
        --quiet; then
        echo "✅ Sem vulnerabilidades críticas"
    else
        echo "⚠️  Vulnerabilidades críticas encontradas — consulte ROTAZ_SECURITY.md"
        ((ERRORS++))
    fi
else
    echo "⚠️  trivy não instalado — pulando security scan local"
    echo "   CI/CD fará o scan via security-scan.yml"
fi

# Atualizar changelog com registro do sync
UPSTREAM_COMMIT=$(git log --oneline upstream/master -1 | cut -d' ' -f1)
DATE=$(date +%Y-%m-%d)
ENTRY="- [$DATE] Sync com upstream WSO2 (upstream/master @ $UPSTREAM_COMMIT)"

if grep -q "$DATE" ROTAZ_CHANGELOG.md 2>/dev/null; then
    echo ""
    echo "ℹ️  ROTAZ_CHANGELOG.md já contém entrada para $DATE"
else
    sed -i "s/## \[Unreleased\]/## [Unreleased]\n\n### Upstream Sync\n$ENTRY/" ROTAZ_CHANGELOG.md
    git add ROTAZ_CHANGELOG.md
    git commit -m "docs: register upstream sync $DATE in changelog"
    git push origin rotaz/main
    echo ""
    echo "✅ ROTAZ_CHANGELOG.md atualizado"
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "✅ Sincronização verificada com sucesso!"
else
    echo "❌ $ERRORS erro(s) encontrado(s) — resolva antes de considerar o sync completo"
    exit 1
fi