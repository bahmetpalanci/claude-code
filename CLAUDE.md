# Global Claude Code Talimatları

## ZORUNLU BAŞLANGIÇ (Her Oturum)

```
1. claude-flow hooks_session-start     → Session başlat
2. serena list_memories                → Hafızaları listele
3. serena read_memory (ilgili olanlar) → Context yükle
4. Görev tipini belirle                → Aşağıdaki tablodan skill seç
5. Skill invoke et                     → SONRA işe başla
```

> **ATLANMAZ.** "Basit görev" diye atlama. Prompt kısa olsa bile uygula.

---

## Görev → Skill Eşleştirmesi

| Kullanıcı Ne Diyor | Anlam | Skill | Tracking |
|--------------------|-------|-------|----------|
| "hata", "çalışmıyor", "bozuk", "fix" | Bug/Hata | `/sc:troubleshoot` | TodoWrite |
| "ekle", "yap", "oluştur", "implement" | Feature | `/sc:implement` | TodoWrite |
| "test", "coverage", "spec" | Test | `/sc:test` | TodoWrite |
| "analiz", "incele", "bak", "nasıl" | Analiz | `/sc:analyze` | - |
| "commit", "push", "branch", "PR" | Git | `/sc:git` | - |
| "refactor", "temizle", "iyileştir" | Refactoring | `superclaude:refactoring-expert` | TodoWrite |
| "güvenlik", "security", "vulnerability" | Security | `security-scanning:security-sast` | TodoWrite |
| Karmaşık, çok adımlı | Planlama | `planning-with-files` | + serena |

**Kural:** Emin değilsen `/sc:analyze` ile başla, sonra uygun skill'e geç.

---

## Session Lifecycle

### Başlangıç
```
claude-flow hooks_session-start
├── serena list_memories
├── serena read_memory (project_overview, style_conventions, son session)
└── task_plan.md varsa → Yarım görev bildir
```

### Çalışma
```
Skill invoke et (yukarıdaki tablodan)
├── TodoWrite ile her adımı track et
├── 5+ adım → planning-with-files kullan
├── claude-flow hooks_pre-task (görev başı)
└── Önemli kararları not al
```

### Görev Sonu
```
claude-flow hooks_post-task (success/fail, quality score)
├── serena write_memory (ne yapıldı, hangi dosyalar değişti)
├── claude-flow memory_store (özet bilgi)
└── TodoWrite temizle
```

### Session Sonu (uzun session veya kullanıcı isterse)
```
claude-flow hooks_session-end
└── Tüm state persist edilir
```

---

## Tracking Matrisi

| Görev Karmaşıklığı | TodoWrite | planning-with-files | serena memory | claude-flow |
|--------------------|-----------|---------------------|---------------|-------------|
| Basit (1-2 adım) | Evet | - | - | post-task |
| Orta (3-5 adım) | Evet | Opsiyonel | Milestone'da | pre/post-task |
| Kompleks (5+) | Evet | Evet | Her milestone | Tüm hooks |
| Multi-session | Evet | Evet | Zorunlu | session-start/end |

---

## MCP Kullanım Rehberi

### serena (Ana Araç)
| İşlem | Tool |
|-------|------|
| Proje context | `list_memories` → `read_memory` |
| Kod arama | `find_symbol`, `search_for_pattern` |
| Refactoring | `rename_symbol`, `replace_symbol_body` |
| Kayıt | `write_memory` (milestone sonrası) |

### claude-flow (Session & Learning)
| İşlem | Tool |
|-------|------|
| Session yönetimi | `hooks_session-start`, `hooks_session-end` |
| Görev tracking | `hooks_pre-task`, `hooks_post-task` |
| Pattern öğrenme | `hooks_route`, `hooks_metrics` |
| Kalıcı memory | `memory_store`, `memory_retrieve` |

### dbhub (Database)
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

---

## Temel Kurallar

| Kural | Detay |
|-------|-------|
| Test/Build | Kullanıcı izni gerekli - sormadan çalıştırma |
| Skill | %1 ihtimal bile olsa invoke et |
| 3-Strike | 3 denemede çözemediysen → Kullanıcıya sor |
| Major karar | Birden fazla yaklaşım varsa → Kullanıcıya sor |

### Güvenlik - ASLA Commit Etme
```
.env, .env.local, .env.production
credentials.json, secrets.yaml
*_secret*, *_key*, *_token*
application-prod.yml, *.pem, *.key
```

---

## Hata Durumları

| Hata | Aksiyon |
|------|---------|
| serena read failed | "Context bulunamadı, sıfırdan mı başlayalım?" |
| MCP disconnect | `claude mcp list` kontrol, kullanıcıya bildir |
| 3x tool failure | Durumu açıkla, alternatif öner |
| Skill bulunamadı | Closest match kullan, bildir |

---

## CLI Araçları

```bash
# Maven
./mvnw compile|test|package

# Git
git status|diff|log

# Repomix (büyük analiz için)
repomix --compress

# MCP
claude mcp list|add|remove
```

---

## Dil & Format
- Türkçe iletişim tercih edilir
- Kod ve teknik terimler İngilizce kalabilir
- Tablo formatı kullan (okunabilirlik)

---

## Referanslar
- `~/.claude/docs/mcp-reference.md` - MCP detayları
- `~/.claude/docs/workflows.md` - Görev akışları
- `~/.claude/docs/troubleshooting.md` - Hata kurtarma
