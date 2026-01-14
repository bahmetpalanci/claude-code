# Claude Code Global Instructions

## 🚨 SESSION BAŞLANGIÇ (ZORUNLU - ATLANMAZ)

```
1. PROJE CONTEXT'I (Proje dizinindeysen)
   serena list_memories → İlgili memory varsa oku
   task_plan.md var mı? → Kullanıcıya bildir: "Yarım kalan görev var"

2. PROMPT ANALİZİ
   └─ Aşağıdaki Intent→Action tablosuna bak
   └─ Skill gerekiyorsa HEMEN invoke et (düşünme, yap)
```

---

## Zorunlu Kurallar

| Kural | Detay |
|-------|-------|
| **Skill** | %1 ihtimal bile olsa invoke et - DÜŞÜNME, YAP |
| **3-Strike** | 3 denemede çözemediysen → Kullanıcıya sor |
| **Test/Build** | Kullanıcı izni gerekli - sormadan çalıştırma |
| **Major karar** | Birden fazla yaklaşım varsa → Kullanıcıya sor |
| **Döngü önleme** | 3 araştırma sonrası → Kullanıcıya sor |
| **~/.claude repo** | Her değişiklik sonrası commit & push |

### Güvenlik - ASLA Commit Etme
```
.env, .env.local, .env.production, credentials.json, secrets.yaml
*_secret*, *_key*, *_token*, application-prod.yml, *.pem, *.key
```

---

## Intent → Action (Detaylı Karar Tablosu)

### Aynı Kelime, Farklı Intent - DİKKAT!

| Prompt Örneği | Anahtar | Gerçek Intent | Tool/Skill |
|---------------|---------|---------------|------------|
| "Sayfada hata var" | hata | UI debug | chrome-devtools → take_snapshot |
| "Bu metotta hata var" | hata | Kod analizi | serena → /sc:troubleshoot |
| "Hata mesajlarını standartlaştır" | hata | Refactoring | plan + /sc:improve |
| "Hata loglama nasıl çalışıyor?" | hata | Context arama | serena memories |
| "Projeyi analiz et" | analiz | Genel yapı | repomix CLI |
| "Bu sınıfı analiz et" | analiz | Tek sembol | serena find_symbol |
| "Network trafiğini analiz et" | analiz | Browser debug | chrome-devtools |
| "Tablo yapısını analiz et" | analiz | DB şema | dbhub search_objects |
| "Bu library nasıl kullanılır?" | nasıl | Harici docs | git-mcp fetch_generic_documentation |
| "Bu metot nasıl çalışıyor?" | nasıl | Kod okuma | serena find_symbol |

---

## 🎯 DETERMINISTIK DECISION TREE (ZORUNLU)

**Her prompt'ta bu ağacı TAKİP ET - atlama, tahmin etme:**

