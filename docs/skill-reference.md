# Skill Reference

> Bu dosya gerektiğinde referans amaçlıdır. Session'da otomatik yüklenmez.

---

## SuperClaude (sc:*) - Temel Komutlar

| Kullanıcı Ne Diyor | Skill | Tracking |
|--------------------|-------|----------|
| hata, çalışmıyor, bozuk, fix | `/sc:troubleshoot` | TodoWrite |
| ekle, yap, oluştur, implement | `/sc:implement` | TodoWrite |
| test, coverage, spec | `/sc:test` | TodoWrite |
| analiz, incele, bak, nasıl | `/sc:analyze` | - |
| commit, push, branch, PR | `/sc:git` | - |
| refactor, temizle, iyileştir | `/sc:improve` | TodoWrite |
| güvenlik, security, vulnerability | `/sc:analyze` | TodoWrite |
| dokümantasyon, README, açıkla | `/sc:document` | - |
| tasarım, mimari, design | `/sc:design` | TodoWrite |
| brainstorm, düşünelim, tartışalım | `/sc:brainstorm` | - |
| build, derle, package | `/sc:build` | - |
| temizle, dead code, cleanup | `/sc:cleanup` | TodoWrite |
| araştır, bul, research | `/sc:research` | - |
| tahmin, estimate, ne kadar sürer | `/sc:estimate` | - |
| workflow, PRD, akış | `/sc:workflow` | TodoWrite |

---

## SuperClaude (sc:*) - Özel Komutlar

| Komut | Açıklama |
|-------|----------|
| `/sc:help` | Tüm komutları listele |
| `/sc:spawn` | Meta-system task orchestration |
| `/sc:task` | Kompleks task yürütme |
| `/sc:index` | Proje dokümantasyonu oluştur |
| `/sc:select-tool` | Akıllı MCP tool seçimi |
| `/sc:recommend` | Uygun komut önerisi |
| `/sc:agent` | Agent yönetimi |
| `/sc:load` / `/sc:save` | Session lifecycle management |
| `/sc:reflect` | Task reflection ve validation |
| `/sc:spec-panel` | Multi-expert specification review |
| `/sc:business-panel` | Business strategy experts panel |
| `/sc:index-repo` | Repository indexing (%94 token azaltma) |
| `/sc:explain` | Kod/kavram açıklama |

---

## Superpowers (Claude Invoke Etmeli)

> **NOT:** Bu skill'ler "otomatik" DEĞİL - Claude tetikleyici durumu algıladığında Skill tool ile INVOKE ETMELİ. "Otomatik" ifadesi sadece "manuel kullanıcı talebi olmadan" anlamındadır.

| Tetikleyici | Skill | Ne Yapar |
|-------------|-------|----------|
| Feature baslangici | `brainstorming` | Socratic design discovery |
| Bug fix | `systematic-debugging` | 4-fazli root cause analysis |
| Test yazimi | `test-driven-development` | RED-GREEN-REFACTOR dongusu |
| Is bitiminde | `verification-before-completion` | Gercekten calisiyor mu? |
| Multi-step task | `writing-plans` → `executing-plans` | Checkpoint'li execution |
| PR oncesi | `requesting-code-review` | Pre-review checklist |
| PR feedback | `receiving-code-review` | Feedback response workflow |
| Parallel work | `using-git-worktrees` | Izole branch'ler |
| Subagent gerek | `dispatching-parallel-agents` | Concurrent workflows |
| Skill yazma | `writing-skills` | Yeni skill olusturma |

---

## Superclaude Agents (superclaude:*)

| Agent | Kullanim Alani |
|-------|----------------|
| `superclaude:backend-architect` | Backend sistem tasarimi |
| `superclaude:frontend-architect` | UI/UX, erisilebilirlik |
| `superclaude:system-architect` | Scalable mimari tasarim |
| `superclaude:devops-architect` | CI/CD, infrastructure |
| `superclaude:security-engineer` | Guvenlik, compliance |
| `superclaude:performance-engineer` | Performans optimizasyonu |
| `superclaude:quality-engineer` | Test stratejileri |
| `superclaude:refactoring-expert` | Kod kalitesi, tech debt |
| `superclaude:python-expert` | Python best practices |
| `superclaude:technical-writer` | Teknik dokumantasyon |
| `superclaude:learning-guide` | Ogretim, aciklama |
| `superclaude:requirements-analyst` | Gereksinim analizi |
| `superclaude:root-cause-analyst` | Problem analizi |
| `superclaude:deep-research-agent` | Arastirma |
| `superclaude:socratic-mentor` | Egitim, Socratic method |
| `superclaude:business-panel-experts` | Is stratejisi paneli |
| `superclaude:self-review` | Post-implementation review |
| `superclaude:pm-agent` | Proje yonetimi |
| `superclaude:repo-index` | Codebase indexleme |

