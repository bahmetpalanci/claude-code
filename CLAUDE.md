# Global Claude Code Talimatları

---

## 🚀 UNIFIED PROMPT ROUTING SYSTEM

> **Her prompt bu sistemden geçer. ATLANMAZ.**

```
PROMPT GELDİ
     │
     ▼
┌─────────────────────────────────────────────────────────┐
│  ADIM 0: SESSION KONTROLÜ (Sadece ilk prompt)           │
│  ───────────────────────────────────────────            │
│  □ serena activate_project                              │
│  □ serena list_memories → read_memory (ilgili olanlar)  │
│  □ task_plan.md var mı? → Varsa kullanıcıya bildir      │
└─────────────────────────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────────────────────────┐
│  ADIM 1: INTENT EXTRACTION (Her prompt)                 │
│  ───────────────────────────────────────────            │
│  5 SORU:                                                │
│  1. DOMAIN: UI / DB / Kod / Harici / Orkestrasyon?      │
│  2. GÖREV: Bug / Feature / Test / Refactor / Analiz?    │
│  3. KAPSAM: Tek sembol / Çoklu dosya / Tüm proje?       │
│  4. KARMAŞIKLIK: Basit (1-2) / Orta (3-5) / Kompleks?   │
│  5. CONTEXT: Yeni iş / Devam / Geçmiş sorgu?            │
└─────────────────────────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────────────────────────┐
│  ADIM 2: MCP SEÇİMİ (Domain-based)                      │
│  ───────────────────────────────────────────            │
│  UI/Browser      → chrome-devtools                      │
│  Database        → dbhub-* (dev/stage/test)             │
│  Kod (spesifik)  → serena                               │
│  Kod (geniş)     → repomix                              │
│  Harici repo     → git-mcp                              │
│  Multi-agent     → claude-flow                          │
│  Geçmiş context  → serena memories + claude-mem         │
└─────────────────────────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────────────────────────┐
│  ADIM 3: SKILL SEÇİMİ (Task-based)                      │
│  ───────────────────────────────────────────            │
│  Bug/Hata    → systematic-debugging + /sc:troubleshoot  │
│  Feature     → brainstorming + /sc:implement            │
│  Test        → test-driven-development + /sc:test       │
│  Refactor    → /sc:improve                              │
│  Analiz      → /sc:analyze                              │
│  Kompleks    → planning-with-files + writing-plans      │
│  Security    → security-scanning:*                      │
│  Backend     → backend-development:*                    │
└─────────────────────────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────────────────────────┐
│  ADIM 4: TRACKING & PERSISTENCE                         │
│  ───────────────────────────────────────────            │
│  Her adım       → TodoWrite                             │
│  Kompleks (6+)  → task_plan.md + findings.md            │
│  Milestone      → serena write_memory                   │
└─────────────────────────────────────────────────────────┘
```

---

## 📊 ARAÇ FREKANS KURALLARI

### Session Başı (1x - İlk prompt)
| Araç | Aksiyon | Zorunlu |
|------|---------|---------|
| serena | `activate_project` | ✓ |
| serena | `list_memories` → `read_memory` | ✓ |
| task_plan.md | Kontrol et, varsa bildir | ✓ |

### Her Prompt (Sürekli)
| Kontrol | Aksiyon |
|---------|---------|
| Intent | 5 soru ile belirle |
| MCP | Domain'e göre seç |
| Skill | Task'a göre seç (aşağıdaki tablodan) |
| TodoWrite | Aktif görev varsa güncelle |

### On-Demand (Gerektiğinde)
| Araç | Tetikleyici |
|------|-------------|
| dbhub-* | DB sorgusu, şema kontrolü, veri doğrulama |
| chrome-devtools | UI hata, network sorunu, DOM analizi |
| repomix | Geniş codebase analizi, 10+ dosya refactoring |
| claude-flow | Paralel görev, multi-agent workflow |
| git-mcp | Harici library docs, GitHub repo erişimi |
| planning-with-files | 6+ adım, multi-session, araştırma |

### Milestone/Task Sonu
| Araç | Aksiyon |
|------|---------|
| serena write_memory | Ne yapıldı, hangi dosyalar değişti |
| TodoWrite | Temizle |
| task_plan.md | Status güncelle (tamamlandıysa) |

---

## 🎯 DOMAIN → MCP EŞLEŞTİRMESİ

