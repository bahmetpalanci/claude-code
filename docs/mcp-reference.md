# MCP & Plugin Referansı

> Bu dosya gerektiğinde referans amaçlıdır. Session'da otomatik yüklenmez.

## Hızlı Durum Kontrolü

```bash
claude mcp list              # Bağlı MCP'leri göster
claude mcp add <name> -- ... # MCP ekle
claude mcp remove <name>     # MCP kaldır
```

---

# MCP SUNUCULARI

## serena (oraios/serena)
**Repo:** https://github.com/oraios/serena
**Durum:** ⚠️ Config'de var, bağlantı kontrol edilmeli

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
**Durum:** ⚠️ Config'de var, bağlantı kontrol edilmeli

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

## superpowers@superpowers-marketplace
**Durum:** ✅ Aktif

**Skill'ler (Claude Invoke Etmeli):**
| Tetikleyici | Skill | Invoke |
|-------------|-------|--------|
| Feature başlangıcı | brainstorming | `Skill("superpowers:brainstorming")` |
| Bug fix | systematic-debugging | `Skill("superpowers:systematic-debugging")` |
| Test yazımı | test-driven-development | `Skill("superpowers:test-driven-development")` |
| İş bitiminde | verification-before-completion | `Skill("superpowers:verification-before-completion")` |
| Multi-step task | writing-plans | `Skill("superpowers:writing-plans")` |
| PR öncesi | requesting-code-review | `Skill("superpowers:requesting-code-review")` |

---

## planning-with-files@planning-with-files
**Durum:** ✅ Aktif

**Tetikleme Kriterleri:**
- 6+ adım gerektiren görev
- Multi-session iş
- 3+ dosya değişikliği

**Oluşturduğu Dosyalar:**
| Dosya | Amaç |
|-------|------|
| `task_plan.md` | Fazlar, ilerleme |
| `findings.md` | Araştırma bulguları |
| `progress.md` | Session log |

---

## code-review@claude-plugins-official
**Durum:** ✅ Aktif

**Komutlar:**
| Komut | Kullanım |
|-------|----------|
| `/code-review` | PR code review |

---

## jvm-languages@wshobson-agents
**Durum:** ✅ Aktif

**Agent'lar:**
| Agent | Kullanım |
|-------|----------|
| `jvm-languages:java-pro` | Java 21+, Spring Boot 3.x |
| `jvm-languages:scala-pro` | Scala, Akka, ZIO |
| `jvm-languages:csharp-pro` | C#, .NET |

---

## backend-development@wshobson-agents
**Durum:** ✅ Aktif

**Agent'lar:**
| Agent | Kullanım |
|-------|----------|
| `backend-architect` | API design, microservices |
| `graphql-architect` | GraphQL federation |
| `event-sourcing-architect` | Event sourcing |
| `tdd-orchestrator` | TDD workflow |
| `temporal-python-pro` | Temporal workflows |

**Skill'ler:**
| Skill | Kullanım |
|-------|----------|
| `api-design-principles` | REST/GraphQL design |
| `architecture-patterns` | Clean/Hexagonal/DDD |
| `microservices-patterns` | Microservices |
| `cqrs-implementation` | CQRS pattern |
| `saga-orchestration` | Distributed transactions |

---

## security-scanning@wshobson-agents
**Durum:** ✅ Aktif

**Agent'lar:**
| Agent | Kullanım |
|-------|----------|
| `security-auditor` | DevSecOps, compliance |
| `threat-modeling-expert` | Threat modeling |

**Skill'ler:**
| Skill | Kullanım |
|-------|----------|
| `security-sast` | Static code analysis |
| `attack-tree-construction` | Threat path mapping |
| `stride-analysis-patterns` | STRIDE methodology |
| `threat-mitigation-mapping` | Control mapping |

---

## codebase-cleanup@wshobson-agents
**Durum:** ✅ Aktif

**Agent'lar:**
| Agent | Kullanım |
|-------|----------|
| `code-reviewer` | Code quality review |
| `test-automator` | Test automation |

---

## code-refactoring@wshobson-agents
**Durum:** ✅ Aktif

**Agent'lar:**
| Agent | Kullanım |
|-------|----------|
| `code-reviewer` | Refactoring review |
| `legacy-modernizer` | Legacy code update |

---

## backend-api-security@wshobson-agents
**Durum:** ✅ Aktif

**Agent'lar:**
| Agent | Kullanım |
|-------|----------|
| `backend-architect` | Scalable API design |
| `backend-security-coder` | Secure backend coding |

---

## security-compliance@wshobson-agents
**Durum:** ✅ Aktif

**Agent'lar:**
| Agent | Kullanım |
|-------|----------|
| `security-auditor` | GDPR/HIPAA/SOC2 |

---

## claude-notifications-go@claude-notifications-go
**Durum:** ✅ Aktif

**Komutlar:**
| Komut | Kullanım |
|-------|----------|
| `/notifications-init` | Binary indir |
| `/notifications-settings` | Ayarları yapılandır |

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
