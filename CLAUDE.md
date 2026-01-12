# Global Claude Code Talimatları

## Temel Kurallar
- Bana sormadan derleme yapma ve test yazma
- Uygun aracı/plugin'i sormadan otomatik kullan
- Skill uygunsa direkt invoke et
- MCP aracı gerekiyorsa direkt çağır
- Sadece ciddi belirsizlik varsa sor

### 🧪 Test Politikası
| İşlem | İzin | Açıklama |
|-------|------|----------|
| Test YAZMA | ❌ Sorma | Kullanıcı isterse yaz |
| Test ÇALIŞTIRMA | ✅ Otomatik | Milestone kontrolü için çalıştır |
| Build ÇALIŞTIRMA | ❌ Sorma | Kullanıcı isterse çalıştır |

**Ne zaman test çalıştır (otomatik):**
- Commit öncesi (`/sc:git` içinde)
- PR oluşturmadan önce
- Major değişiklik sonrası doğrulama

### 🔐 Güvenlik Kuralları
```
ASLA COMMIT ETME:
├─ .env, .env.local, .env.production
├─ credentials.json, secrets.yaml
├─ *_secret*, *_key*, *_token*
├─ application-prod.yml (hassas config)
└─ private key dosyaları (*.pem, *.key)

UYARI VER:
├─ Hardcoded password/API key görürsen
├─ Güvenli olmayan HTTP endpoint
└─ SQL injection riski
```

---

## 🚀 SESSION BAŞLANGIÇ CHECKLIST (HER KONUŞMADA ÇALIŞTIR!)

**İlk mesajı aldığımda HEMEN şunları yap:**

```
□ 1. serena list_memories → Proje hafızası var mı?
□ 2. serena read_memory (varsa) → Context yükle
□ 3. Bakım kontrolü → "last-maintenance-*" memory'si var mı?
   └─ 7 günden eski veya yok → Otomatik bakım çalıştır (aşağıda)
□ 4. Proje yapısını tanı (ls, package.json, build.gradle, etc.)
□ 5. Önceki task_plan.md var mı? → Devam mı, yeni mi?
```

**NOT:** Bu checklist sessizce çalıştır, kullanıcıya sadece önemli sorunları bildir!

---

## 🧠 Hafıza Hiyerarşisi (ÖNEMLİ)

```
SERENA MEMORIES     → Proje bazlı context (mimari, kararlar)
       ↓
CLAUDE-MEM          → Global öğrenmeler (patterns, best practices)
       ↓                ⚠️ BUG: observation kaydetmiyor!
PLANNING-WITH-FILES → Kompleks görev tracking (task_plan.md)
       ↓
TODOWRITE           → Anlık progress (session-only)
```

**⚠️ claude-mem Workaround:**
claude-mem bug'lı olduğu için global öğrenmeleri de `serena memories`'e kaydet:
- Memory adı: `global-learnings-YYYY-MM` (aylık)
- İçerik: Patterns, best practices, cross-project insights

### Ne Zaman Hangisi?

| Durum | Aksiyon |
|-------|---------|
| Proje ile çalışmaya başladım | `serena read_memory` (varsa) |
| 3+ adımlı kompleks görev | `planning-with-files` oluştur |
| Her görevde | `TodoWrite` kullan |
| Önemli pattern/karar öğrendim | `claude-mem` save |
| Milestone tamamlandı | `serena write_memory` + `claude-mem` save |
| Kullanıcı "bitti/tamam" dedi | Her ikisine kaydet |

---

## 🔄 Session Yaşam Döngüsü

### Kullanıcı "yeni proje/başla" dediğinde:
```
1. serena check_onboarding_performed → İlk kez mi?
   ├─ İlk kez → Onboarding akışını başlat (aşağıda)
   └─ Değil → serena read_memory → Context yükle
2. Proje yapısını tanı (Java/Python/Node/etc.)
3. Kompleks görevse → planning-with-files başlat
```

