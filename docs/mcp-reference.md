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
**Durum:** Aktif

**Özellikler:**
- GitHub repo dokümantasyonu fetch
- Kod arama
- Library → owner/repo eşleştirme

---

## claude-flow (ruvnet/claude-flow)
**Repo:** https://github.com/ruvnet/claude-flow
**Durum:** Aktif

**Özellikler:**
- Multi-agent orkestrasyon
- Swarm intelligence
- RAG entegrasyonu
- Parallel agent spawning

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
