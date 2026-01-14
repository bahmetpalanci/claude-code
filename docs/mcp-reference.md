# MCP Sunucuları Referansı

> Bu dosya gerektiğinde referans amaçlıdır. Session'da otomatik yüklenmez.

## Config Lokasyonu
`~/.claude/mcp.json` (proje bazlı config KULLANMA!)

---

## serena (oraios/serena)
**Repo:** https://github.com/oraios/serena
**Durum:** Aktif

**Özellikler:**
- Semantic kod analizi (LSP tabanlı)
- Symbol-level okuma/yazma/refactoring
- Proje bazlı memory sistemi
- Cross-reference bulma
- Otomatik onboarding

**Temel Araçlar:**
| Tool | Kullanım |
|------|----------|
| `find_symbol` | İsimle symbol bul |
| `find_referencing_symbols` | Reference'ları bul |
| `rename_symbol` | Codebase-wide rename |
| `read/write/list_memory` | Proje hafızası |

---

## chrome-devtools-mcp
**Repo:** https://github.com/ChromeDevTools/chrome-devtools-mcp
**Durum:** Aktif

**Özellikler:**
- Browser otomasyon ve debug
- Screenshot ve DOM snapshot
- Network analizi
- Performance trace

---

## git-mcp (gitmcp.io)
**URL:** https://gitmcp.io/docs
**Durum:** Aktif (SSE → stdio bridge ile)

**Konfigürasyon:**
```json
{
  "command": "npx",
  "args": ["-y", "mcp-remote", "https://gitmcp.io/docs"]
}
```

**Özellikler:**
- GitHub repo dokümantasyonu fetch
- Library docs arama
- Dependency dokümantasyonu

**Ne zaman kullanılır:**
- Harici library nasıl kullanılır?
- API referansı lazım
- Repo docs nerede?

---

## repomix (yamadashy/repomix)
**Repo:** https://github.com/yamadashy/repomix
**Durum:** Aktif

**Çalışma Modları:**
- CLI tool (varsayılan)
- MCP Server (`--mcp` flag)

**CLI Özellikleri:**
| Komut | Kullanım |
|-------|----------|
| `--token-count-tree` | Token dağılımı görselleştir |
| `--compress` | ~%70 token azaltma |
| `--remote user/repo` | Harici repo analizi |
| `--style xml/md/json` | Çıktı formatı |
| `--skill-generate` | Claude Code skill oluştur |

**MCP Server Araçları:**
| Tool | Kullanım |
|------|----------|
| `pack_codebase` | Repo paketleme |
| `search_codebase` | Kod arama |
| `get_tree_structure` | Proje yapısı |
| `read_file_content` | Güvenli dosya okuma |

**Ne zaman kullanılır:**
- Tüm proje yapısını anlama
- 10+ dosya etkileyen refactoring planı
- AI'a tam codebase besleme
- Harici GitHub repo inceleme

**Ne zaman KULLANMA:**
- Tek sembol/fonksiyon arama → serena
- Spesifik dosya okuma → serena
- Referans bulma → serena

---

## planning-with-files (Plugin)
**Durum:** Aktif (enabled plugin)

**Amaç:** Kompleks görevlerde persistent state yönetimi

**Tetikleme Kriterleri:**
- 6+ adım gerektiren görev
- Multi-session iş
- Araştırma/keşif gerektiren görev
- 3+ dosya değişikliği

**Zorunlu Dosyalar:**
| Dosya | Amaç | Ne Zaman Güncelle |
|-------|------|-------------------|
| `task_plan.md` | Fazlar, ilerleme, kararlar | Her faz sonrası |
| `findings.md` | Araştırma bulguları | Her keşif anında |
| `progress.md` | Session log, test sonuçları | Sürekli |

**Temel Kurallar:**
- Plan First: Önce task_plan.md oluştur
- 2-Action Rule: Her 2 araştırmadan sonra findings.md güncelle
- Read Before Decide: Karar öncesi plan oku

---

## superpowers (Plugin)
**Durum:** Aktif (16 skill)

**Önemli:** Bu skill'ler "otomatik" DEĞİL - Claude tetikleyici durumu algıladığında Skill tool ile INVOKE ETMELİ. "Otomatik" ifadesi sadece "manuel kullanıcı talebi olmadan" anlamındadır.

**Claude'un Invoke Etmesi Gereken Skill'ler:**
| Skill | Tetikleyici Durum | Claude Ne Yapmalı |
|-------|-------------------|-------------------|
| `brainstorming` | Feature başlangıcı | `Skill("brainstorming")` |
| `systematic-debugging` | Bug fix | `Skill("systematic-debugging")` |
| `test-driven-development` | Test yazımı | `Skill("test-driven-development")` |
| `verification-before-completion` | İş bitiminde | `Skill("verification-before-completion")` |
| `writing-plans` → `executing-plans` | Multi-step task | `Skill("writing-plans")` |
| `requesting-code-review` | PR öncesi | `Skill("requesting-code-review")` |
| `receiving-code-review` | PR feedback | `Skill("receiving-code-review")` |
| `using-git-worktrees` | Parallel work | `Skill("using-git-worktrees")` |

**Diğer Skill'ler:**
- `dispatching-parallel-agents` - Concurrent subagent workflows
- `subagent-driven-development` - Two-stage review
- `finishing-a-development-branch` - Merge/PR/keep/discard
- `writing-skills` - Yeni skill oluşturma

---

## claude-flow (ruvnet/claude-flow)
**Repo:** https://github.com/ruvnet/claude-flow
**Durum:** Aktif (singleton script ile)

**Konfigürasyon:**
```json
{
  "command": "/Users/bap/.claude/scripts/claude-flow-mcp.sh",
  "args": []
}
```

**Özellikler:**
- Multi-agent orkestrasyon
- Swarm intelligence
- RAG entegrasyonu
- Parallel agent spawning

**Not:** Script otomatik olarak mevcut instance'ı durdurur

---

## dbhub (bytebase/dbhub)
**Repo:** https://github.com/bytebase/dbhub
**Durum:** Otomatik config

**Desteklenen DB:** PostgreSQL, MySQL, SQLite, SQL Server, MariaDB

### Otomatik Konfigürasyon

Proje ile çalışırken database işlemi gerekirse:

1. **Config dosyalarını tara:**
   ```
   application.yml, application.properties, .env,
   docker-compose.yml, config/*.yml
   ```

2. **DSN çıkar:**
   - `spring.datasource.url` → MySQL/PostgreSQL
   - `DATABASE_URL` → .env

3. **dbhub ekle:**
   ```bash
   claude mcp add dbhub -- npx -y @bytebase/dbhub --dsn "DSN"
   ```

---

## claude-mem (thedotmack/claude-mem)
**Durum:** Opsiyonel (bilinen sorunlar var)

**Bilinen sorunlar (v9.0.4):**
- Worker startup race condition
- Observation'lar bazen kaydedilmiyor

**Workaround:**
```bash
bun ~/.claude/plugins/cache/thedotmack/claude-mem/9.0.4/scripts/worker-service.cjs start
```

**Öneri:** Global öğrenmeler için `serena memories` daha stabil.

---

## MCP Sağlık Kontrolü

```bash
# Bağlı MCP'leri listele
claude mcp list

# MCP ekle
claude mcp add <name> -- <command>

# MCP kaldır
claude mcp remove <name>
```
