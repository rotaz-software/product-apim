# ROTAZ Customizations Roadmap

Planejamento de customizações futuras no fork WSO2 product-apim.
Ao iniciar uma feature, mover para ROTAZ_CUSTOMIZATIONS.md e registrar em ROTAZ_CHANGELOG.md.

---

## Status Legend

| Status | Significado |
|--------|-------------|
| ⏳ PLANNED | Definido, ainda não iniciado |
| 🔄 IN PROGRESS | Branch criado, desenvolvimento ativo |
| ✅ ACTIVE | Mergeado em `rotaz/main` |
| ❌ DEPRECATED | Cancelado ou substituído |

---

## Q3 2026

### [PERFORMANCE] Database Query Caching

**Status:** ⏳ PLANNED
**Branch:** `rotaz/db-query-cache` (a criar)
**Priority:** High
**Estimated effort:** 2 semanas

**Description:**
Implementar cache de queries frequentes para reduzir carga no banco de dados.
Candidatos: Redis ou Hazelcast como backend.

**Upstream Conflict Risk:** ⚠️ MEDIUM
- Possível conflito em configurações de datasource
- Mitigação: isolar config em bloco `# ROTAZ:` em deployment.toml

---

### [SECURITY] Enhanced JWT Claims

**Status:** ⏳ PLANNED
**Branch:** `dim/security-hardening` (a criar)
**Priority:** High
**Estimated effort:** 1 semana

**Description:**
Handlers customizados para JWT com claims específicas Rotaz (tenant, roles, DIM metadata).
Usar dependency injection para minimizar risco de conflito com mudanças upstream.

**Upstream Conflict Risk:** 🔴 HIGH
- WSO2 muda JWT handling com frequência
- Mitigação: implementar via extension point, não modificar código core

---

### [PERFORMANCE] Connection Pool Tuning

**Status:** ⏳ PLANNED
**Branch:** `rotaz/db-connection-pooling` (a criar)
**Priority:** Medium
**Estimated effort:** 3 dias

**Description:**
Configuração HikariCP otimizada para ambiente de produção Rotaz.
Targets: pool size 25, connection timeout 30s, idle timeout 600s.

**Upstream Conflict Risk:** ✅ LOW
- Mudanças isoladas em deployment.toml e configuração de runtime

---

## Q4 2026

### [INFRA] Multi-tenant Isolation

**Status:** ⏳ PLANNED
**Branch:** `dim/multi-tenant` (a criar)
**Priority:** Medium

**Description:**
Isolamento de tenants por namespace no DIM. Permite múltiplos clientes
no mesmo cluster com separação de dados e configuração.

---

### [MONITORING] Custom Metrics Export

**Status:** ⏳ PLANNED
**Branch:** `rotaz/metrics-export` (a criar)
**Priority:** Low

**Description:**
Exportação de métricas customizadas Rotaz para Prometheus/Grafana.
Inclui métricas de negócio específicas do DIM PDCA.

---

## Backlog (sem data definida)

- [LOGGING] Structured logging com correlationId por request
- [SECURITY] mTLS entre microserviços internos
- [PERFORMANCE] Async processing para heavy API operations
- [INFRA] Blue/green deployment support no helm-apim

---

## Como propor uma nova customização

1. Abrir issue em `rotaz-software/dim-builder` com template `[Fase X] Feature`
2. Definir: categoria, prioridade, branch name, conflict risk
3. Após aprovação, adicionar neste roadmap com status `PLANNED`
4. Ao iniciar: criar branch, mover para `IN PROGRESS` em ROTAZ_CUSTOMIZATIONS.md