---

## Security Scanning (security-scanning:*)

| Skill | Kullanim |
|-------|----------|
| `security-scanning:security-sast` | Static code analysis |
| `security-scanning:attack-tree-construction` | Threat path mapping |
| `security-scanning:sast-configuration` | SAST tool setup |
| `security-scanning:security-requirement-extraction` | Security requirements |
| `security-scanning:stride-analysis-patterns` | STRIDE methodology |
| `security-scanning:threat-mitigation-mapping` | Threat → Control mapping |

---

## Backend Development (backend-development:*)

| Skill | Kullanim |
|-------|----------|
| `backend-development:api-design-principles` | REST/GraphQL API design |
| `backend-development:architecture-patterns` | Clean/Hexagonal/DDD |
| `backend-development:microservices-patterns` | Microservices design |
| `backend-development:cqrs-implementation` | CQRS pattern |
| `backend-development:event-store-design` | Event sourcing |
| `backend-development:projection-patterns` | Read model projections |
| `backend-development:saga-orchestration` | Distributed transactions |
| `backend-development:temporal-python-testing` | Temporal workflow testing |
| `backend-development:workflow-orchestration-patterns` | Workflow design |

---

## Code Review & Quality

| Skill | Kullanim |
|-------|----------|
| `code-review:code-review` | PR code review |
| `superpowers:code-reviewer` | Code review agent |
| `codebase-cleanup:code-reviewer` | Code quality review |
| `codebase-cleanup:test-automator` | Test automation |
| `code-refactoring:code-reviewer` | Refactoring review |
| `code-refactoring:legacy-modernizer` | Legacy code update |

---

## JVM Languages

| Skill | Kullanim |
|-------|----------|
| `jvm-languages:java-pro` | Java 21+, Spring Boot 3.x |
| `jvm-languages:scala-pro` | Scala, Akka, ZIO |
| `jvm-languages:csharp-pro` | C#, .NET |

---

## Planning & Workflow

| Skill | Kullanim |
|-------|----------|
| `planning-with-files:planning-with-files` | Manus-style file planning |
| `superpowers:writing-plans` | Plan olusturma |
| `superpowers:executing-plans` | Plan execution |

---

## Intent → Tool Karar Mantigi

### Ayni Kelime, Farkli Intent

| Prompt | Kelime | Gercek Intent | Dogru Tool |
|--------|--------|---------------|------------|
| "Sayfada hata var" | hata | UI debug | chrome-devtools |
| "Bu metotta hata var" | hata | Kod analizi | serena |
| "Hata mesajlarini standartlastir" | hata | Refactoring | plan + serena |
| "Hata loglama nasil calisiyor?" | hata | Gecmis context | serena memories |

| Prompt | Kelime | Gercek Intent | Dogru Tool |
|--------|--------|---------------|------------|
| "Projeyi analiz et" | analiz | Genel yapi | repomix |
| "Bu sinifi analiz et" | analiz | Tek sembol | serena |
| "Network trafigini analiz et" | analiz | Browser debug | chrome-devtools |
| "Tablo yapisini analiz et" | analiz | DB sema | dbhub |

### Intent Belirleme Sorulari

```
1. KAPSAM: Tek dosya/sembol mu, proje geneli mi?
   └─ Tek → serena | Genis → repomix

2. DOMAIN: Kod mu, UI mu, DB mi, harici library mi?
   └─ Kod → serena/repomix | UI → chrome-devtools | DB → dbhub | Library → git-mcp

3. AMAC: Okuma mi, yazma mi, debug mu?
   └─ Debug → chrome-devtools/logs | Okuma → serena | Yazma → serena + plan

4. CONTEXT: Gecmise mi bakiyor, simdiki duruma mi?
   └─ Gecmis → serena memories + claude-mem | Simdi → diger tool'lar
```

### Anti-Pattern: Kelime Eslestirmesi

```
❌ YANLIS (Kelime bazli)
"hata" kelimesi var → /sc:troubleshoot

✅ DOGRU (Intent bazli)
"Sayfada hata var" → UI sorunu → chrome-devtools
"Kodda hata var" → Kod analizi → serena → /sc:troubleshoot
"Hata yonetimini degistir" → Refactoring → plan + serena
```
