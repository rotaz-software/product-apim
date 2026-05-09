# ROTAZ Customizations Catalog

## Overview

Catálogo de todas as customizações Rotaz aplicadas ao fork WSO2 product-apim.
Use como guia em merge conflicts, versioning e feature tracking.

Ao mergear um novo feature branch, atualizar este arquivo:
1. Adicionar entrada na tabela de customizações ativas
2. Criar seção detalhada com risk assessment
3. Commit junto ao merge: `docs: add [CATEGORIA] <nome> to customizations catalog`

---

## Customizações Ativas

| ID | Categoria | Status | Branch | Risco de Conflito |
|----|-----------|--------|--------|-------------------|
| ROT-001 | INFRA | ✅ ACTIVE | `rotaz/main` | ✅ LOW |
| ROT-002 | INFRA | ✅ ACTIVE | `rotaz/main` | ✅ LOW |
| ROT-003 | INFRA | ✅ ACTIVE | `rotaz/main` | ✅ LOW |

---

## Customizações Detalhadas

### [INFRA] CI/CD Pipelines (ROT-001)

**Status:** ✅ ACTIVE
**Branch:** `rotaz/main`
**Files Modified:** 3
- `.github/workflows/sync-upstream.yml`
- `.github/workflows/build-dim.yml`
- `.github/workflows/security-scan.yml`
**Version:** 1.0

**Description:**
Pipelines de CI/CD Rotaz: sync semanal com upstream, build Maven, Trivy security scan.

**Upstream Conflict Risk:** ✅ LOW
- WSO2 não mantém esses workflows — sem risco de conflito.

---

### [INFRA] Rotaz Documentation (ROT-002)

**Status:** ✅ ACTIVE
**Branch:** `rotaz/main`
**Files Modified:** 4
- `ROTAZ_CUSTOMIZATIONS.md`
- `ROTAZ_CHANGELOG.md`
- `ROTAZ_ROADMAP.md`
- `ROTAZ_SECURITY.md`
**Version:** 1.0

**Description:**
Documentação de governança do fork: catálogo de customizações, changelog, roadmap e política de segurança.

**Upstream Conflict Risk:** ✅ LOW
- Arquivos exclusivos Rotaz — WSO2 não os possui.

---

### [INFRA] Sync Scripts (ROT-003)

**Status:** ✅ ACTIVE
**Branch:** `rotaz/main`
**Files Modified:** 3
- `rotaz/scripts/prepare-sync.sh`
- `rotaz/scripts/sync-merge.sh`
- `rotaz/scripts/verify-sync.sh`
**Version:** 1.0

**Description:**
Scripts manuais para executar e validar o ciclo de sync com o upstream WSO2.

**Upstream Conflict Risk:** ✅ LOW
- Diretório `rotaz/` exclusivo Rotaz — sem risco de conflito upstream.

---

## Template de Entrada

### [CATEGORIA] Nome da Customização

**Status:** ⏳ PLANNED / 🔄 IN PROGRESS / ✅ ACTIVE / ❌ DEPRECATED
**Branch:** rotaz/\<nome\>
**Files Modified:** N
**Version:** 1.0

**Description:**
Descrição da customização.

**Upstream Conflict Risk:** ✅ LOW / ⚠️ MEDIUM / 🔴 HIGH
- Cenário de conflito possível
- Como resolver

**When Syncing:**
```bash
# Instrução de resolução
```

---

## Merge Conflict Playbook

### Scenario 1: pom.xml Conflict

```
<<<<<< HEAD (rotaz/main)
<dependency>
    <groupId>com.zaxxer</groupId>
    <artifactId>HikariCP</artifactId>
    <version>5.0.1</version>  # Rotaz version
</dependency>
=======
<dependency>
    <groupId>com.zaxxer</groupId>
    <artifactId>HikariCP</artifactId>
    <version>5.0.0</version>  # WSO2 version
</dependency>
>>>>>> upstream/main
```

**Resolution:** Preserve Rotaz version (newer, tested). Document the decision here.

### Scenario 2: deployment.toml Conflict

**Action:** Preserve BOTH sections — WSO2 base config AND Rotaz customizations.
Mark Rotaz sections with `# ROTAZ:` comment for easy future identification.

### Scenario 3: Dockerfile Conflict

**Action:** Keep Rotaz base image and build steps. Incorporate upstream security patches manually.

---

## Version Management

### Format

```
<WSO2-VERSION>-rotaz-<PATCH>

Examples:
4.7.0-rotaz-01  ← First patch release
4.7.0-rotaz-02  ← Second patch release
4.7.1-rotaz-01  ← First release of 4.7.1 base
```

### Tagging

```bash
git tag -a 4.7.0-rotaz-01 -m "Release: <description>"
git push origin 4.7.0-rotaz-01
```

---

## Contribution Guidelines

- All changes require PR review (2+ approvals)
- Features em branches separados (`rotaz/<feature>` ou `dim/<feature>`)
- Document customizations neste arquivo antes de mergear
- Update `ROTAZ_CHANGELOG.md` junto ao merge commit
- Run full test suite before merge (`build-dim` CI must pass)