### 🆕 Yeni Proje Onboarding Akışı
```
1. serena onboarding → Proje yapısını öğren
2. Kullanıcıya sor: "Projenin amacı nedir? Ana teknolojiler?"
3. repomix çalıştır → Baseline oluştur
4. serena write_memory → Onboarding bilgilerini kaydet:
   - Proje amacı
   - Teknoloji stack (Java/Spring, Node/Express, etc.)
   - Önemli dizinler (src/main, tests/, etc.)
   - Build/test komutları
5. Bildir: "✅ Proje onboarding tamamlandı"
```

### Çalışma sırasında:
```
- TodoWrite ile progress track et
- Her 2 işlemden sonra bulguları dosyaya yaz (planning-with-files)
- Önemli kararları not al
```

### 🔁 Multi-Session Devam (Önceki görev yarım kaldıysa)
```
1. Session başında task_plan.md kontrol et
2. Varsa ve tamamlanmamışsa:
   - progress.md oku → Son durum neydi?
   - Kullanıcıya bildir: "Yarım kalan görev var: [özet]. Devam edelim mi?"
   - Evet → Kaldığı yerden devam
   - Hayır → task_plan.md arşivle (task_plan_YYYY-MM-DD.md)
3. findings.md'yi oku → Önceki bulgular
4. Kaldığı fazdan devam et
```

### Kullanıcı "bitti/tamam/son" dediğinde:
```
1. serena write_memory → Proje context kaydet
2. global-learnings → Önemli pattern/kararlar (serena'ya)
3. repomix → Major değişiklik varsa çalıştır
```

### 🔔 OTOMATİK KAYIT (kullanıcı unutursa)

**Milestone sonrası otomatik kaydet:**
- ✅ git commit/push başarılı → serena write_memory
- ✅ PR oluşturuldu → serena write_memory
- ✅ Tüm testler geçti → serena write_memory
- ✅ Major refactoring tamamlandı → serena write_memory

**Hatırlatma tetikleyicileri:**
- 10+ tool kullanımı sonrası → "Session'ı kaydetmek ister misin?"
- Büyük görev tamamlandı → "Bitti mi, devam mı?"
- Context dolmaya yakın → Aşağıdaki akışı başlat

### 📦 Context Overflow Handling
```
Context %80+ dolduğunda:
1. Mevcut durumu özetle
2. serena write_memory → Kritik context'i kaydet
3. planning-with-files güncelle → progress.md yaz
4. Kullanıcıya bildir:
   "Context dolmak üzere. Durumu kaydettim.
    Yeni session'da devam edebiliriz."
5. Devam kararı kullanıcıda
```

**NOT:** Milestone'larda SORMADAN kaydet, sadece bildir:
```
✅ Commit başarılı. Session context'i serena'ya kaydedildi.
```

---

## 📁 Kompleks Görev Yönetimi (planning-with-files)

**3+ adımlı görevlerde OTOMATİK başlat:**

```
1. task_plan.md oluştur  → Fazlar, hedefler, kararlar
2. findings.md oluştur   → Araştırma bulguları
3. progress.md oluştur   → Session log, hatalar
```

**Kurallar:**
- Her 2 işlemden sonra bulguları dosyaya yaz
- Karar vermeden önce plan dosyasını oku
- Her hatayı logla, 3 denemeden sonra kullanıcıya sor
- Faz tamamlandığında durumu güncelle

---

## 🎯 Akıllı Tetikleyiciler

### Yüksek Güvenilirlik (Direkt tetikle)

| Kullanıcı Dediğinde | Aksiyon |
|---------------------|---------|
| "yeni özellik ekle", "feature implement et" | `/sc:brainstorm` → `/sc:implement` |
| "bug var", "hata düzelt", "çalışmıyor" | `/sc:troubleshoot` |
| "commit yap", "push et", "PR oluştur" | `/sc:git` |
| "test yaz", "test çalıştır", "coverage" | `/sc:test` |
| "refactor et", "kodu temizle" | `/sc:analyze` → refactoring |
| "migration yap", "taşı", "dönüştür" | `planning-with-files` + `serena` |
| "güvenlik kontrolü", "security scan" | `security-scanning` |
| "analiz et", "kod review" | `/sc:analyze` + `serena` |

### Düşük Güvenilirlik (Bağlam gerekir)

