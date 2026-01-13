# Global Claude Code Talimatları

## ZORUNLU BAŞLANGIÇ (Her Oturum)

```
1. serena list_memories                → Hafızaları listele
2. serena read_memory (ilgili olanlar) → Context yükle
3. Görev tipini belirle                → Aşağıdaki tablodan skill seç
4. Skill invoke et                     → SONRA işe başla
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
| "refactor", "temizle", "iyileştir" | Refactoring | `/sc:improve` | TodoWrite |
| "güvenlik", "security", "vulnerability" | Security | `/sc:analyze` | TodoWrite |
| "dokümantasyon", "README", "açıkla" | Docs | `/sc:document` | - |
| Karmaşık, çok adımlı | Planlama | `planning-with-files` | + serena |

**Kurallar:**
- Emin değilsen `/sc:analyze` ile başla, sonra uygun skill'e geç
- **3 analyze sonrası hala belirsizse → Kullanıcıya sor** (döngü önleme)

---

## Session Lifecycle

### Başlangıç
```
serena list_memories
├── serena read_memory (project_overview, style_conventions, son session)
└── task_plan.md varsa → Yarım görev bildir
```

### Çalışma
```
Skill invoke et (yukarıdaki tablodan)
├── TodoWrite ile her adımı track et
├── 5+ adım → planning-with-files kullan
└── Önemli kararları not al
```

### Görev/Milestone Sonu
```
serena write_memory (ne yapıldı, hangi dosyalar değişti)
└── TodoWrite temizle
```

**Milestone Tanımı:** Commit, PR, Test pass, Major refactoring tamamlandığında

---

## Tracking Matrisi

| Görev Karmaşıklığı | TodoWrite | planning-with-files | serena memory |
|--------------------|-----------|---------------------|---------------|
| Basit (1-2 adım) | Evet | - | - |
| Orta (3-5 adım) | Evet | Opsiyonel | Milestone sonunda |
| Kompleks (5+) | Evet | Evet | Her milestone sonunda |
| Multi-session | Evet | Evet | Zorunlu (her session) |

---

## Semantic MCP Seçim Kılavuzu

> **Kural:** Prompt'un ne söylediğine değil, **ne yapmak istediğine** bak.

| Intent (Kullanıcı Ne İstiyor) | Örnek Promptlar | MCP | İlk Tool |
|-------------------------------|-----------------|-----|----------|
| **UI/Sayfa/Tarayıcı debug** | "Sayfada hata var", "Buton çalışmıyor", "Network hatası", "Console'da ne var?" | chrome-devtools | `take_snapshot` |
| **Veritabanı sorgu/kontrol** | "Bu kayıt var mı?", "Tabloda kaç satır?", "Şema nasıl?", "FK kontrolü" | dbhub-* | `search_objects` |
| **Harici library/docs** | "Bu library nasıl kullanılır?", "Repo docs nerede?", "API referansı" | git-mcp | docs fetch |
| **Kod analizi/refactoring** | "Bu fonksiyon ne yapıyor?", "Referansları bul", "Rename yap" | serena | `find_symbol` |
| **Geçmiş context** | "Daha önce ne yaptık?", "Son session'da ne vardı?" | serena + claude-mem | `list_memories` |
| **Multi-agent orkestrasyon** | "Paralel çalıştır", "Agent spawn" | claude-flow | `agent spawn` |

### MCP Karar Ağacı

```
Prompt geldi
├─ UI/Sayfa/Tarayıcı → chrome-devtools
│   └─ take_snapshot → list_console_messages → list_network_requests
├─ Veritabanı/Veri → dbhub (dev/stage/test)
│   └─ search_objects → execute_sql
├─ Harici library → git-mcp
│   └─ docs fetch
├─ Kod okuma/yazma → serena
│   └─ find_symbol → replace_symbol_body
└─ Geçmiş context → serena memories + claude-mem
```

---

## MCP Kullanım Rehberi

### serena (Ana Araç)
| İşlem | Tool |
|-------|------|
| Proje context | `list_memories` → `read_memory` |
| Kod arama | `find_symbol`, `search_for_pattern` |
| Refactoring | `rename_symbol`, `replace_symbol_body` |
| Kayıt | `write_memory` (milestone sonrası) |

### dbhub (Database)
| İşlem | Tool |
|-------|------|
| Şema keşfi | `search_objects` (table, column) |
| Sorgu | `execute_sql` |

**Ortam seçimi:**
- `dbhub-dev` → Geliştirme
- `dbhub-stage` → Staging/Test
- `dbhub-test` → Birim test DB

### chrome-devtools (Frontend Debug)
| İşlem | Tool |
|-------|------|
| Sayfa analizi | `take_snapshot`, `take_screenshot` |
| Interaction | `click`, `fill`, `navigate_page` |
| Debug | `list_console_messages`, `list_network_requests` |

**Ne zaman:** UI hataları, network sorunları, DOM analizi

### git-mcp (Repo Dokümantasyon)
| İşlem | Tool |
|-------|------|
| Library docs | docs fetch |
| README getir | get_readme |

**Ne zaman:** Harici library kullanımı, dependency dokümantasyonu

### claude-flow (Multi-agent - Opsiyonel)
| İşlem | Tool |
|-------|------|
| Agent spawn | `agent spawn -t <type>` |
| Swarm init | `swarm init --v3-mode` |
| Memory search | `memory search -q "<query>"` |

### claude-mem (Global Memory - Otomatik)
> **NOT:** Hooks aracılığıyla otomatik çalışır.

| İşlem | Tool |
|-------|------|
| Observation ara | `search` |
| Context getir | `timeline` |
| Detay al | `get_observations` |

**Ne zaman:** Önceki oturumlar, proje geçmişi, tüm projeler için global context

---

## Temel Kurallar

| Kural | Detay |
|-------|-------|
| Test/Build | Kullanıcı izni gerekli - sormadan çalıştırma |
| Skill | %1 ihtimal bile olsa invoke et |
| 3-Strike | 3 denemede çözemediysen → Kullanıcıya sor |
| Major karar | Birden fazla yaklaşım varsa → Kullanıcıya sor |
| Döngü önleme | 3 analyze/araştırma sonrası → Kullanıcıya sor |
| **~/.claude repo** | Her değişiklik sonrası otomatik commit & push (CLAUDE.md, docs/, settings.json, agents/, skills/, commands/, helpers/) |

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
- `~/.claude/docs/maintenance.md` - Bakım ve güncelleme
