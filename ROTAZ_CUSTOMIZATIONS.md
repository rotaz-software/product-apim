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
| — | — | — | — | — |

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