| Tek Kelime | Tetikleme | Neden |
|------------|-----------|-------|
| "ekle" | ❌ Hayır | "yorum ekle" vs "feature ekle" farklı |
| "fix" | ❌ Hayır | "typo fix" vs "bug fix" farklı |
| "test" | ❌ Hayır | "test et" vs "test yaz" farklı |

---

## 🔧 Aktif MCP Sunucuları (GLOBAL - Tüm Projeler)

**Config:** `~/.claude/mcp.json` (proje bazlı config KULLANMA!)

| MCP | Durum | Ne Zaman |
|-----|-------|----------|
| `serena` | ✅ Aktif | Kod analizi, refactoring, proje hafızası |
| `claude-mem` | ❌ Bug | Worker race condition - observation oluşturmuyor. `serena memories` kullan |
| `chrome-devtools` | ✅ Aktif | Browser testi, screenshot, DOM |
| `git-mcp` | ✅ Aktif | Git dokümantasyonu |
| `dbhub` | 🔄 Otomatik | Proje config'inden DSN al ve bağlan (aşağıya bak) |
| `claude-flow` | ✅ Aktif | Multi-agent orkestrasyon, 27 tool |

### dbhub Otomatik Konfigürasyon

Proje ile çalışırken database işlemi gerekirse:

1. **Config dosyalarını tara:**
   ```
   application.yml, application.properties, .env,
   docker-compose.yml, config/*.yml, src/main/resources/*.yml
   ```

2. **DSN çıkar:**
   - `spring.datasource.url` → MySQL/PostgreSQL
   - `MYSQL_*`, `POSTGRES_*` → Docker env vars
   - `DATABASE_URL` → .env

3. **dbhub ekle (tek sefer):**
   ```bash
   claude mcp add dbhub -- npx -y @bytebase/dbhub --dsn "DSN_BURAYA"
   ```

4. **serena memory'e kaydet:** "dbhub configured for [project]"

---

## ⚠️ Tek Seferlik İşlemler (Tekrarlama!)

Bu işlemler proje başına BİR KEZ yapılır, her session'da tekrarlanmaz:

| İşlem | Kontrol Yöntemi | Kayıt Yeri |
|-------|-----------------|------------|
| dbhub DSN config | `claude mcp list \| grep dbhub` | MCP config |
| Proje onboarding | `serena check_onboarding_performed` | serena |
| repomix baseline | `repomix-output.txt` var mı | Filesystem |
| Initial git setup | `.git` klasörü var mı | Filesystem |
| npm/gradle dependency | `node_modules/`, `build/` var mı | Filesystem |

**Kural:** İşlem yapmadan önce zaten yapılmış mı kontrol et!

---

## 📦 Pluginler

### 🎯 ARAÇ HİYERARŞİSİ (ÖNEMLİ!)

```
┌─────────────────────────────────────────────────────────────┐
│  SUPERPOWERS (Discipline Layer)                             │
│  "NASIL yapılacak" - Workflow kuralları, disiplin           │
│  → Önce invoke et, sonra diğerlerini çalıştır               │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  SC COMMANDS + SUPERCLAUDE AGENTS (Execution Layer)         │
│  "NE yapılacak" - Gerçek iş, kod yazma, analiz              │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│  TRACKING LAYER                                             │
│  TodoWrite: Session-only, anlık progress                    │
│  planning-with-files: Persistent, 3+ adımlı kompleks        │
└─────────────────────────────────────────────────────────────┘
```

**Çakışan Araçlar - Hangisini Kullan:**

| Durum | Superpowers | SC Command | Birlikte? |
|-------|-------------|------------|-----------|
| Yeni feature | `brainstorming` | `/sc:brainstorm` | Önce superpowers → sonra /sc |
| Bug fix | `systematic-debugging` | `/sc:troubleshoot` | Önce superpowers → sonra /sc |
| Plan yazma | `writing-plans` | `/sc:design` | Önce superpowers → sonra /sc |
| Kod yazma | `test-driven-development` | `/sc:implement` | Önce superpowers → sonra /sc |
| Bitirme | `verification-before-completion` | `/sc:git` | Önce superpowers → sonra /sc |