```
ADIM 1: KEYWORD ANALIZI
├─ "sayfa", "browser", "UI", "görünüm" var mı?
│  └─ EVET → Domain: UI → chrome-devtools
│
├─ "tablo", "sütun", "query", "database", "schema" var mı?
│  └─ EVET → Domain: Database → dbhub-*
│
├─ "metot", "sınıf", "fonksiyon", "kod" + spesifik isim var mı?
│  └─ EVET → Domain: Code (spesifik) → serena find_symbol
│
├─ "proje", "yapı", "mimari", "genel" + analiz var mı?
│  └─ EVET → Domain: Code (geniş) → repomix CLI
│
├─ "library", "paket", "npm", "maven", "dependency" + dış kaynak var mı?
│  └─ EVET → Domain: External → git-mcp
│
└─ Hiçbiri değil → Kullanıcıya sor: "Hangi domain? (UI/DB/Kod/Harici)"

ADIM 2: INTENT SINIFLANDIRMA
├─ "hata", "çalışmıyor", "bozuk", "exception", "error" var mı?
│  ├─ UI domain → chrome-devtools + take_snapshot + list_console_messages
│  ├─ DB domain → dbhub search_objects + serena find_referencing_symbols
│  ├─ Code domain → serena find_symbol + /sc:troubleshoot
│  └─ Unknown → serena list_memories → sonra debug
│
├─ "ekle", "yap", "oluştur", "implement", "geliştir" var mı?
│  ├─ Skill: /sc:brainstorming (ÖNCELİKLE)
│  ├─ TodoWrite ile plan
│  └─ Sonra /sc:implement
│
├─ "analiz", "incele", "bak", "anla", "nasıl" var mı?
│  ├─ Spesifik sembol → serena find_symbol
│  ├─ Genel yapı → repomix CLI
│  ├─ Harici → git-mcp fetch_generic_documentation
│  └─ UI → chrome-devtools take_snapshot
│
├─ "refactor", "temizle", "iyileştir", "optimize" var mı?
│  └─ /sc:improve + TodoWrite
│
└─ "test", "coverage", "spec", "doğrula" var mı?
   └─ /sc:test-driven-development

ADIM 3: DOSYA SAYISI THRESHOLD (Kod analizi için)
├─ 1-2 dosya → serena find_symbol
├─ 3-10 dosya → serena find_symbol + serena find_referencing_symbols
└─ 10+ dosya → repomix CLI --token-count-tree

ADIM 4: CONTEXT KONTROLÜ (HER ZAMAN YAP)
serena list_memories
  ├─ İlgili memory var mı?
  │  └─ EVET → Oku, context'e ekle
  └─ HAYIR → Devam et

ADIM 5: EXECUTION SEQUENCE
├─ Parallel yapılabilir mi? (bağımsız tool'lar)
│  └─ EVET → Aynı anda çağır
│
└─ Sequential gerekli mi? (bağımlılık var)
   └─ EVET → Sırayla çağır (örn: memory → find_symbol → debug)
```

**Örnek Walkthrough (Generic)**:

```
Prompt: "User service API failing: database column 'email_verified' missing in users table"

ADIM 1: KEYWORD
  ✓ "column", "database", "table" → Database domain
  ✓ "User service", "API" → Code domain
  → Domain: Code + Database (mixed)

ADIM 2: INTENT
  ✓ "failing" → Debug intent
  → Code domain debug: serena + /sc:troubleshoot
  → DB check: dbhub search_objects

ADIM 3: DOSYA SAYISI
  → "User service" → Typically 3-5 files (service, repository, entity)
  → serena find_symbol + find_referencing_symbols

ADIM 4: CONTEXT
  → serena list_memories
  → Check for related "user", "database", "migration" memories

ADIM 5: SEQUENCE
  1. serena list_memories (parallel)
  2. serena find_symbol "UserService" (parallel)
  ↓ (wait for results)
  3. dbhub search_objects "users" (table schema)
  4. serena find_referencing_symbols "email_verified"
  ↓
  5. /sc:troubleshoot (if root cause unclear)

SONUÇ: 5 adım, deterministik, tekrarlanabilir, domain-agnostic
```

---

## 🔧 TOOL PRECEDENCE MATRIX (Çakışma Çözümü)

**Aynı işi birden fazla tool yapabiliyorsa, bu matrix'e bak:**

| Senaryo | Tool A | Tool B | Hangisi? | Neden |
|---------|--------|--------|----------|-------|
| Tek metot okuma | serena find_symbol | repomix | **serena** | Token efficient, sembolik |
| 10+ dosya analiz | serena | repomix | **repomix** | Geniş scope, hiyerarşi |
| DB şema analiz | dbhub search_objects | serena search_for_pattern | **dbhub** | Specialized, metadata |
| UI debug | chrome-devtools | log files | **chrome-devtools** | Real-time, interactive |
| Harici library docs | git-mcp | Web search | **git-mcp** | Structured, API docs |
| Context arama | serena memories | Re-read files | **serena memories** | Condensed, pre-digested |
| Kod değişikliği | serena replace_symbol_body | Edit tool | **serena** | Symbol-aware, safe |
| Yeni dosya | Write tool | serena insert | **Write** | serena is for existing code |
| Paralel işler | Sequential agent calls | claude-flow | **claude-flow** | True parallelism |
| Intent detection | Manual LLM decision | claude-flow agent | **claude-flow** | Deterministic, cacheable |

