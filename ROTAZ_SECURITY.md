# ROTAZ Security Policy

Política de segurança para o fork Rotaz do WSO2 product-apim.

---

## Reportar Vulnerabilidades

Vulnerabilidades de segurança devem ser reportadas **em privado** via:
- Email: security@rotaz.app.br
- **Não abrir issues públicas** para vulnerabilidades não divulgadas

---

## Fontes de Monitoramento

| Fonte | Frequência | Responsável |
|-------|-----------|-------------|
| [WSO2 Security Advisories](https://wso2.com/security) | Semanal | DevOps |
| GitHub Dependabot alerts | Automático | CI/CD |
| Trivy scan (`security-scan.yml`) | Segunda-feira 08:00 UTC | CI/CD |
| CVE databases (NVD, OSV) | Semanal | DevOps |

---

## Processo de Aplicação de Security Patches

### 1. Classificação de Severidade

| Severidade | SLA de Aplicação | Processo |
|-----------|-----------------|---------|
| 🔴 CRÍTICO (CVSS ≥ 9.0) | 24 horas | Patch direto em `rotaz/main` + release imediato |
| 🟠 ALTO (CVSS 7.0–8.9) | 72 horas | Branch `rotaz/security-<CVE>` + PR urgente |
| 🟡 MÉDIO (CVSS 4.0–6.9) | 1 semana | Branch normal + PR com review padrão |
| 🟢 BAIXO (CVSS < 4.0) | Próximo release | Incluir no ciclo normal de desenvolvimento |

### 2. Patch de Vulnerabilidade Upstream (WSO2)

```bash
# 1. Verificar advisory WSO2
# https://wso2.com/security/vulnerability-reports/

# 2. Criar branch de patch
git checkout rotaz/main
git checkout -b rotaz/security-<CVE-ID>

# 3. Aplicar patch (cherry-pick do upstream ou manual)
git fetch upstream
git cherry-pick <upstream-commit-hash>
# ou aplicar manualmente se houver conflitos

# 4. Testar
mvn clean install -DskipTests -q --file all-in-one-apim/pom.xml

# 5. Atualizar documentação
# - ROTAZ_CHANGELOG.md: adicionar entry em ### Security
# - ROTAZ_CUSTOMIZATIONS.md: documentar se patch modifica arquivos customizados

# 6. PR com label 'security' e review prioritário
gh pr create --label security --title "security: apply <CVE-ID> patch"
```

### 3. Patch de Dependência (Maven)

```bash
# 1. Identificar dependência vulnerável (via Trivy ou Dependabot)
# 2. Atualizar versão no pom.xml relevante
# 3. Verificar compatibilidade com outras dependências
mvn dependency:tree | grep <artifact-id>

# 4. Build + teste mínimo
mvn clean install -DskipTests -q --file all-in-one-apim/pom.xml

# 5. Documentar em ROTAZ_CHANGELOG.md
```

---

## Scan de Vulnerabilidades (Trivy)

O workflow `security-scan.yml` executa automaticamente:
- **Toda segunda-feira às 08:00 UTC** (schedule)
- **A cada push em `rotaz/main`** (trigger)

Resultados são enviados para a aba **Security → Code Scanning** do repositório.

Para executar localmente:
```bash
trivy fs . \
  --severity CRITICAL,HIGH \
  --scanners vuln \
  --skip-dirs all-in-one-apim,target \
  --offline-scan
```

---

## Versioning de Security Releases

Security patches geram um novo patch version:
```
4.7.0-rotaz-01  →  (patch CVE-2026-XXXX)  →  4.7.0-rotaz-02
```

Tag imediatamente após merge:
```bash
git tag -a 4.7.0-rotaz-02 -m "security: CVE-2026-XXXX patch"
git push origin 4.7.0-rotaz-02
```

---

## Referências

- [WSO2 Security Vulnerability Reports](https://wso2.com/security/vulnerability-reports/)
- [ROTAZ_CUSTOMIZATIONS.md](./ROTAZ_CUSTOMIZATIONS.md) — arquivos modificados (risco de conflito ao aplicar patches)
- [ROTAZ_CHANGELOG.md](./ROTAZ_CHANGELOG.md) — histórico de patches aplicados
- [FORK_STRATEGY.md — Merge Conflict Playbook](https://github.com/rotaz-software/dim-builder/blob/main/docs/FORK_STRATEGY.md#merge-conflict-playbook)