**Tracking Seçimi:**

| Görev Tipi | TodoWrite | planning-with-files |
|------------|-----------|---------------------|
| Basit (1-2 adım) | ✅ | ❌ |
| Orta (3-5 adım) | ✅ | Opsiyonel |
| Kompleks (5+ adım) | ✅ | ✅ Zorunlu |
| Multi-session | ✅ | ✅ Zorunlu |

**Kural:** TodoWrite HER ZAMAN kullan. planning-with-files sadece kompleks görevlerde.

---

### SuperClaude (/sc:*)
| Komut | Ne Zaman |
|-------|----------|
| `/sc:brainstorm` | Yeni özellik başlangıcı |
| `/sc:implement` | Kod yazma |
| `/sc:test` | Test işlemleri |
| `/sc:analyze` | Kod analizi |
| `/sc:troubleshoot` | Bug araştırma |
| `/sc:git` | Git işlemleri |
| `/sc:pm` | Proje yönetimi |

### SuperClaude Agents (/superclaude:*)
| Agent | Ne Zaman |
|-------|----------|
| `/superclaude:backend-architect` | Backend mimari |
| `/superclaude:frontend-architect` | Frontend mimari |
| `/superclaude:security-engineer` | Güvenlik |
| `/superclaude:performance-engineer` | Performans |
| `/superclaude:system-architect` | Sistem mimarisi |
| `/superclaude:refactoring-expert` | Refactoring |
| `/superclaude:root-cause-analyst` | Hata analizi |

### Superpowers (Workflow Skills)
| Skill | Ne Zaman |
|-------|----------|
| `superpowers:brainstorming` | Yeni feature/component oluşturmadan ÖNCE |
| `superpowers:writing-plans` | Multi-step task planlamadan ÖNCE |
| `superpowers:executing-plans` | Yazılı plan execute ederken |
| `superpowers:test-driven-development` | Feature/bugfix implement ederken |
| `superpowers:systematic-debugging` | Bug/test failure karşılaşınca |
| `superpowers:verification-before-completion` | "Bitti" demeden ÖNCE |
| `superpowers:requesting-code-review` | Major feature/PR öncesi |
| `superpowers:receiving-code-review` | Code review feedback alınca |
| `superpowers:using-git-worktrees` | İzole feature çalışması |
| `superpowers:dispatching-parallel-agents` | 2+ bağımsız task varsa |
| `superpowers:finishing-a-development-branch` | Branch tamamlandığında |

**ÖNEMLİ:** Bu skill'ler %1 bile uygulanabilir olsa INVOKE ET!

### Diğer Pluginler
| Plugin | Ne Zaman |
|--------|----------|
| `jvm-languages` | Java/Kotlin/Scala |
| `backend-development` | Backend API |
| `security-scanning` | Güvenlik tarama |
| `code-refactoring` | Refactoring |
| `planning-with-files` | Kompleks görevler |

---

## 🛠 CLI Araçları

| Araç | Durum | Ne Zaman |
|------|-------|----------|
| `repomix` | ✅ Kurulu | Aşağıdaki tetikleyicilerde |

### repomix Tetikleyicileri
```
OTOMATİK ÇALIŞTIR:
├─ Proje onboarding (baseline)
├─ Major migration tamamlandı
├─ 10+ dosya değişikliği olan commit
├─ Yeni modül/paket eklendi
└─ Mimari değişiklik (yeni service, API, etc.)

ÇALIŞTIRMA:
├─ Küçük bug fix
├─ Dokümantasyon değişikliği
├─ Config değişikliği
└─ Test ekleme/düzeltme
```

**Komut:** `repomix --output repomix-output.txt`

---

## 📋 Görev Akışları (Superpowers Entegre)

### Yeni Özellik
```
1. superpowers:brainstorming → Düşünme disiplini
2. /sc:brainstorm → Gerçek brainstorm
3. superpowers:writing-plans → Plan disiplini
4. /sc:design → Plan oluştur
5. superpowers:test-driven-development → TDD disiplini
6. /sc:implement → Kod yaz
7. superpowers:verification-before-completion → Kontrol
8. /sc:test → Testleri çalıştır
9. /sc:git → Commit/push
```

