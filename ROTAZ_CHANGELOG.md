# Rotaz Evolution Changelog

All notable changes to the Rotaz fork of WSO2 product-apim are documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Versioning: `<WSO2-VERSION>-rotaz-<PATCH>` (e.g. `4.7.0-rotaz-01`)

---

## [Unreleased]

### Infrastructure
- Added `.github/workflows/sync-upstream.yml` — weekly auto-sync with WSO2 upstream (Mondays 06:00 UTC)
- Added `.github/workflows/build-dim.yml` — Maven build + test CI on `rotaz/**` branches and PRs
- Added `.github/workflows/security-scan.yml` — Trivy vulnerability scan (Mondays 08:00 UTC + push)
- Added `ROTAZ_CUSTOMIZATIONS.md` — customization catalog and merge conflict playbook
- Added `ROTAZ_CHANGELOG.md` — this file
- Added `ROTAZ_ROADMAP.md` — planned customizations roadmap
- Added `ROTAZ_SECURITY.md` — security patch policy

### Infrastructure
- Added `rotaz/scripts/prepare-sync.sh` — pre-sync validation script
- Added `rotaz/scripts/sync-merge.sh` — upstream merge script
- Added `rotaz/scripts/verify-sync.sh` — post-sync build/test/security validation

### Upstream Sync
- Fork base: WSO2/product-apim `master` branch (May 2026)
- Default branch set to `rotaz/main`
- [2026-05-09] First sync with upstream WSO2 (upstream/master @ 6ffbcdb77d) — clean, 0 conflicts

---

## [4.7.0-rotaz-01] — 2026-05-09

### Initial Setup
- Fork created from `wso2/product-apim`
- Branch `rotaz/main` created as Rotaz customization base
- GitHub Actions CI/CD pipelines configured
- Rotaz documentation files initialized