| Domain | Keywords | MCP | İlk Tool |
|--------|----------|-----|----------|
| **UI/Browser** | sayfa, buton, form, click, network, DOM, CSS | `chrome-devtools` | `take_snapshot` |
| **Database** | tablo, kayıt, sorgu, şema, SQL, migration | `dbhub-*` | `search_objects` |
| **Kod (spesifik)** | fonksiyon, sınıf, metod, bu dosya, referans | `serena` | `find_symbol` |
| **Kod (geniş)** | proje yapısı, tüm, mimari, token, analiz | `repomix` | `--token-count-tree` |
| **Harici repo** | library, docs, API, nasıl kullanılır | `git-mcp` | `fetch_generic_documentation` |
| **Multi-agent** | paralel, agent, spawn, swarm | `claude-flow` | `agent spawn` |
| **Geçmiş** | daha önce, son session, hatırlıyor musun | `serena` + `claude-mem` | `list_memories` |

### Ortam Seçimi (dbhub)
| Ortam | MCP | Ne Zaman |
|-------|-----|----------|
| Development | `dbhub-dev` | Geliştirme, test verileri |
| Staging | `dbhub-stage` | Pre-prod, entegrasyon testi |
| Test | `dbhub-test` | Unit test DB |

---

## 🛠️ TÜM SKİLL KATEGORİLERİ

### SuperClaude (sc:*) - Temel Komutlar

| Kullanıcı Ne Diyor | Skill | Tracking |
|--------------------|-------|----------|
| "hata", "çalışmıyor", "bozuk", "fix" | `/sc:troubleshoot` | TodoWrite |
| "ekle", "yap", "oluştur", "implement" | `/sc:implement` | TodoWrite |
| "test", "coverage", "spec" | `/sc:test` | TodoWrite |
| "analiz", "incele", "bak", "nasıl" | `/sc:analyze` | - |
| "commit", "push", "branch", "PR" | `/sc:git` | - |
| "refactor", "temizle", "iyileştir" | `/sc:improve` | TodoWrite |
| "güvenlik", "security", "vulnerability" | `/sc:analyze` | TodoWrite |
| "dokümantasyon", "README", "açıkla" | `/sc:document` | - |
| "tasarım", "mimari", "design" | `/sc:design` | TodoWrite |
| "brainstorm", "düşünelim", "tartışalım" | `/sc:brainstorm` | - |
| "build", "derle", "package" | `/sc:build` | - |
| "temizle", "dead code", "cleanup" | `/sc:cleanup` | TodoWrite |
| "araştır", "bul", "research" | `/sc:research` | - |
| "tahmin", "estimate", "ne kadar sürer" | `/sc:estimate` | - |
| "workflow", "PRD", "akış" | `/sc:workflow` | TodoWrite |

### SuperClaude (sc:*) - Özel Komutlar

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

### Superpowers (Otomatik Tetiklenir)

> **NOT:** Bu skill'ler context'e göre **otomatik aktive** olur. Manuel invoke gerekmez.

| Tetikleyici | Skill | Ne Yapar |
|-------------|-------|----------|
| Feature başlangıcı | `brainstorming` | Socratic design discovery |
| Bug fix | `systematic-debugging` | 4-fazlı root cause analysis |
| Test yazımı | `test-driven-development` | RED-GREEN-REFACTOR döngüsü |
| İş bitiminde | `verification-before-completion` | Gerçekten çalışıyor mu? |
| Multi-step task | `writing-plans` → `executing-plans` | Checkpoint'li execution |
| PR öncesi | `requesting-code-review` | Pre-review checklist |
| PR feedback | `receiving-code-review` | Feedback response workflow |
| Parallel work | `using-git-worktrees` | İzole branch'ler |
| Subagent gerek | `dispatching-parallel-agents` | Concurrent workflows |
| Skill yazma | `writing-skills` | Yeni skill oluşturma |

### Superclaude Agents (superclaude:*)

| Agent | Kullanım Alanı |
|-------|----------------|
| `superclaude:backend-architect` | Backend sistem tasarımı |
| `superclaude:frontend-architect` | UI/UX, erişilebilirlik |
| `superclaude:system-architect` | Scalable mimari tasarım |
| `superclaude:devops-architect` | CI/CD, infrastructure |
| `superclaude:security-engineer` | Güvenlik, compliance |
| `superclaude:performance-engineer` | Performans optimizasyonu |
| `superclaude:quality-engineer` | Test stratejileri |
| `superclaude:refactoring-expert` | Kod kalitesi, tech debt |
| `superclaude:python-expert` | Python best practices |
| `superclaude:technical-writer` | Teknik dokümantasyon |
| `superclaude:learning-guide` | Öğretim, açıklama |
| `superclaude:requirements-analyst` | Gereksinim analizi |
| `superclaude:root-cause-analyst` | Problem analizi |
| `superclaude:deep-research-agent` | Araştırma |
| `superclaude:socratic-mentor` | Eğitim, Socratic method |
| `superclaude:business-panel-experts` | İş stratejisi paneli |
| `superclaude:self-review` | Post-implementation review |
| `superclaude:pm-agent` | Proje yönetimi |
| `superclaude:repo-index` | Codebase indexleme |