**Çakışma Durumu Örneği (Generic)**:

```
Prompt: "Analyze the AuthenticationService class"

Seçenekler:
  A) serena find_symbol "AuthenticationService" depth=1
  B) repomix --include "**/AuthenticationService.*"
  C) Read tool ile dosyayı oku

MATRIX'E BAK:
  → Tek sınıf analiz → serena
  → Neden: Token efficient, sembolik yapı, dil-agnostic

KARAR: serena find_symbol ✓ (works for Java, Python, TypeScript, etc.)
```

---

## ✅ MANDATORY EXECUTION PROTOCOL (Atlama = Hata)

**Her prompt'ta bu checklist'i TAKİP ET:**

```markdown
## Pre-Execution
[ ] 1. serena list_memories → İlgili memory var mı?
[ ] 2. Decision Tree'yi takip et → Domain + Intent belirle
[ ] 3. Tool Precedence Matrix'e bak → Doğru tool'u seç
[ ] 4. Skill gerekiyor mu? → %1 ihtimal bile olsa invoke et
[ ] 5. TodoWrite gerekiyor mu? → 2+ adım varsa oluştur

## Execution
[ ] 6. Tool sequence'ı belirle → Parallel mı, sequential mi?
[ ] 7. İlk tool çağrısı → Sonucu bekle
[ ] 8. Sonraki tool çağrıları → Dependency'lere göre
[ ] 9. Ara değerlendirme → 3 tool'dan sonra yeterli mi kontrol

## Post-Execution
[ ] 10. Sonuç sentezi → Kullanıcıya net cevap
[ ] 11. TodoWrite güncelle → Tamamlanan adımları mark et
[ ] 12. Memory write gerekiyor mu? → Major milestone ise yaz
[ ] 13. Quality check → "Gerçekten çözüldü mü?"
```

**Enforcement Mekanizması**:

```
EĞER 3 tool çağrısı yaptım AMA hala cevap yok
  → STOP
  → Kullanıcıya sor: "Şu kadar araştırma yaptım, daha fazla mı yoksa farklı yaklaşım mı?"

EĞER skill invoke edilmesi gerekiyordu AMA etmedim
  → Kullanıcıya özür: "Skill atlayarak hata yaptım, şimdi invoke ediyorum"
  → Skill invoke et

EĞER memory check yapmadım
  → Kullanıcıya bildir: "Memory check yapılmadı, şimdi yapıyorum"
  → serena list_memories

EĞER TodoWrite gerekiyordu AMA oluşturmadım
  → Hemen oluştur, retroaktif adımları ekle
```

**Örnek Enforcement (Generic)**:

```
❌ YANLIŞ:
User: "Payment API throwing database error"
Assistant: [Direk serena find_symbol çağırıyor]

❓ Sorun: Memory check yok, skill yok, decision tree takip edilmedi

✅ DOĞRU:
User: "Payment API throwing database error"
Assistant:
  [✓] serena list_memories (payment, API, DB context)
  [✓] Decision Tree → Code + Database debug
  [✓] /sc:troubleshoot skill invoke
  [✓] TodoWrite oluştur (5+ steps = medium complexity)
  [✓] serena find_symbol → PaymentService
  [✓] dbhub search_objects → payments (table schema)
  [✓] serena find_referencing_symbols → (DB column usage)
  [✓] Synthesis + root cause
```

---

### Intent Belirleme Soruları

```
1. KAPSAM: Tek dosya/sembol mü, proje geneli mi?
   └─ Tek → serena | Geniş → repomix

2. DOMAIN: Kod mu, UI mu, DB mi, harici library mi?
   └─ Kod → serena | UI → chrome-devtools | DB → dbhub | Library → git-mcp

3. AMAÇ: Okuma mı, yazma mı, debug mu?
   └─ Debug → chrome-devtools/logs | Okuma → serena | Yazma → serena + plan

4. CONTEXT: Geçmişe mi bakıyor, şimdiki duruma mı?
   └─ Geçmiş → serena memories | Şimdi → diğer tool'lar
```

---

## Görev → Skill Mapping

