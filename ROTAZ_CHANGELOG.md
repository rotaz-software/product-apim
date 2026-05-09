# Rotaz Evolution Changelog

All notable changes to the Rotaz fork of WSO2 product-apim are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Versioning: `<WSO2-VERSION>-rotaz-<PATCH>` (e.g. `4.7.0-rotaz-01`)

---

## [Unreleased]

### Infrastructure
- `sync-upstream.yml` melhorado: GitHub Job Summary com métricas, Slack notification (opcional via `SLACK_WEBHOOK_URL` secret), conflict issue link atualizado para `docs/MERGE_CONFLICTS.md`
- Issues habilitadas em `rotaz-software/product-apim` (necessário para issues `sync-conflict`)

---

## [4.7.0-rotaz-01] — 2026-05-09

### Infrastructure
- Fork criado a partir de `wso2/product-apim` (upstream/master @ `6ffbcdb77d`)
- Branch `rotaz/main` criado como base de desenvolvimento Rotaz
- Default branch alterado de `master` para `rotaz/main`
- `.github/workflows/sync-upstream.yml` — sync semanal automático com upstream (segundas 06:00 UTC)
- `.github/workflows/build-dim.yml` — Maven build + test CI em pushes `rotaz/**` e PRs
- `.github/workflows/security-scan.yml` — Trivy vuln scan (segundas 08:00 UTC + push em `rotaz/main`)
- `.github/workflows/release.yml` — release automático ao criar tag `*-rotaz-*`
- `ROTAZ_CUSTOMIZATIONS.md` — catálogo de customizações (ROT-001/002/003) com risk assessment
- `ROTAZ_CHANGELOG.md` — este arquivo
- `ROTAZ_ROADMAP.md` — roadmap Q3/Q4 2026 (DB Query Caching, JWT Claims, Connection Pool, etc.)
- `ROTAZ_SECURITY.md` — política de patches por severidade (SLA 24h para CRITICAL)
- `docs/MERGE_CONFLICTS.md` — playbook com 4 cenários validados por simulação real
- `docs/SYNC_PROCESS.md` — guia completo de sincronização automática e manual
- `docs/RELEASE_PROCESS.md` — guia de versionamento, release checklist, hotfix flow
- `rotaz/scripts/prepare-sync.sh` — validação pré-sync
- `rotaz/scripts/sync-merge.sh` — merge upstream com detecção de conflitos
- `rotaz/scripts/verify-sync.sh` — build + testes + Trivy + atualização automática do changelog

### Upstream Sync
- [2026-05-09] Primeiro sync com upstream WSO2 — upstream/master @ `6ffbcdb77d` — clean, 0 conflitos
- Resolução de conflitos testada e documentada (cenários pom.xml e deployment.toml)

### Security
- Trivy security scan configurado — SARIF upload para GitHub Security tab
- `sync-conflict` label criada para issues automáticas em caso de conflito de merge