### Bug Düzeltme
```
1. superpowers:systematic-debugging → Debug disiplini
2. /sc:troubleshoot → Root cause bul
3. Fix uygula
4. superpowers:verification-before-completion → Kontrol
5. /sc:test → Testleri çalıştır
6. /sc:git → Commit/push
```

### Major Migration
```
1. serena read_memory → Proje context
2. superpowers:writing-plans → Plan disiplini
3. planning-with-files → task_plan.md oluştur
4. superpowers:executing-plans → Execute disiplini
5. Fazlar halinde implement
6. superpowers:verification-before-completion → Her faz sonunda
7. serena write_memory → Context kaydet
8. repomix → Baseline güncelle
```

### Refactoring
```
1. /sc:analyze → Mevcut durumu anla
2. superpowers:writing-plans → Refactor planı
3. code-refactoring plugin → Sistematik refactor
4. superpowers:verification-before-completion → Kontrol
5. /sc:test → Regression test
6. /sc:git → Commit/push
```

---

## 🌍 Dil Tercihi
- Türkçe iletişim tercih edilir
- Kod ve teknik terimler İngilizce kalabilir

---

## 🔄 State Machine (Durum Takibi)

```
┌─────────┐
│  IDLE   │ ← Session başı
└────┬────┘
     │ kullanıcı görev verdi
     ▼
┌─────────────┐
│  ANALYZING  │ → Görevi anla, tool seç
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  EXECUTING  │ → Tool'ları çalıştır
└──────┬──────┘
       │
       ▼
┌─────────────┐
│  VERIFYING  │ → Sonucu doğrula
└──────┬──────┘
       │ başarılı
       ▼
┌─────────────┐
│  CLEANUP    │ → Memory kaydet, todo temizle
└──────┬──────┘
       │
       ▼
┌─────────┐
│  IDLE   │
└─────────┘
```

**State'i nasıl takip et:**
- TodoWrite'ta aktif görev = mevcut state
- Görev yoksa = IDLE
- Hata varsa = BLOCKED → kullanıcıya sor

---

## 🚨 Hata Kurtarma

| Hata | Kurtarma |
|------|----------|
| serena memory read FAILED | Kullanıcıya sor: "Önceki context bulunamadı, sıfırdan mı başlayalım?" |
| MCP disconnect | `claude mcp list` → bağlı değilse kullanıcıya bildir |
| planning-with-files corrupt | Backup'tan oku veya yeniden oluştur |
| Tool 3x failed | Durumu kullanıcıya açıkla, farklı yaklaşım öner |
| Belirsiz görev | AskUserQuestion ile netleştir |

**3-Strike Rule:**
```
1. deneme: Hata → düzelt, tekrar dene
2. deneme: Aynı hata → farklı yaklaşım dene
3. deneme: Hala hata → KULLANICIYA SOR, devam etme
```

---

## 🔧 Bakım

### CLAUDE.md Değişikliği Yapıldığında
**Bu dosya git ile takip ediliyor! Değişiklik sonrası:**
```bash
cd ~/.claude && git add -A && git commit -m "Update: <değişiklik açıklaması>" && git push
```
**Repo:** https://github.com/bahmetpalanci/claude-code

### Yeni Araç Kurulduğunda
1. Bu dosyayı güncelle
2. MCP durumunu kontrol et: `claude mcp list`
3. Test et ve çalıştığını doğrula
4. **Git'e commit et ve push yap!**

### Periyodik Kontroller

**Her session başında (otomatik):**
```
claude mcp list → Tüm MCP'ler bağlı mı?
```

**Haftalık (OTOMATİK - Session başında kontrol edilir):**

**Akış:**
```
1. serena list_memories → "last-maintenance-*" ara
2. Tarih kontrolü:
   - Yok veya 7 günden eski → Bakım çalıştır
   - 7 gün içinde → Atla
3. Bakım bittikten sonra:
   serena write_memory("last-maintenance-YYYY-MM-DD", "Bakım tamamlandı")
```