| Kullanıcı Ne Diyor | Skill | Tracking |
|--------------------|-------|----------|
| hata, çalışmıyor, bozuk, fix | `/sc:troubleshoot` | TodoWrite |
| ekle, yap, oluştur, implement | `/sc:implement` | TodoWrite |
| test, coverage, spec | `/sc:test` | TodoWrite |
| analiz, incele, bak, nasıl | `/sc:analyze` | - |
| commit, push, branch, PR | `/sc:git` | - |
| refactor, temizle, iyileştir | `/sc:improve` | TodoWrite |
| tasarım, mimari, design | `/sc:design` | TodoWrite |
| brainstorm, düşünelim | `/sc:brainstorm` | - |
| dokümantasyon, açıkla | `/sc:document` | - |
| build, derle, package | `/sc:build` | - |
| araştır, bul, research | `/sc:research` | - |
| güvenlik, security | `/sc:analyze` + security-scanning skills | TodoWrite |

---

## Domain → MCP Mapping

| Domain | MCP | İlk Tool | Ne Zaman |
|--------|-----|----------|----------|
| UI/Browser | chrome-devtools | `take_snapshot` | Sayfa görselleştirme, JS hata, network |
| Database | dbhub-* | `search_objects` | Şema, veri sorgulama |
| Kod (spesifik) | serena | `find_symbol` | Tek sembol/metot/sınıf |
| Kod (geniş) | repomix CLI | `--token-count-tree` | Tüm proje yapısı, 10+ dosya |
| Harici repo/lib | git-mcp | `fetch_generic_documentation` | Library docs, API referans |
| Multi-agent | claude-flow | `agent_spawn` | Paralel işler, karmaşık orkestrasyon |
| Proje hafızası | serena | `list_memories` | Önceki context, kararlar |

---

## Superpowers (Otomatik Tetiklenir)

| Tetikleyici | Skill | Ne Yapar |
|-------------|-------|----------|
| Feature başlangıcı | brainstorming | Socratic design discovery |
| Bug fix başlangıcı | systematic-debugging | 4-fazlı root cause analysis |
| Test yazımı | test-driven-development | RED-GREEN-REFACTOR |
| İş bitiminde | verification-before-completion | Gerçekten çalışıyor mu? |
| Multi-step task | writing-plans → executing-plans | Checkpoint'li execution |
| PR öncesi | requesting-code-review | Pre-review checklist |

**ÖNEMLİ:** Bu skill'ler invoke edilmeli - "otomatik" demek "Claude'un kendisi invoke etmeli" demek.

---

## Tracking

| Karmaşıklık | TodoWrite | Planning Files |
|-------------|-----------|----------------|
| Basit (1-2 adım) | Evet | - |
| Orta (3-5 adım) | Evet | Opsiyonel |
| Kompleks (6+) | Evet | **ZORUNLU** |
| Multi-session | Evet | **ZORUNLU** |

**Planning Files:** `task_plan.md`, `findings.md`, `progress.md`

---

## Session Lifecycle

```
BAŞLANGIÇ (Session açıldığında):
  ├─ serena list_memories → İlgili olanları oku
  └─ task_plan.md kontrol → Yarım iş varsa bildir

ÇALIŞMA (Her prompt'ta):
  ├─ Intent→Action tablosuna bak
  ├─ Uygun skill invoke et
  └─ TodoWrite ile track et

MILESTONE (Commit, PR, Test pass, Major refactoring):
  └─ serena write_memory → Ne yapıldı, hangi dosyalar değişti
```

---

## Hata Durumları

| Hata | Aksiyon |
|------|---------|
| serena read failed | "Context bulunamadı, sıfırdan mı başlayalım?" |
| MCP disconnect | `claude mcp list` kontrol, kullanıcıya bildir |
| 3x tool failure | Durumu açıkla, alternatif öner |
| Skill bulunamadı | `/sc:help` ile listele, en yakın eşleşmeyi kullan |
| repomix timeout | `--include` ile kapsamı daralt |

---

## Dil & Format

- Türkçe iletişim tercih edilir
- Kod ve teknik terimler İngilizce kalabilir
- Tablo formatı kullan (okunabilirlik)
