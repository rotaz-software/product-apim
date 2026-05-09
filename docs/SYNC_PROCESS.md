# Processo de Sincronização com Upstream WSO2

Guia completo para manter `rotaz/main` sincronizado com `wso2/product-apim`.

---

## Frequência

| Tipo | Quando | Como |
|------|--------|------|
| **Automática** | Toda segunda-feira às 06:00 UTC | `sync-upstream.yml` (GitHub Actions) |
| **Manual agendada** | Após upstream release de segurança | `workflow_dispatch` no GitHub Actions UI |
| **Manual local** | Quando necessário | Scripts `rotaz/scripts/` |

---

## Sincronização Automática (GitHub Actions)

O workflow `.github/workflows/sync-upstream.yml` executa toda segunda-feira:

1. Faz checkout de `rotaz/main`
2. Adiciona `upstream` remoto (`wso2/product-apim`)
3. Faz fetch de `upstream/master`
4. Tenta merge automático
5. **Se limpo:** push para `origin rotaz/main`
6. **Se conflito:** abre issue com label `sync-conflict`

**Monitorar:** [Actions → Sync Upstream WSO2](https://github.com/rotaz-software/product-apim/actions/workflows/sync-upstream.yml)

**Forçar execução manual:** Actions → Sync Upstream WSO2 → Run workflow

---

## Sincronização Manual (local)

### Pré-requisitos

```bash
# Verificar remotes configurados
git remote -v
# origin    git@github.com-rotaz:rotaz-software/product-apim.git
# upstream  https://github.com/wso2/product-apim.git

# Se upstream não estiver configurado:
git remote add upstream https://github.com/wso2/product-apim.git
```

### Passo a Passo

**1. Preparar**

```bash
cd /projects/rotaz/repos/product-apim
bash rotaz/scripts/prepare-sync.sh
```

Verifica working tree limpa, fetcha `upstream/master`, exibe quantos commits serão incorporados.

**2. Mergear**

```bash
bash rotaz/scripts/sync-merge.sh
```

- Sem conflitos → merge + push automático ✅
- Com conflitos → lista arquivos conflitantes, aguarda resolução manual

**3. Resolver conflitos (se houver)**

```bash
# Ver arquivos com conflito
git diff --name-only --diff-filter=U

# Para cada arquivo, seguir guia em docs/MERGE_CONFLICTS.md
# Após resolver todos:
git add .
git commit -m "fix: resolve merge conflicts from upstream sync $(date +%Y-%m-%d)"
git push origin rotaz/main
```

Consulte sempre `ROTAZ_CUSTOMIZATIONS.md` para o risk assessment do arquivo antes de resolver.

**4. Verificar**

```bash
bash rotaz/scripts/verify-sync.sh
```

Roda build (`mvn clean install -DskipTests`), testes, Trivy scan local e registra o sync em `ROTAZ_CHANGELOG.md`.

> O build completo do WSO2 APIM leva múltiplas horas. O CI (`build-dim.yml`) executa automaticamente após o push e serve como validação de build/testes.

**5. Atualizar changelog (se verify-sync.sh não fez automaticamente)**

Adicionar entrada em `ROTAZ_CHANGELOG.md`:

```markdown
### Upstream Sync
- [YYYY-MM-DD] Sync com upstream WSO2 (upstream/master @ <short-hash>) — <N> conflitos / limpo
```

---

## Cenários de Conflito

### Issue `sync-conflict` aberta automaticamente

Quando o GitHub Actions detecta conflito, uma issue é aberta em `rotaz-software/product-apim` com label `sync-conflict`. Processo:

1. Clonar `rotaz/main` localmente (ou `git pull`)
2. Executar manualmente `rotaz/scripts/sync-merge.sh`
3. Resolver conflitos seguindo `docs/MERGE_CONFLICTS.md`
4. Push
5. Fechar a issue de conflito

### Conflito Desconhecido / Alto Risco

Se o arquivo em conflito tiver risk level 🔴 HIGH em `ROTAZ_CUSTOMIZATIONS.md`:

- Não resolver sozinho
- Abrir discussão no Slack `#rotaz-apim-fork`
- Aguardar review com 2 approvals antes de mergear

---

## Verificar Estado de Sincronização

```bash
# Quantos commits upstream não estão em rotaz/main?
git fetch upstream master
git log --oneline rotaz/main..upstream/master | wc -l

# Ver os commits pendentes
git log --oneline rotaz/main..upstream/master | head -20

# Ver divergências (commits apenas em rotaz/main, não no upstream)
git log --oneline upstream/master..rotaz/main
```

---

## Referências

- [sync-upstream.yml](../.github/workflows/sync-upstream.yml) — workflow de sync automático
- [rotaz/scripts/prepare-sync.sh](../rotaz/scripts/prepare-sync.sh)
- [rotaz/scripts/sync-merge.sh](../rotaz/scripts/sync-merge.sh)
- [rotaz/scripts/verify-sync.sh](../rotaz/scripts/verify-sync.sh)
- [docs/MERGE_CONFLICTS.md](./MERGE_CONFLICTS.md) — playbook de resolução de conflitos
- [ROTAZ_CUSTOMIZATIONS.md](../ROTAZ_CUSTOMIZATIONS.md) — risk assessment por arquivo
- [ROTAZ_CHANGELOG.md](../ROTAZ_CHANGELOG.md) — histórico de syncs