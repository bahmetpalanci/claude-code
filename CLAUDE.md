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
| Karmaşık görev (6+ adım, multi-session, araştırma) | Planlama | `planning-with-files` | + TodoWrite |

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
├── TodoWrite ile her adımı track et (anlık)
├── 6+ adım / multi-session / araştırma → planning-with-files (kalıcı)
│   └── task_plan.md + findings.md + progress.md oluştur
└── Önemli kararları not al
```

### Görev/Milestone Sonu
```
serena write_memory (ne yapıldı, hangi dosyalar değişti)
└── TodoWrite temizle
```

**Milestone Tanımı:** Commit, PR, Test pass, Major refactoring tamamlandığında

---

## Tracking: TodoWrite vs Planning Files

### Amaç Farkı

| Araç | Amaç | Yaşam Süresi | Ne Zaman |
|------|------|--------------|----------|
| **TodoWrite** | Anlık adım takibi (RAM) | Session içi | Her görev |
| **Planning Files** | Persistent state (Disk) | Session'lar arası | Kompleks görevler |

> **Kural:** TodoWrite = "Şimdi ne yapıyorum?", Planning Files = "Neredeydim, nereye gidiyorum?"

### Karmaşıklık Matrisi

| Görev Karmaşıklığı | TodoWrite | Planning Files | serena memory |
|--------------------|-----------|----------------|---------------|
| Basit (1-2 adım) | Evet | - | - |
| Orta (3-5 adım) | Evet | Opsiyonel | Milestone sonunda |
| Kompleks (6+ adım) | Evet | **Zorunlu** | Her milestone |
| Multi-session | Evet | **Zorunlu** | Her session başı/sonu |
| Araştırma/Research | Evet | **Zorunlu** | Keşif sonrası |

### Anti-Pattern

```
❌ YANLIŞ: TodoWrite'ı persistence için kullanmak
   → Session bitince kaybolur

✅ DOĞRU: TodoWrite = anlık tracking, Planning Files = kalıcı state
```

---

## Planning with Files Workflow

> **Felsefe:** `Context Window = RAM (volatile)` → `Filesystem = Disk (persistent)`

### Tetikleme Kriterleri

```
Planning Files KULLAN eğer:
├─ 6+ adım gerektiren görev
├─ Birden fazla session'a yayılabilecek iş
├─ Araştırma/keşif gerektiren görev
├─ 3+ dosya değişikliği
└─ Önemli kararlar içeren iş

Planning Files KULLANMA eğer:
├─ Tek dosya düzenleme
├─ Basit soru-cevap
└─ Quick lookup
```

### Zorunlu 3 Dosya

| Dosya | Amaç | Ne Zaman Güncelle |
|-------|------|-------------------|
| `task_plan.md` | Fazlar, ilerleme, kararlar | Her faz sonrası |
| `findings.md` | Araştırma, keşifler, notlar | Her keşif anında |
| `progress.md` | Session logu, test sonuçları | Sürekli |

**Dosya Konumu:** Proje root dizini (skill klasörü DEĞİL)

### Temel Kurallar

#### 1. Plan First (Zorunlu)
```
Kompleks görev başlangıcı
└─ ÖNCE task_plan.md oluştur
   └─ SONRA işe başla
```

#### 2. 2-Action Rule
```
Her 2 araştırma/arama işleminden sonra
└─ Bulguları HEMEN findings.md'ye yaz
   └─ Multimodal bilgi (screenshot, PDF) özellikle kaybolur
```

#### 3. Read Before Decide
```
Önemli karar vermeden önce
└─ task_plan.md'yi oku
   └─ Hedefler attention window'da taze kalır
```

#### 4. Update After Act
```
Her faz tamamlandığında
├─ Status güncelle: in_progress → complete
├─ Karşılaşılan hataları logla
└─ Değiştirilen dosyaları not et
```

#### 5. 3-Strike → File Log
```
Hata oluştu
├─ 1. deneme: Tanı & düzelt
├─ 2. deneme: Farklı yaklaşım dene
├─ 3. deneme: Varsayımları sorgula
└─ 3 başarısız → task_plan.md'ye logla + kullanıcıya sor
```

### Read vs Write Karar Matrisi

| Durum | Aksiyon | Neden |
|-------|---------|-------|
| Dosya yeni yazdım | OKUMA | Context'te zaten var |
| Görsel/PDF inceledim | HEMEN YAZ | Multimodal → text kaybolur |
| Browser data döndü | YAZ | Screenshot persist etmez |
| Yeni faza başlıyorum | OKU | Context tazelensin |
| Hata oluştu | OKU | Güncel state lazım |
| Session'a devam | HEPSİNİ OKU | State recovery |

### 5-Soru Context Testi

Bu soruları cevaplayabiliyorsan context yönetimi sağlam:

| Soru | Kaynak |
|------|--------|
| Neredeyim? | task_plan.md (aktif faz) |
| Nereye gidiyorum? | task_plan.md (kalan fazlar) |
| Hedef ne? | task_plan.md (goal statement) |
| Ne öğrendim? | findings.md |
| Ne yaptım? | progress.md |

### Superpowers Entegrasyonu

| Superpowers Skill | Planning Files İlişkisi |
|-------------------|-------------------------|
| `writing-plans` | task_plan.md otomatik oluşturur |
| `executing-plans` | task_plan.md'yi checkpoint'lerle takip eder |
| `systematic-debugging` | findings.md'ye root cause analizi yazar |
| `verification-before-completion` | progress.md'yi kontrol eder |

> **NOT:** Superpowers skill'leri planning-with-files ile uyumlu çalışır. Manuel dosya oluşturma veya superpowers otomasyonu - ikisi de geçerli.

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
