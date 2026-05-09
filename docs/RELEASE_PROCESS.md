# Release Process

Guia de versionamento e release do fork Rotaz do WSO2 product-apim.

---

## Formato de Versão

```
<WSO2-VERSION>-rotaz-<PATCH>

Exemplos:
4.7.0-rotaz-01   ← Primeira release Rotaz sobre WSO2 4.7.0
4.7.0-rotaz-02   ← Segunda release (patches adicionais)
4.7.1-rotaz-01   ← Primeira release sobre WSO2 4.7.1
```

Incrementar `<PATCH>` a cada release. Resetar para `01` ao mudar a versão WSO2 base.

---

## Quando Fazer uma Release

| Gatilho | Tipo | Urgência |
|---------|------|----------|
| Nova feature mergeada e validada | Feature release | Normal |
| Security patch crítico aplicado | Security release | Alta |
| Sync com novo upstream WSO2 release | Upstream release | Normal |
| Hotfix de produção | Hotfix release | Urgente |

---

## Passo a Passo

### 1. Verificar pré-condições

```bash
cd /projects/rotaz/repos/product-apim

# Working tree limpa
git status

# Em rotaz/main e atualizado
git checkout rotaz/main
git pull origin rotaz/main

# CI verde — confirmar no GitHub Actions que build-dim passou
# https://github.com/rotaz-software/product-apim/actions/workflows/build-dim.yml
```

### 2. Determinar o número da versão

```bash
# Ver última tag Rotaz
git tag --sort=-version:refname | grep rotaz | head -5

# Determinar próxima versão:
# Ex.: última é 4.7.0-rotaz-01 → próxima é 4.7.0-rotaz-02
NEXT_VERSION="4.7.0-rotaz-02"
```

### 3. Atualizar `ROTAZ_CHANGELOG.md`

Mover itens de `[Unreleased]` para a nova versão com data:

```markdown
## [4.7.0-rotaz-02] — YYYY-MM-DD

### Added
- <feature>

### Fixed
- <fix>

### Security
- <patch>

### Upstream Sync
- Mergeado upstream/master @ <commit-hash>
```

Commitar:

```bash
git add ROTAZ_CHANGELOG.md
git commit -m "docs: prepare ROTAZ_CHANGELOG.md for release $NEXT_VERSION"
git push origin rotaz/main
```

### 4. Criar a tag de release

```bash
NEXT_VERSION="4.7.0-rotaz-02"

git tag -a "$NEXT_VERSION" -m "$(cat <<EOF
Release $NEXT_VERSION

Changes since previous release:
- <resumo das mudanças principais>

Build: github.com/rotaz-software/product-apim:$NEXT_VERSION
Upstream base: WSO2/product-apim master @ $(git log upstream/master -1 --format='%h')
EOF
)"

git push origin "$NEXT_VERSION"
```

### 5. Build DIM com a tag

No repositório `dim-builder`:

```bash
cd /projects/rotaz/repos/dim-builder

./ci-cd/scripts/build-from-github.sh \
  https://github.com/rotaz-software/product-apim \
  "$NEXT_VERSION" \
  4.7.0 \
  rotazsoftware
```

Imagens geradas:
```
rotazsoftware/dim-control-plane:<NEXT_VERSION>
rotazsoftware/dim-key-manager:<NEXT_VERSION>
rotazsoftware/dim-traffic-manager:<NEXT_VERSION>
rotazsoftware/dim-universal-gateway:<NEXT_VERSION>
```

### 6. Registrar no ciclo PDCA

```bash
cd /projects/rotaz/repos/dim-builder

# Registrar candidatos
./ci-cd/scripts/dim-image-mgr.sh register \
  control-plane 4.7.0 rotaz-02 \
  rotazsoftware/dim-control-plane:$NEXT_VERSION

# Comparar com release anterior
./ci-cd/scripts/dim-image-mgr.sh compare control-plane 4.7.0

# Eleger
./ci-cd/scripts/dim-image-mgr.sh elect control-plane 4.7.0 rotaz-02 \
  "Release $NEXT_VERSION — <justificativa>"
```

### 7. Criar GitHub Release (opcional)

```bash
gh release create "$NEXT_VERSION" \
  --repo rotaz-software/product-apim \
  --title "DIM $NEXT_VERSION" \
  --notes "$(cat ROTAZ_CHANGELOG.md | sed -n "/## \[$NEXT_VERSION\]/,/## \[/p" | head -40)"
```

---

## Nomenclatura de Branches

```
upstream/*              ← Rastreamento do WSO2 (nunca commitar direto)
rotaz/main              ← Branch principal de desenvolvimento Rotaz
rotaz/<feature>         ← Feature branches Rotaz
dim/<feature>           ← Features específicas do DIM
hotfix/<ticket>/*       ← Hotfixes críticos
```

### Convenção de Commits

```
feat: [DIM] Add new feature
fix: [ROTAZ-123] Fix critical issue
perf: [INTERNAL] Performance improvement
security: [CVE-XXXX] Security patch from WSO2
docs: Update documentation
chore: sync WSO2 upstream YYYY-MM-DD
```

---

## Hotfix de Produção

Para fixes urgentes que não podem esperar o ciclo normal:

```bash
# 1. Criar branch a partir da tag em produção
git checkout -b hotfix/ROTAZ-999 4.7.0-rotaz-01

# 2. Aplicar fix
git commit -m "fix: [ROTAZ-999] <descrição do fix>"

# 3. Merge em rotaz/main
git checkout rotaz/main
git merge --no-ff hotfix/ROTAZ-999

# 4. Tag de hotfix
git tag -a 4.7.0-rotaz-01.1 -m "Hotfix: ROTAZ-999"
git push origin rotaz/main 4.7.0-rotaz-01.1

# 5. Deletar branch de hotfix
git branch -d hotfix/ROTAZ-999
```

---

## Checklist de Release

```
[ ] CI verde (build-dim.yml passou na última execução)
[ ] Security scan sem CRITICAL (security-scan.yml)
[ ] ROTAZ_CHANGELOG.md atualizado
[ ] Tag criada e pushed
[ ] Build DIM executado com a nova tag
[ ] PDCA registrado (dim-image-mgr.sh register + elect)
[ ] GitHub Release criado (se aplicável)
[ ] Equipe notificada no Slack #rotaz-apim-fork
```

---

## Referências

- [ROTAZ_CHANGELOG.md](../ROTAZ_CHANGELOG.md) — histórico de releases
- [ROTAZ_CUSTOMIZATIONS.md](../ROTAZ_CUSTOMIZATIONS.md) — o que mudou vs. upstream
- [docs/SYNC_PROCESS.md](./SYNC_PROCESS.md) — sincronização com upstream antes do release
- [dim-builder/ci-cd/scripts/](https://github.com/rotaz-software/dim-builder/tree/main/ci-cd/scripts) — scripts de build e PDCA