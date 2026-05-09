---
name: Sync Conflict
about: Conflito detectado durante sync automático com upstream WSO2
labels: sync-conflict
assignees: ''
---

## Conflito detectado

<!-- Data e run do GitHub Actions que detectou o conflito -->
- **Data:** 
- **Run:** <!-- link para o Actions run -->
- **upstream/master @:** <!-- short commit hash -->

## Arquivo(s) em conflito

```
<!-- Output de: git diff --name-only --diff-filter=U -->
```

## Customizações Rotaz envolvidas

<!-- Consultar ROTAZ_CUSTOMIZATIONS.md — listar IDs e risk level das customizações nos arquivos em conflito -->

| ID | Customização | Risk level |
|----|-------------|------------|
|    |             |            |

## Análise do conflito

### O que o upstream mudou
<!-- Descrever a mudança upstream que causou o conflito -->

### O que Rotaz tem customizado
<!-- Descrever a customização Rotaz no mesmo trecho -->

## Resolução proposta

<!-- Como resolver — seguir docs/MERGE_CONFLICTS.md para o cenário -->

```bash
cd /projects/rotaz/repos/product-apim
git fetch upstream master
git checkout rotaz/main
git merge upstream/master
# Resolver conflitos em <arquivo(s)>
# Estratégia: --ours / --theirs / manual
git add .
git commit -m "fix: resolve merge conflict in <arquivo> [sync YYYY-MM-DD]"
git push origin rotaz/main
```

## Checklist de resolução

- [ ] Conflito analisado com `ROTAZ_CUSTOMIZATIONS.md`
- [ ] Estratégia de resolução definida
- [ ] Conflito resolvido localmente e testado
- [ ] `ROTAZ_CHANGELOG.md` atualizado com nota do conflito
- [ ] Push realizado para `rotaz/main`
- [ ] Esta issue fechada

## Referências

- [docs/MERGE_CONFLICTS.md](../blob/rotaz/main/docs/MERGE_CONFLICTS.md)
- [ROTAZ_CUSTOMIZATIONS.md](../blob/rotaz/main/ROTAZ_CUSTOMIZATIONS.md)