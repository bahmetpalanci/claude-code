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

### Temel Komutlar

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

### Ek Komutlar

| Kullanıcı Ne Diyor | Anlam | Skill | Tracking |
|--------------------|-------|-------|----------|
| "tasarım", "mimari", "design" | Architecture | `/sc:design` | TodoWrite |
| "brainstorm", "düşünelim", "tartışalım" | Discovery | `/sc:brainstorm` | - |
| "build", "derle", "package" | Build | `/sc:build` | - |
| "temizle", "dead code", "cleanup" | Cleanup | `/sc:cleanup` | TodoWrite |
| "araştır", "bul", "research" | Research | `/sc:research` | - |
| "tahmin", "estimate", "ne kadar sürer" | Estimate | `/sc:estimate` | - |
| "açıkla", "öğret", "explain" | Education | `/sc:explain` | - |
| "workflow", "PRD", "akış" | Workflow | `/sc:workflow` | TodoWrite |
| Karmaşık, çok adımlı (5+) | Planlama | `planning-with-files` | + serena |

### Özel Komutlar

| Komut | Açıklama |
|-------|----------|
| `/sc:pm` | Project Manager - Varsayılan orkestratör |
| `/sc:spawn` | Meta-system task orchestration |
| `/sc:index` | Proje dokümantasyonu oluştur |
| `/sc:index-repo` | Token-efficient repo indexing (%94 sıkıştırma) |
| `/sc:load` / `/sc:save` | Session lifecycle management |
| `/sc:reflect` | Task reflection ve validation |
| `/sc:spec-panel` | Multi-expert specification review |
| `/sc:business-panel` | Business strategy experts panel |

**Kurallar:**
- Emin değilsen `/sc:analyze` ile başla, sonra uygun skill'e geç
- **3 analyze sonrası hala belirsizse → Kullanıcıya sor** (döngü önleme)
- Skill %1 ihtimalle bile geçerliyse invoke et

---

## Session Lifecycle

### Başlangıç
```
serena list_memories
├── Memory varsa → serena read_memory (project_overview, style_conventions, son session)
├── Memory yoksa → Normal, ilk milestone'da oluşacak
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

## Superpowers (Otomatik Aktif)

> **NOT:** Bu plugin 16 skill içerir ve **otomatik tetiklenir**. Manuel invoke gerekmez.

| Durum | Tetiklenen Skill | Ne Yapar |
|-------|------------------|----------|
| Feature başlangıcı | `brainstorming` | Socratic design discovery |
| Bug fix | `systematic-debugging` | 4-fazlı root cause analysis |
| Test yazımı | `test-driven-development` | RED-GREEN-REFACTOR döngüsü |
| İş bitiminde | `verification-before-completion` | Gerçekten çalışıyor mu? |
| Multi-step task | `writing-plans` → `executing-plans` | Checkpoint'li execution |
| PR öncesi | `requesting-code-review` | Pre-review checklist |
| PR feedback | `receiving-code-review` | Feedback response workflow |
| Parallel work | `using-git-worktrees` | İzole branch'ler |

**Diğer Superpowers Skills:**
- `dispatching-parallel-agents` - Concurrent subagent workflows
- `subagent-driven-development` - Two-stage review (spec → code quality)
- `finishing-a-development-branch` - Merge/PR/keep/discard decisions
- `writing-skills` - Yeni skill oluşturma

**Kural:** Bu skill'ler context'e göre otomatik aktive olur. Sadece `%1 ihtimal` kuralı geçerli.

---

## Semantic MCP Seçim Kılavuzu

> **Kural:** Prompt'un ne söylediğine değil, **ne yapmak istediğine** bak.

| Intent (Kullanıcı Ne İstiyor) | Örnek Promptlar | MCP/Tool | İlk Aksiyon |
|-------------------------------|-----------------|----------|-------------|
| **UI/Sayfa/Tarayıcı debug** | "Sayfada hata var", "Buton çalışmıyor", "Network hatası" | chrome-devtools | `take_snapshot` |
| **Veritabanı sorgu/kontrol** | "Bu kayıt var mı?", "Tabloda kaç satır?", "Şema nasıl?" | dbhub-* | `search_objects` |
| **Harici library/docs** | "Bu library nasıl kullanılır?", "API referansı" | git-mcp | docs fetch |
| **Spesifik sembol/fonksiyon** | "Bu fonksiyon ne yapıyor?", "Referansları bul" | serena | `find_symbol` |
| **Tüm codebase analizi** | "Proje yapısı nasıl?", "Token dağılımı", "Genel mimari" | repomix | `--token-count-tree` |
| **Büyük refactoring (10+ dosya)** | "Tüm service'leri refactor et", "Pattern değiştir" | repomix | `--compress --include` |
| **Harici repo inceleme** | "Bu repo nasıl çalışıyor?", "Şu projeyi analiz et" | repomix | `--remote user/repo` |
| **Geçmiş context** | "Daha önce ne yaptık?", "Son session'da ne vardı?" | serena + claude-mem | `list_memories` |
| **Multi-agent orkestrasyon** | "Paralel çalıştır", "Agent spawn" | claude-flow | `agent spawn` |

### MCP Karar Ağacı

```
Prompt geldi
├─ UI/Sayfa/Tarayıcı → chrome-devtools
│   └─ take_snapshot → list_console_messages → list_network_requests
├─ Veritabanı/Veri → dbhub (dev/stage/test)
│   └─ search_objects → execute_sql
├─ Harici library docs → git-mcp
│   └─ fetch_generic_documentation
├─ Kod okuma/yazma
│   ├─ Spesifik sembol/fonksiyon → serena
│   │   └─ find_symbol → replace_symbol_body
│   └─ Geniş kapsamlı analiz → repomix (aşağıya bak)
├─ Harici repo analizi → repomix --remote
└─ Geçmiş context → serena memories + claude-mem
```

### Serena vs Repomix Karar Mantığı

```
Kod analizi gerekiyor
├─ Tek sembol/fonksiyon arama? → serena find_symbol
├─ Referans bulma? → serena find_referencing_symbols
├─ Tek dosya okuma? → serena get_symbols_overview
├─ 10+ dosya etkileyen değişiklik? → repomix --compress
├─ Tüm proje yapısı/token analizi? → repomix --token-count-tree
├─ Harici GitHub repo? → repomix --remote user/repo
└─ AI'a tam codebase besleme? → repomix --compress --style xml
```

**Kural:** Spesifik → serena, Geniş kapsamlı → repomix

### Intent Öncelikli Yaklaşım - Somut Örnekler

> **ÖNEMLİ:** Aynı kelimeler, farklı intent'lere göre farklı tool'ları tetikler.

#### Aynı Kelime, Farklı Intent

| Prompt | Kelime | Gerçek Intent | Doğru Tool |
|--------|--------|---------------|------------|
| "Sayfada hata var" | hata | UI/Browser debug | chrome-devtools |
| "Bu metotta hata var" | hata | Kod analizi | serena find_symbol |
| "Hata mesajlarını standartlaştır" | hata | Refactoring (çok dosya) | repomix → plan |
| "Hata loglama nasıl çalışıyor?" | hata | Geçmiş context | serena memories |

| Prompt | Kelime | Gerçek Intent | Doğru Tool |
|--------|--------|---------------|------------|
| "Projeyi analiz et" | analiz | Genel yapı | repomix --token-count-tree |
| "Bu sınıfı analiz et" | analiz | Tek sembol | serena get_symbols_overview |
| "Network trafiğini analiz et" | analiz | Browser debug | chrome-devtools |
| "Tablo yapısını analiz et" | analiz | DB şema | dbhub search_objects |

| Prompt | Kelime | Gerçek Intent | Doğru Tool |
|--------|--------|---------------|------------|
| "Nasıl çalışıyor?" (genel) | nasıl | Mimari anlama | repomix |
| "Bu fonksiyon nasıl çalışıyor?" | nasıl | Tek sembol | serena find_symbol |
| "Login nasıl çalışıyor?" (UI) | nasıl | Flow debug | chrome-devtools |
| "Mapper nasıl çalışıyor?" | nasıl | Library docs | git-mcp |

#### Intent Belirleme Soruları

```
1. KAPSAM: Tek dosya/sembol mü, yoksa proje geneli mi?
   └─ Tek → serena | Geniş → repomix

