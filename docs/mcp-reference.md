# MCP & Plugin Referansı

> Bu dosya gerektiğinde referans amaçlıdır. Session'da otomatik yüklenmez.

## Hızlı Durum Kontrolü

```bash
claude mcp list              # Bağlı MCP'leri göster
claude mcp add <name> -s user -- ...  # Global MCP ekle
claude mcp add <name> -- ... # Proje bazlı MCP ekle
claude mcp remove <name>     # MCP kaldır
```

**Config Lokasyonu:** `~/.claude.json` → `mcpServers` (global) veya `projects[path].mcpServers` (proje bazlı)

---

# MCP SUNUCULARI

## serena (oraios/serena)
**Repo:** https://github.com/oraios/serena
**Durum:** ✅ Proje bazlı (proje dizininde aktif olur)

**Ne Zaman Kullan:**
- Tek sembol/metot/sınıf analizi
- Cross-reference bulma
- Codebase-wide rename
- Proje hafızası (memory)

**Temel Araçlar:**
| Tool | Kullanım |
|------|----------|
| `find_symbol` | İsimle symbol bul |
| `find_referencing_symbols` | Reference'ları bul |
| `rename_symbol` | Codebase-wide rename |
| `replace_symbol_body` | Kod değişikliği |
| `read/write/list_memory` | Proje hafızası |

**Ne Zaman KULLANMA:**
- 10+ dosya analiz → repomix
- Proje geneli yapı → repomix

---

## chrome-devtools-mcp
**Repo:** https://github.com/nicobytes/chrome-devtools-mcp
**Durum:** ✅ Proje bazlı (Chrome remote debugging açıkken aktif)

**Ne Zaman Kullan:**
- UI/Browser debugging
- Sayfa görselleştirme
- JS hataları
- Network analizi

**Temel Araçlar:**
| Tool | Kullanım |
|------|----------|
| `take_snapshot` | DOM snapshot al |
| `list_console_messages` | JS hatalarını listele |
| `list_network_requests` | Network isteklerini göster |
| `query_selector` | Element bul |
| `click_element` | Element'e tıkla |

---

## git-mcp (gitmcp.io)
**URL:** https://gitmcp.io/docs
**Durum:** ✅ Aktif

**Ne Zaman Kullan:**
- Harici library dokümantasyonu
- GitHub repo API referansı
- Dependency docs

**Temel Araçlar:**
| Tool | Kullanım |
|------|----------|
| `fetch_generic_documentation` | Repo docs fetch |
| `search_generic_documentation` | Docs içinde ara |
| `search_generic_code` | Kod içinde ara |
| `fetch_generic_url_content` | URL içeriği al |

**Örnek:** `fetch_generic_documentation owner=facebook repo=react`

---

## claude-flow (ruvnet/claude-flow)
**Repo:** https://github.com/ruvnet/claude-flow
**Durum:** ✅ Aktif

**Ne Zaman Kullan:**
- Multi-agent orkestrasyon
- Paralel task execution
- Swarm intelligence

**Temel Araçlar:**
| Tool | Kullanım |
|------|----------|
| `agent_spawn` | Yeni agent başlat |
| `agent_list` | Agent'ları listele |
| `agent_stop` | Agent durdur |

---

## dbhub (bytebase/dbhub)
**Repo:** https://github.com/bytebase/dbhub
**Durum:** ❌ Kurulu değil

**Desteklenen DB:** PostgreSQL, MySQL, SQLite, SQL Server, MariaDB

**Kurulum:**
```bash
claude mcp add dbhub -- npx -y @bytebase/dbhub --dsn "postgres://user:pass@localhost:5432/db"
```

**Temel Araçlar:**
| Tool | Kullanım |
|------|----------|
| `execute_sql` | SQL çalıştır |
| `search_objects` | Şema/tablo ara |

**Ne Zaman Kullan:**
- Database şema analizi
- SQL query çalıştırma
- Tablo yapısı inceleme

---

## github (@modelcontextprotocol/server-github)
**NPM:** @modelcontextprotocol/server-github
**Durum:** ✅ Aktif

**Ne Zaman Kullan:**
- GitHub repo yönetimi
- PR oluşturma/inceleme
- Issue yönetimi
- Kod arama (GitHub API)
- Branch/commit işlemleri