### Security Scanning (security-scanning:*)

| Skill | Kullanım |
|-------|----------|
| `security-scanning:security-sast` | Static code analysis |
| `security-scanning:attack-tree-construction` | Threat path mapping |
| `security-scanning:sast-configuration` | SAST tool setup |
| `security-scanning:security-requirement-extraction` | Security requirements |
| `security-scanning:stride-analysis-patterns` | STRIDE methodology |
| `security-scanning:threat-mitigation-mapping` | Threat → Control mapping |

### Backend Development (backend-development:*)

| Skill | Kullanım |
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

### Code Review & Quality

| Skill | Kullanım |
|-------|----------|
| `code-review:code-review` | PR code review |
| `superpowers:code-reviewer` | Code review agent |
| `codebase-cleanup:code-reviewer` | Code quality review |
| `codebase-cleanup:test-automator` | Test automation |
| `code-refactoring:code-reviewer` | Refactoring review |
| `code-refactoring:legacy-modernizer` | Legacy code update |

### JVM Languages

| Skill | Kullanım |
|-------|----------|
| `jvm-languages:java-pro` | Java 21+, Spring Boot 3.x |
| `jvm-languages:scala-pro` | Scala, Akka, ZIO |
| `jvm-languages:csharp-pro` | C#, .NET |

### Planning & Workflow

| Skill | Kullanım |
|-------|----------|
| `planning-with-files:planning-with-files` | Manus-style file planning |
| `superpowers:writing-plans` | Plan oluşturma |
| `superpowers:executing-plans` | Plan execution |

---

## 🔄 INTENT → TOOL KARAR MANTIĞI

### Aynı Kelime, Farklı Intent

| Prompt | Kelime | Gerçek Intent | Doğru Tool |
|--------|--------|---------------|------------|
| "Sayfada hata var" | hata | UI debug | chrome-devtools |
| "Bu metotta hata var" | hata | Kod analizi | serena |
| "Hata mesajlarını standartlaştır" | hata | Refactoring | plan + serena |
| "Hata loglama nasıl çalışıyor?" | hata | Geçmiş context | serena memories |

| Prompt | Kelime | Gerçek Intent | Doğru Tool |
|--------|--------|---------------|------------|
| "Projeyi analiz et" | analiz | Genel yapı | repomix |
| "Bu sınıfı analiz et" | analiz | Tek sembol | serena |
| "Network trafiğini analiz et" | analiz | Browser debug | chrome-devtools |
| "Tablo yapısını analiz et" | analiz | DB şema | dbhub |

### Intent Belirleme Soruları

```
1. KAPSAM: Tek dosya/sembol mü, proje geneli mi?
   └─ Tek → serena | Geniş → repomix

2. DOMAIN: Kod mu, UI mu, DB mi, harici library mi?
   └─ Kod → serena/repomix | UI → chrome-devtools | DB → dbhub | Library → git-mcp

3. AMAÇ: Okuma mı, yazma mı, debug mu?
   └─ Debug → chrome-devtools/logs | Okuma → serena | Yazma → serena + plan

4. CONTEXT: Geçmişe mi bakıyor, şimdiki duruma mı?
   └─ Geçmiş → serena memories + claude-mem | Şimdi → diğer tool'lar
```

### Anti-Pattern: Kelime Eşleştirmesi

```
❌ YANLIŞ (Kelime bazlı)
"hata" kelimesi var → /sc:troubleshoot

✅ DOĞRU (Intent bazlı)
"Sayfada hata var" → UI sorunu → chrome-devtools
"Kodda hata var" → Kod analizi → serena → /sc:troubleshoot
"Hata yönetimini değiştir" → Refactoring → plan + serena
```

---

## 📁 MCP KULLANIM REHBERİ

### serena (Ana Araç)
| İşlem | Tool |
|-------|------|
| Proje context | `list_memories` → `read_memory` |
| Kod arama | `find_symbol`, `search_for_pattern` |
| Refactoring | `rename_symbol`, `replace_symbol_body` |
| Kayıt | `write_memory` (milestone sonrası) |

### dbhub-* (Database)
| İşlem | Tool |
|-------|------|
| Şema keşfi | `search_objects` (table, column) |
| Sorgu | `execute_sql` |

