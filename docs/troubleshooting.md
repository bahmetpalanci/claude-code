# Hata Kurtarma Rehberi

> Bu dosya gerektiğinde referans amaçlıdır. Session'da otomatik yüklenmez.

---

## 3-Strike Rule

```
1. deneme: Hata → Düzelt, tekrar dene
2. deneme: Aynı hata → Farklı yaklaşım dene
3. deneme: Hala hata → KULLANICIYA SOR, devam etme
```

---

## Yaygın Hatalar ve Çözümler

| Hata | Kurtarma |
|------|----------|
| serena memory read FAILED | Kullanıcıya sor: "Önceki context bulunamadı, sıfırdan mı başlayalım?" |
| MCP disconnect | `claude mcp list` → Bağlı değilse kullanıcıya bildir |
| planning-with-files corrupt | Backup'tan oku veya yeniden oluştur |
| Tool 3x failed | Durumu kullanıcıya açıkla, farklı yaklaşım öner |
| Belirsiz görev | AskUserQuestion ile netleştir |

---

## MCP Bağlantı Sorunları

```bash
# Durum kontrolü
claude mcp list

# Restart
claude mcp remove <name>
claude mcp add <name> -- <command>

# Log kontrolü (MCP'ye göre değişir)
```

---

## Claude-mem Sorunları

**Bilinen bug:** Observation'lar kaydedilmiyor olabilir.

```bash
# DB kontrolü
sqlite3 ~/.claude-mem/claude-mem.db "SELECT COUNT(*) FROM observations"

# 0 ise: Worker'ı manuel başlat
bun ~/.claude/plugins/cache/thedotmack/claude-mem/9.0.4/scripts/worker-service.cjs start
```

**Alternatif:** `serena memories` kullan.

---

## Context Overflow

Claude Code context'i otomatik yönetir. Manuel müdahale nadiren gerekir.

Çok uzun session'larda:
1. Mevcut durumu özetle
2. serena write_memory → Kritik context'i kaydet
3. Kullanıcıya bildir: "Durumu kaydettim"
4. Gerekirse yeni session başlat

---

## Geri Dönüş

CLAUDE.md sorunlu hale geldiyse:

```bash
# Backup'tan geri yükle
cp ~/.claude/CLAUDE.md.backup ~/.claude/CLAUDE.md

# Git'ten geri al
cd ~/.claude && git checkout CLAUDE.md
```
