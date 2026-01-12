# Bakım Prosedürleri

> Bu dosya gerektiğinde referans amaçlıdır. Session'da otomatik yüklenmez.

---

## CLAUDE.md Değişikliği

**Bu dosya git ile takip ediliyor!**

```bash
cd ~/.claude && git add -A && git commit -m "Update: <açıklama>" && git push
```

**Repo:** https://github.com/bahmetpalanci/claude-code

---

## Periyodik Kontroller

### Her Session Başı (Otomatik)
```bash
claude mcp list  # Tüm MCP'ler bağlı mı?
```

### Haftalık
| Kontrol | Komut |
|---------|-------|
| MCP sağlık | `claude mcp list` |
| Serena memories | `serena list_memories` |

### Güncelleme Kontrolleri

| Tool | Güncelleme Yöntemi |
|------|-------------------|
| claude-flow | Otomatik (npx @latest) |
| chrome-devtools-mcp | Otomatik (npx @latest) |
| @bytebase/dbhub | Otomatik (npx @latest) |
| serena | `pip install --upgrade` |
| repomix | `npm update -g repomix` |

**Kural:** Güncelleme yapmadan önce kullanıcıya sor!

```
Güncelleme bulundu:
- repomix: 1.2.3 → 1.3.0 (minor)
- serena: 2.0.0 → 3.0.0 (MAJOR)

Güncellemek ister misin?
```

### Aylık
| Kontrol | Aksiyon |
|---------|---------|
| CLAUDE.md review | Güncel mi? |
| Kullanılmayan MCP | `claude mcp remove` |
| Disk kullanımı | `du -sh ~/.claude*` |

---

## Güncelleme Komutları

```bash
# MCP server güncelle
claude mcp remove <name> && claude mcp add <name> -- <new-command>

# npm global paketler
npm update -g

# Homebrew
brew upgrade
```

---

## Yeni Araç Kurulduğunda

1. Bu dosyayı güncelle (veya docs/mcp-reference.md)
2. MCP durumunu kontrol et: `claude mcp list`
3. Test et ve çalıştığını doğrula
4. Git'e commit et ve push yap