**Temel Araçlar:**
| Tool | Kullanım |
|------|----------|
| `create_or_update_file` | Dosya oluştur/güncelle |
| `push_files` | Çoklu dosya push |
| `create_repository` | Yeni repo oluştur |
| `create_issue` | Issue aç |
| `create_pull_request` | PR oluştur |
| `search_repositories` | Repo ara |
| `search_code` | Kod ara |
| `fork_repository` | Repo fork'la |

**git-mcp vs github MCP:**
- `git-mcp`: Sadece docs fetch (read-only)
- `github`: Full GitHub API (create, update, delete)

---

## tavily (tavily-mcp)
**NPM:** tavily-mcp
**Durum:** ✅ Aktif

**Ne Zaman Kullan:**
- Real-time web search (WebSearch'ten güçlü)
- Web sayfası içerik çıkarma
- Site crawl
- Güncel bilgi gerektiren sorgular

**Temel Araçlar:**
| Tool | Kullanım |
|------|----------|
| `search` | Web arama |
| `extract` | Sayfa içeriği çıkar |
| `crawl` | Site tarama |

**WebSearch vs Tavily:**
- `WebSearch`: Claude built-in, basit aramalar
- `Tavily`: Daha derin arama, extract, crawl desteği

---

## repomix (yamadashy/repomix)
**Repo:** https://github.com/yamadashy/repomix
**Durum:** CLI olarak kullanılıyor (MCP kurulu değil)

**CLI Kullanımı:**
| Komut | Kullanım |
|-------|----------|
| `repomix --token-count-tree` | Token dağılımı |
| `repomix --compress` | ~%70 token azaltma |
| `repomix --remote user/repo` | Harici repo |
| `repomix --include "src/**"` | Filtreleme |
| `repomix --skill-generate` | Skill oluştur |

**Ne Zaman Kullan:**
- 10+ dosya analiz
- Proje yapısı görüntüleme
- AI'a codebase besleme

**Ne Zaman KULLANMA:**
- Tek sembol → serena
- Spesifik dosya → Read tool

---

## claude-mem (thedotmack/claude-mem)
**Durum:** ✅ Aktif (plugin olarak)

**Araçlar:**
| Tool | Kullanım |
|------|----------|
| `search` | Memory ara |
| `timeline` | Context around results |
| `get_observations` | Detay al |

**Bilinen Sorunlar:**
- Worker startup race condition
- Observation'lar bazen kaydedilmiyor

**Öneri:** Proje bazlı context için `serena memories` daha stabil.

---

# PLUGINS

---

## superpowers@superpowers-marketplace
**Durum:** ✅ Aktif
**Invoke:** `Skill("superpowers:<skill-name>")`

### brainstorming
**Ne Yapar:** Socratic design discovery - feature tasarımı için sorular sorarak gereksinimleri netleştirir.
**Ne Zaman:** Yeni feature başlangıcında, belirsiz gereksinimler varken.
**Invoke:** `Skill("superpowers:brainstorming")`
**Örnek Kullanım:**
```
Kullanıcı: "Kullanıcı yetkilendirme sistemi ekle"
Claude: [brainstorming invoke] → OAuth mı, JWT mi? Role-based mi? Session süresi?
```

### systematic-debugging
**Ne Yapar:** 4 fazlı root cause analysis - hipotez oluştur, test et, doğrula, düzelt.
**Ne Zaman:** Bug fix başlangıcında, özellikle karmaşık/belirsiz hatalarda.
**Invoke:** `Skill("superpowers:systematic-debugging")`
**Örnek Kullanım:**
```
Kullanıcı: "Login çalışmıyor"
Claude: [systematic-debugging invoke] → Reproduce → Hipotez → Test → Fix
```

### test-driven-development
**Ne Yapar:** RED-GREEN-REFACTOR döngüsü - önce test yaz, sonra implement et.
**Ne Zaman:** Yeni feature veya bug fix yazarken TDD isterse.
**Invoke:** `Skill("superpowers:test-driven-development")`
**Örnek Kullanım:**
```
Kullanıcı: "TDD ile payment service yaz"
Claude: [TDD invoke] → Test yaz (RED) → Implement (GREEN) → Refactor
```

### verification-before-completion
**Ne Yapar:** İş bitiminde gerçekten çalışıyor mu kontrol eder.
**Ne Zaman:** Görev tamamlandığında, PR öncesinde.
**Invoke:** `Skill("superpowers:verification-before-completion")`
**Örnek Kullanım:**
```
Claude: "İşlem tamam"
Claude: [verification invoke] → Test çalıştır, build kontrol, edge case'ler
```

### writing-plans
**Ne Yapar:** Multi-step task için detaylı plan oluşturur.
**Ne Zaman:** Kompleks görevlerde (6+ adım), belirsiz scope'da.
**Invoke:** `Skill("superpowers:writing-plans")`
**Örnek Kullanım:**
```
Kullanıcı: "Microservice'e geç"
Claude: [writing-plans invoke] → Fazlar, bağımlılıklar, checkpoint'ler
```

### executing-plans
**Ne Yapar:** Yazılmış planı adım adım execute eder, checkpoint'lerde durur.
**Ne Zaman:** Plan yazıldıktan sonra implementation aşamasında.
**Invoke:** `Skill("superpowers:executing-plans")`

### requesting-code-review
**Ne Yapar:** PR öncesi self-review checklist'i uygular.
**Ne Zaman:** Kod tamamlandığında, PR açmadan önce.
**Invoke:** `Skill("superpowers:requesting-code-review")`

### receiving-code-review
**Ne Yapar:** Code review feedback'ini işler, düzeltmeleri uygular.
**Ne Zaman:** PR'a review geldiğinde.
**Invoke:** `Skill("superpowers:receiving-code-review")`

### using-git-worktrees
**Ne Yapar:** İzole git worktree oluşturur, paralel branch çalışması sağlar.
**Ne Zaman:** Feature isolation gerektiğinde, main'i bozmadan çalışmak için.
**Invoke:** `Skill("superpowers:using-git-worktrees")`

### dispatching-parallel-agents
**Ne Yapar:** Bağımsız task'ları paralel agent'lara dağıtır.
**Ne Zaman:** 2+ bağımsız iş varsa, hız kazanmak için.
**Invoke:** `Skill("superpowers:dispatching-parallel-agents")`

### writing-skills
**Ne Yapar:** Yeni skill dosyası oluşturur veya mevcut skill'i düzenler.
**Ne Zaman:** Custom skill yazmak gerektiğinde.
**Invoke:** `Skill("superpowers:writing-skills")`

---

## planning-with-files@planning-with-files
**Durum:** ✅ Aktif
**Invoke:** `Skill("planning-with-files:planning-with-files")`

**Ne Yapar:** Manus-style file-based planning - kompleks task'ları dosyalarda track eder.

**Ne Zaman Kullan:**
- 6+ adım gerektiren görev
- Multi-session iş (yarın devam edeceksen)
- 3+ dosya değişikliği
- Araştırma + implementation karışık görevler

**Oluşturduğu Dosyalar:**
| Dosya | İçerik |
|-------|--------|
| `task_plan.md` | Ana plan: fazlar, hedefler, bağımlılıklar |
| `findings.md` | Araştırma bulguları, keşfedilen bilgiler |
| `progress.md` | Session log, tamamlanan/kalan adımlar |

**Örnek Akış:**
```
1. Kullanıcı: "Authentication sistemi kur"
2. Claude: [planning-with-files invoke]
3. → task_plan.md oluştur (5 faz)
4. → Her faz sonunda progress.md güncelle
5. → Session bitince findings.md'ye öğrenilenleri yaz
6. → Sonraki session: task_plan.md oku, kaldığı yerden devam
```

---

## code-review@claude-plugins-official
**Durum:** ✅ Aktif
**Invoke:** `/code-review` veya `Skill("code-review:code-review")`

**Ne Yapar:** PR code review - değişiklikleri inceler, sorunları tespit eder.

**Ne Zaman Kullan:**
- PR açıldığında veya açmadan önce
- Başkasının kodunu incelemek için
- Self-review için

**Örnek Kullanım:**
```
Kullanıcı: "/code-review" veya "PR #123'ü incele"
Claude: [code-review invoke] → Diff analiz, security check, best practice kontrol
```

---

## jvm-languages@wshobson-agents
**Durum:** ✅ Aktif

### java-pro
**Ne Yapar:** Java 21+ expert - virtual threads, pattern matching, Spring Boot 3.x.
**Ne Zaman:** Java projelerinde, modern Java özellikleri gerektiğinde.
**Invoke:** `Task` tool ile `subagent_type="jvm-languages:java-pro"`
**Örnek:**
```
Kullanıcı: "Spring Boot 3 ile REST API yaz"
Claude: [java-pro agent spawn] → Modern Java patterns, records, sealed classes
```

### scala-pro
**Ne Yapar:** Scala expert - Akka, ZIO, Cats Effect, functional programming.
**Ne Zaman:** Scala projelerinde, FP patterns gerektiğinde.
**Invoke:** `Task` tool ile `subagent_type="jvm-languages:scala-pro"`

### csharp-pro
**Ne Yapar:** C# expert - records, pattern matching, async/await, .NET.
**Ne Zaman:** .NET projelerinde.
**Invoke:** `Task` tool ile `subagent_type="jvm-languages:csharp-pro"`

---

## backend-development@wshobson-agents
**Durum:** ✅ Aktif

### Agents

**backend-architect**
- **Ne Yapar:** API design, microservices architecture, distributed systems
- **Ne Zaman:** Yeni backend servisi tasarlarken, API endpoint'leri planlarken
- **Invoke:** `Task` tool ile `subagent_type="backend-development:backend-architect"`

**graphql-architect**
- **Ne Yapar:** GraphQL federation, schema design, performance optimization
- **Ne Zaman:** GraphQL API tasarımında, federation kurulumunda
- **Invoke:** `Task` tool ile `subagent_type="backend-development:graphql-architect"`

**event-sourcing-architect**
- **Ne Yapar:** Event sourcing infrastructure, event store design
- **Ne Zaman:** Event-driven architecture kurulumunda
- **Invoke:** `Task` tool ile `subagent_type="backend-development:event-sourcing-architect"`

**tdd-orchestrator**
- **Ne Yapar:** TDD workflow coordination, test-first development
- **Ne Zaman:** Takım genelinde TDD uygulamak için
- **Invoke:** `Task` tool ile `subagent_type="backend-development:tdd-orchestrator"`

**temporal-python-pro**
- **Ne Yapar:** Temporal workflow orchestration, saga patterns, Python SDK
- **Ne Zaman:** Long-running processes, distributed transactions
- **Invoke:** `Task` tool ile `subagent_type="backend-development:temporal-python-pro"`

### Skills (Invoke ile)

| Skill | Ne Yapar | Invoke |
|-------|----------|--------|
| `api-design-principles` | REST/GraphQL API design best practices | `Skill("backend-development:api-design-principles")` |
| `architecture-patterns` | Clean/Hexagonal/DDD patterns | `Skill("backend-development:architecture-patterns")` |
| `microservices-patterns` | Service mesh, resilience patterns | `Skill("backend-development:microservices-patterns")` |
| `cqrs-implementation` | Command Query Responsibility Segregation | `Skill("backend-development:cqrs-implementation")` |
| `saga-orchestration` | Distributed transaction patterns | `Skill("backend-development:saga-orchestration")` |
| `workflow-orchestration-patterns` | Durable workflow design | `Skill("backend-development:workflow-orchestration-patterns")` |

---

## security-scanning@wshobson-agents
**Durum:** ✅ Aktif

### Agents

**security-auditor**
- **Ne Yapar:** DevSecOps, vulnerability assessment, compliance (GDPR/HIPAA/SOC2)
- **Ne Zaman:** Security audit gerektiğinde, compliance kontrolü için
- **Invoke:** `Task` tool ile `subagent_type="security-scanning:security-auditor"`

**threat-modeling-expert**
- **Ne Yapar:** Threat modeling, attack surface analysis
- **Ne Zaman:** Yeni sistem tasarımında güvenlik analizi için
- **Invoke:** `Task` tool ile `subagent_type="security-scanning:threat-modeling-expert"`

### Skills (Invoke ile)

| Skill | Ne Yapar | Invoke |
|-------|----------|--------|
| `security-sast` | Static Application Security Testing | `Skill("security-scanning:security-sast")` |
| `attack-tree-construction` | Threat path visualization | `Skill("security-scanning:attack-tree-construction")` |
| `stride-analysis-patterns` | STRIDE methodology application | `Skill("security-scanning:stride-analysis-patterns")` |
| `threat-mitigation-mapping` | Threat → Control mapping | `Skill("security-scanning:threat-mitigation-mapping")` |
| `sast-configuration` | SAST tool setup | `Skill("security-scanning:sast-configuration")` |
| `security-requirement-extraction` | Security requirements from threats | `Skill("security-scanning:security-requirement-extraction")` |

---

## codebase-cleanup@wshobson-agents
**Durum:** ✅ Aktif

### Agents

**code-reviewer**
- **Ne Yapar:** AI-powered code analysis, security vulnerabilities, performance issues
- **Ne Zaman:** Kod kalitesi incelemesi gerektiğinde
- **Invoke:** `Task` tool ile `subagent_type="codebase-cleanup:code-reviewer"`

**test-automator**
- **Ne Yapar:** Test automation, self-healing tests, CI/CD integration
- **Ne Zaman:** Test coverage artırmak, test altyapısı kurmak için
- **Invoke:** `Task` tool ile `subagent_type="codebase-cleanup:test-automator"`

---

## code-refactoring@wshobson-agents
**Durum:** ✅ Aktif

### Agents

**code-reviewer**
- **Ne Yapar:** Refactoring review, clean code principles
- **Ne Zaman:** Refactoring sonrası review için
- **Invoke:** `Task` tool ile `subagent_type="code-refactoring:code-reviewer"`

**legacy-modernizer**
- **Ne Yapar:** Legacy code update, framework migrations, tech debt reduction
- **Ne Zaman:** Eski kodu modernize etmek için
- **Invoke:** `Task` tool ile `subagent_type="code-refactoring:legacy-modernizer"`

**Örnek Kullanım:**
```
Kullanıcı: "Bu Java 8 kodunu Java 21'e güncelle"
Claude: [legacy-modernizer spawn] → Records, pattern matching, virtual threads
```

---

## backend-api-security@wshobson-agents
**Durum:** ✅ Aktif

### Agents

**backend-architect**
- **Ne Yapar:** Scalable API design with security focus
- **Invoke:** `Task` tool ile `subagent_type="backend-api-security:backend-architect"`

**backend-security-coder**
- **Ne Yapar:** Secure backend coding - input validation, auth, API security
- **Ne Zaman:** Backend security implementation için
- **Invoke:** `Task` tool ile `subagent_type="backend-api-security:backend-security-coder"`

---

## security-compliance@wshobson-agents
**Durum:** ✅ Aktif

### Agents

**security-auditor**
- **Ne Yapar:** GDPR/HIPAA/SOC2 compliance check, incident response
- **Ne Zaman:** Compliance audit gerektiğinde
- **Invoke:** `Task` tool ile `subagent_type="security-compliance:security-auditor"`

---

# KARAR MATRİSİ

```
PROMPT İÇERİĞİ                          TOOL/MCP
─────────────────────────────────────────────────
sayfa, browser, UI, görünüm          → chrome-devtools
tablo, database, SQL, şema           → dbhub
tek metot, sınıf, sembol             → serena
proje yapısı, 10+ dosya              → repomix CLI
library docs, npm, harici API        → git-mcp
multi-agent, paralel iş              → claude-flow
Java, Spring Boot                    → jvm-languages:java-pro
güvenlik, SAST, vulnerability        → security-scanning
API design, microservices            → backend-development
code review, PR                      → code-review
kompleks görev (6+ adım)             → planning-with-files
feature başlangıcı                   → superpowers:brainstorming
bug fix                              → superpowers:systematic-debugging
```

---

# SORUN GİDERME

| Sorun | Çözüm |
|-------|-------|
| MCP bağlanamıyor | `claude mcp list` kontrol, restart |
| serena çalışmıyor | `uvx` kurulu mu? Python venv? |
| chrome-devtools yok | Chrome açık mı? Port 9222? |
| dbhub bağlanamıyor | DSN doğru mu? DB erişilebilir mi? |
