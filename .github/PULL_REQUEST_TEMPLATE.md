## Descrição

<!-- Descreva a customização ou fix implementado e o motivo -->

## Tipo de mudança

- [ ] Nova customização Rotaz (`rotaz/<feature>`)
- [ ] Fix de conflito de merge com upstream WSO2
- [ ] Security patch (WSO2 advisory ou CVE)
- [ ] Update de documentação
- [ ] Infra / CI/CD

## Issues relacionadas

<!-- Fixes #NNN -->

---

## Checklist do autor

- [ ] Branch nomeado corretamente (`rotaz/<feature>`, `dim/<feature>`, ou `hotfix/<ticket>`)
- [ ] `ROTAZ_CUSTOMIZATIONS.md` atualizado com a nova customização (se aplicável)
- [ ] Risk assessment de conflito upstream avaliado e documentado
- [ ] `ROTAZ_CHANGELOG.md` atualizado na seção `[Unreleased]`
- [ ] Sem secrets, credentials ou tokens no código
- [ ] CI passando (build-dim + security-scan)

## Checklist do reviewer

- [ ] Mudança isolada — não toca código fora do escopo do PR
- [ ] Customização documentada em `ROTAZ_CUSTOMIZATIONS.md` com risk level
- [ ] Nenhuma dependência nova não-aprovada introduzida
- [ ] Código seguindo padrão WSO2 (facilita rebase no upstream)
- [ ] Build e testes verdes no CI
- [ ] Security scan sem novas vulnerabilidades CRITICAL/HIGH

## Upstream conflict risk

<!-- Descrever risco de conflito em syncs futuros com upstream/master -->
- **Risk level:** ✅ LOW / ⚠️ MEDIUM / 🔴 HIGH
- **Arquivos modificados que podem conflitar:**
- **Estratégia de resolução:**

## Testes realizados

<!-- Descrever o que foi testado e em que ambiente -->