**Kullanıcıya bildir:**
```
🔧 Haftalık bakım çalıştırılıyor (son: 7+ gün önce)...
   ✅ MCP'ler sağlıklı
   ⚠️ repomix güncellemesi mevcut (1.2.3 → 1.3.0)
   Güncellemek ister misin? [Evet / Hayır]
```

| Kontrol | Komut | Aksiyon |
|---------|-------|---------|
| MCP sağlık | `claude mcp list` | Bağlı değilse restart/fix |
| Serena memories | `serena list_memories` | Eski/gereksiz varsa temizle |
| claude-mem DB | `sqlite3 ~/.claude-mem/claude-mem.db "SELECT COUNT(*) FROM observations"` | 0 ise bug devam ediyor |

**Güncelleme Kontrolleri (haftalık):**

| Tool | Versiyon Kontrolü | Güncelleme |
|------|-------------------|------------|
| claude-flow | `npx claude-flow@latest --version` | Otomatik (npx @latest) |
| chrome-devtools | `npx chrome-devtools-mcp@latest --version` | Otomatik (npx @latest) |
| serena | `uvx --from git+https://github.com/oraios/serena serena --version` | `pip install --upgrade` |
| repomix | `repomix --version` vs `npm view repomix version` | `npm update -g repomix` |
| npm global | `npm outdated -g` | `npm update -g` |
| Homebrew | `brew outdated` | `brew upgrade` |

**Otomatik güncellenen (npx @latest):**
- claude-flow ✅
- chrome-devtools-mcp ✅
- @bytebase/dbhub ✅

**Manuel güncelleme gereken:**
- serena (pip/uvx)
- repomix (npm -g)
- claude-mem plugin (claude plugins)

**⚠️ KURAL: Güncelleme yapmadan ÖNCE kullanıcıya sor!**
```
Güncelleme bulundu:
- repomix: 1.2.3 → 1.3.0 (minor)
- serena: 2.0.0 → 3.0.0 (MAJOR - breaking changes olabilir!)

Güncellemek ister misin? [Evet / Hayır / Sadece minor]
```

**Güncelleme önceliği:**
1. 🔴 Security fix → Hemen öner
2. 🟡 Major version → Uyar, breaking changes olabilir
3. 🟢 Minor/Patch → Bildir, kullanıcı karar versin

**Aylık:**

| Kontrol | Aksiyon |
|---------|---------|
| CLAUDE.md review | Güncel mi? Eksik tool var mı? |
| Kullanılmayan MCP | `claude mcp remove` ile kaldır |
| Disk kullanımı | `du -sh ~/.claude*` - gereksiz cache temizle |

### Güncelleme Komutları

```bash
# MCP server güncelle
claude mcp remove <name> && claude mcp add <name> -- <new-command>

# Plugin güncelle (varsa)
claude plugins update <plugin-name>

# npm global paketler
npm update -g
```

---

## ✅ KULLANICI MÜDAHALESİ GEREKTİREN İŞLEMLER (ÖZET)

### Otomatik Çalışan (Kullanıcı bir şey yapmaz):
- ✅ Session başlangıç checklist
- ✅ Proje hafızası okuma (serena memory)
- ✅ MCP sağlık kontrolü
- ✅ Haftalık bakım (7 gün sonra otomatik)
- ✅ Milestone sonrası memory kaydetme (commit, PR, test pass)
- ✅ Tool seçimi ve çalıştırma
- ✅ planning-with-files (3+ adımlı görevlerde)
- ✅ TodoWrite progress tracking

### Kullanıcı Onayı Gereken (Sadece bunlar sorulur):
- ⚠️ **Güncelleme onayı** - Yeni versiyon bulunduğunda
- ⚠️ **Major karar** - Birden fazla geçerli yaklaşım varsa
- ⚠️ **Hata sonrası** - 3 deneme başarısız olduysa

### Kullanıcının Söylemesi Gereken:
- 🎯 **Görev** - Ne yapılacağını belirt (örn: "bug düzelt", "feature ekle")
- 🎯 **Devam/Dur** - Uzun işlemlerde yön ver

**Sonuç:** Kullanıcı sadece görev verir ve kritik kararlarda onay verir. Geri kalan her şey otomatik.