2. DOMAIN: Kod mu, UI mu, DB mi, harici library mi?
   └─ Kod → serena/repomix | UI → chrome-devtools | DB → dbhub | Library → git-mcp

3. AMAÇ: Okuma mı, yazma mı, debug mu?
   └─ Debug → chrome-devtools/logs | Okuma → serena | Yazma → serena + plan

4. CONTEXT: Geçmişe mi bakıyor, şimdiki duruma mı?
   └─ Geçmiş → serena memories + claude-mem | Şimdi → diğer tool'lar
```

#### Anti-Pattern: Kelime Eşleştirmesi

```
❌ YANLIŞ (Kelime bazlı)
"hata" kelimesi var → /sc:troubleshoot

✅ DOĞRU (Intent bazlı)
"Sayfada hata var" → UI sorunu → chrome-devtools
"Kodda hata var" → Kod analizi → serena
"Hata yönetimini değiştir" → Refactoring → plan + serena
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

### dbhub (Database - Gerektiğinde Ekle)
| İşlem | Tool |
|-------|------|
| Şema keşfi | `search_objects` (table, column) |
| Sorgu | `execute_sql` |

**Kurulum (proje bazlı):**
```bash
# DSN'i application.yml veya .env'den al
claude mcp add dbhub-dev -- npx -y @bytebase/dbhub --dsn "postgresql://..."
```

**Ortam seçimi (kurulduysa):**
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
| Library docs | `fetch_generic_documentation` |
| Kod arama | `search_generic_code` |

**Ne zaman:** Harici library kullanımı, dependency dokümantasyonu

### repomix (Codebase Paketleme)
| İşlem | Komut |
|-------|-------|
| Token dağılımı görme | `repomix --token-count-tree` |
| Sıkıştırılmış analiz | `repomix --compress` |
| Harici repo analizi | `repomix --remote user/repo --compress` |
| Belirli dosyalar | `repomix --include "src/**/*.ts" --ignore "**/*.test.ts"` |
| XML çıktı (AI için) | `repomix --compress --style xml -o analysis.xml` |

**Ne zaman:**
- Tüm proje yapısını anlama
- 10+ dosya etkileyen refactoring planı
- Harici GitHub repo inceleme
- Token bütçesi optimizasyonu (~%70 azaltma)

**Ne zaman KULLANMA:**
- Tek sembol/fonksiyon arama → serena
- Spesifik dosya okuma → serena
- Referans bulma → serena

### claude-flow (Multi-agent Orkestrasyon)
| İşlem | Tool |
|-------|------|
| Agent spawn | `agent spawn -t <type>` |
| Swarm init | `swarm init --v3-mode` |
| Memory search | `memory search -q "<query>"` |

**Ne zaman:** Paralel görevler, swarm intelligence, multi-agent workflows

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

# Repomix
repomix --token-count-tree              # Token dağılımı görselleştir
repomix --compress                       # ~%70 token azaltma
repomix --compress --style xml           # AI-friendly XML çıktı
repomix --remote user/repo --compress    # Harici repo analizi
repomix --include "src/**" --ignore "**/*.test.*"  # Filtreleme

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
