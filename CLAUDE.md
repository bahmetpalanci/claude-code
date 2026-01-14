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
