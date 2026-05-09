# Merge Conflict Resolution Playbook

Guia prático para resolver conflitos ao sincronizar `rotaz/main` com `upstream/master`.

Valide sempre em `ROTAZ_CUSTOMIZATIONS.md` o risk assessment do arquivo em conflito antes de resolver.

---

## Diagnóstico Rápido

```bash
# Listar arquivos em conflito
git diff --name-only --diff-filter=U

# Para cada arquivo conflitante, consultar risk level documentado:
grep -i "<nome-do-arquivo>" ROTAZ_CUSTOMIZATIONS.md
```

---

## Cenário 1 — Dependência em `pom.xml`

**Situação:** WSO2 upstream atualiza uma dependência que Rotaz já personalizou.

**Sintoma:**
```
Auto-merging pom.xml
CONFLICT (content): Merge conflict in pom.xml
```

**Exemplo real (simulado e validado em 2026-05-09):**
```xml
<<<<<<< HEAD (rotaz/main)
<version>2.6-rotaz</version>   ← Versão Rotaz (testada em produção)
=======
<version>2.6</version>          ← Versão WSO2 upstream
>>>>>>> upstream/master
```

**Estratégia:** Manter versão Rotaz se mais recente ou testada; manter WSO2 se upstream for security patch.

```bash
# Opção A — Manter versão Rotaz (mais comum)
git checkout --ours pom.xml
git add pom.xml

# Opção B — Manter versão upstream (security patch ou breaking change)
git checkout --theirs pom.xml
git add pom.xml

# Opção C — Editar manualmente (versões muito diferentes, requer análise)
# Editar o arquivo, resolver marcadores <<<<< ===== >>>>>, então:
git add pom.xml
```

**Regra de decisão:**

| Situação | Ação |
|----------|------|
| Rotaz tem versão mais recente | `--ours` |
| Upstream corrige CVE | `--theirs` (depois testar) |
| Versões incompatíveis | Editar manualmente + testar build |

**Commit de resolução:**
```bash
git commit -m "fix: resolve pom.xml conflict — keep Rotaz <artifact> <version> over upstream <version> [sync $(date +%Y-%m-%d)]"
```

---

## Cenário 2 — Configuração em `deployment.toml`

**Situação:** WSO2 adiciona/altera opções de configuração no mesmo arquivo onde Rotaz tem customizações.

**Sintoma:**
```
Auto-merging deployment.toml
CONFLICT (content): Merge conflict in deployment.toml
```

**Exemplo real (simulado e validado em 2026-05-09):**
```toml
[database.database_1]
type = "mysql"
url = "jdbc:mysql://localhost:3306/regdb"
username = "regadmin"
password = "regadmin"
<<<<<<< HEAD
# ROTAZ: connection pool customizations
hikari.maximum_pool_size = 25
hikari.minimum_idle = 10
hikari.connection_timeout = 30000
=======
defaultAutoCommit = false
testOnBorrow = true
>>>>>>> upstream/master
```

**Estratégia:** Preservar **ambas** as seções — configurações WSO2 + customizações Rotaz.

```toml
# Resultado correto após resolução:
[database.database_1]
type = "mysql"
url = "jdbc:mysql://localhost:3306/regdb"
username = "regadmin"
password = "regadmin"
# WSO2: upstream additions — KEEP
defaultAutoCommit = false
testOnBorrow = true

# ROTAZ: connection pool customizations — KEEP
hikari.maximum_pool_size = 25
hikari.minimum_idle = 10
hikari.connection_timeout = 30000
```

**Passos:**
```bash
# 1. Abrir o arquivo e remover marcadores de conflito manualmente
# 2. Preservar ambas as seções (WSO2 primeiro, depois # ROTAZ:)
# 3. Marcar seções Rotaz com comentário '# ROTAZ:' para identificação futura
git add deployment.toml
git commit -m "fix: resolve deployment.toml conflict — preserve WSO2 base + Rotaz HikariCP config [sync $(date +%Y-%m-%d)]"
```

---

## Cenário 3 — Dockerfile

**Situação:** WSO2 muda base image ou build steps; Rotaz tem sua própria base image.

**Estratégia:** Manter base image Rotaz; incorporar manualmente as mudanças de build steps do upstream.

```bash
# 1. Ver o que WSO2 mudou
git diff upstream/master -- Dockerfile

# 2. Resolver manualmente — manter FROM Rotaz, incorporar novos RUN/COPY relevantes
git add Dockerfile
git commit -m "fix: resolve Dockerfile conflict — keep Rotaz base, incorporate upstream build steps [sync $(date +%Y-%m-%d)]"
```

---

## Cenário 4 — Arquivo novo no upstream (sem conflito de conteúdo)

**Situação:** WSO2 adiciona um arquivo novo que não existe em `rotaz/main`. Git aceita automaticamente — sem ação necessária.

**Verificar:** Se o arquivo novo do upstream colide funcionalmente com alguma customização Rotaz, documentar em `ROTAZ_CUSTOMIZATIONS.md`.

---

## Fluxo Completo de Resolução

```bash
# 1. Identificar todos os conflitos
git diff --name-only --diff-filter=U

# 2. Para cada arquivo:
#    a. Consultar ROTAZ_CUSTOMIZATIONS.md para o risk assessment
#    b. Aplicar estratégia do cenário correspondente
#    c. git add <arquivo>

# 3. Verificar que nenhum marcador de conflito ficou para trás
grep -r "<<<<<<" . --include="*.xml" --include="*.toml" --include="Dockerfile" --include="*.java"

# 4. Commit de resolução
git commit -m "fix: resolve merge conflicts from upstream sync $(date +%Y-%m-%d)"

# 5. Push
git push origin rotaz/main

# 6. Atualizar ROTAZ_CHANGELOG.md com nota sobre os conflitos resolvidos
```

---

## Quando Escalar

Escalar para review do time antes de resolver se:

- Conflito em código Java customizado Rotaz (risco de regressão)
- Upstream mudou a API/interface de uma classe que Rotaz extende
- Conflito em arquivo com risk level 🔴 HIGH no `ROTAZ_CUSTOMIZATIONS.md`
- Não está claro qual versão é "correta"

Abra um issue com label `sync-conflict` e aguarde review com 2 approvals.

---

## Referências

- [ROTAZ_CUSTOMIZATIONS.md](../ROTAZ_CUSTOMIZATIONS.md) — risk assessment por customização
- [ROTAZ_CHANGELOG.md](../ROTAZ_CHANGELOG.md) — histórico de syncs e conflitos resolvidos
- [ROTAZ_SECURITY.md](../ROTAZ_SECURITY.md) — processo específico para security patches
- [rotaz/scripts/sync-merge.sh](../rotaz/scripts/sync-merge.sh) — script de merge automatizado
- [FORK_STRATEGY.md — Merge Conflict Playbook](https://github.com/rotaz-software/dim-builder/blob/main/docs/FORK_STRATEGY.md#merge-conflict-playbook)