### chrome-devtools (Frontend Debug)
| İşlem | Tool |
|-------|------|
| Sayfa analizi | `take_snapshot`, `take_screenshot` |
| Interaction | `click`, `fill`, `navigate_page` |
| Debug | `list_console_messages`, `list_network_requests` |

### git-mcp (GitHub Repo Erişimi)
| İşlem | Tool |
|-------|------|
| Repo docs | `fetch_generic_documentation` |
| Kod arama | `search_generic_code` |
| URL içerik | `fetch_generic_url_content` |

### repomix (Codebase Paketleme)
| İşlem | Komut |
|-------|-------|
| Token dağılımı | `repomix --token-count-tree` |
| Sıkıştırılmış | `repomix --compress` |
| Harici repo | `repomix --remote user/repo --compress` |
| Filtreleme | `repomix --include "src/**" --ignore "**/*.test.*"` |

### claude-flow (Multi-agent)
| İşlem | Tool |
|-------|------|
| Agent spawn | `agent spawn -t <type>` |
| Swarm init | `swarm init --v3-mode` |
| Task yönetimi | `task create`, `task list`, `task status` |

### claude-mem (Global Memory)
| İşlem | Tool |
|-------|------|
| Ara | `search` |
| Context | `timeline` |
| Detay | `get_observations` |

---

## 📋 TRACKING SİSTEMİ

### TodoWrite vs Planning Files

| Araç | Amaç | Yaşam Süresi | Ne Zaman |
|------|------|--------------|----------|
| **TodoWrite** | Anlık adım takibi | Session içi | Her görev |
| **Planning Files** | Persistent state | Session'lar arası | Kompleks görevler |

### Karmaşıklık Matrisi

| Karmaşıklık | TodoWrite | Planning Files | serena memory |
|-------------|-----------|----------------|---------------|
| Basit (1-2 adım) | ✓ | - | - |
| Orta (3-5 adım) | ✓ | Opsiyonel | Milestone sonunda |
| Kompleks (6+ adım) | ✓ | **Zorunlu** | Her milestone |
| Multi-session | ✓ | **Zorunlu** | Her session başı/sonu |

### Planning Files (Zorunlu 3 Dosya)

| Dosya | Amaç | Ne Zaman Güncelle |
|-------|------|-------------------|
| `task_plan.md` | Fazlar, ilerleme, kararlar | Her faz sonrası |
| `findings.md` | Araştırma, keşifler, notlar | Her keşif anında |
| `progress.md` | Session logu, test sonuçları | Sürekli |

---

## ⚠️ TEMEL KURALLAR

| Kural | Detay |
|-------|-------|
| Test/Build | Kullanıcı izni gerekli - sormadan çalıştırma |
| Skill | %1 ihtimal bile olsa invoke et |
| 3-Strike | 3 denemede çözemediysen → Kullanıcıya sor |
| Major karar | Birden fazla yaklaşım varsa → Kullanıcıya sor |
| Döngü önleme | 3 analyze/araştırma sonrası → Kullanıcıya sor |
| ~/.claude repo | Her değişiklik sonrası commit & push |

### Güvenlik - ASLA Commit Etme
```
.env, .env.local, .env.production
credentials.json, secrets.yaml
*_secret*, *_key*, *_token*
application-prod.yml, *.pem, *.key
```

---

## 🔧 CLI ARAÇLARI

```bash
# Maven
./mvnw compile|test|package

# Git
git status|diff|log

# Repomix
repomix --token-count-tree     # Token dağılımı
repomix --compress             # ~%70 azaltma
repomix --remote user/repo     # Harici repo

# MCP
claude mcp list|add|remove
```

---

## ❌ HATA DURUMLARI

| Hata | Aksiyon |
|------|---------|
| serena read failed | "Context bulunamadı, sıfırdan mı başlayalım?" |
| MCP disconnect | `claude mcp list` kontrol, kullanıcıya bildir |
| 3x tool failure | Durumu açıkla, alternatif öner |
| Skill bulunamadı | Closest match kullan, bildir |

---

## 📚 REFERANSLAR

- `~/.claude/docs/mcp-reference.md` - MCP detayları
- `~/.claude/docs/workflows.md` - Görev akışları
- `~/.claude/docs/troubleshooting.md` - Hata kurtarma
- `~/.claude/docs/maintenance.md` - Bakım ve güncelleme

---

## 🌐 DİL & FORMAT

- Türkçe iletişim tercih edilir
- Kod ve teknik terimler İngilizce kalabilir
- Tablo formatı kullan (okunabilirlik)
