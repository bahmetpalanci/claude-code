# Claude Code Global Instructions

## SESSION BAŞLANGIÇ (ZORUNLU - İLK PROMPT)

**Proje dizinindeysen (serena bağlıysa):**
```
1. serena list_memories → MUTLAKA çağır
2. Sonucu tara → İlgili memory varsa oku (project_overview, style_conventions, vb.)
3. task_plan.md varsa → "Yarım kalan görev var" bildir
4. Prompt'u analiz et → Aşağıdaki tablolara bak
```

**Not:** Bu adımlar sadece session'ın İLK prompt'unda yapılır, sonrakilerde gerek yok.

---

## Zorunlu Kurallar

| Kural | Detay |
|-------|-------|
| **Skill** | %1 ihtimal bile olsa invoke et |
| **3-Strike** | 3 denemede çözemediysen → Kullanıcıya sor |
| **Test/Build** | Kullanıcı izni gerekli |
| **Major karar** | Birden fazla yaklaşım → Kullanıcıya sor |
| **~/.claude repo** | Her değişiklik sonrası commit & push |

### Güvenlik - ASLA Commit Etme
```
.env, .env.local, credentials.json, secrets.yaml, *.pem, *.key
```

---

## Explicit Komutlar (Kullanıcı Söylediğinde)

| Kullanıcı Ne Diyor | Ne Yap |
|--------------------|--------|
| "repomix kullan/ile" | `repomix --token-count-tree` veya `repomix --compress` |
| "planning-with-files" | `Skill("planning-with-files:planning-with-files")` |
| "brainstorming yap" | `Skill("superpowers:brainstorming")` |
| "systematic-debugging" | `Skill("superpowers:systematic-debugging")` |
| "TDD ile" | `Skill("superpowers:test-driven-development")` |
| "verification" | `Skill("superpowers:verification-before-completion")` |
| "plan yaz" | `Skill("superpowers:writing-plans")` |
| "code review" | `Skill("superpowers:requesting-code-review")` |

---

## Domain → Tool Seçimi

| Prompt İçeriği | Domain | İlk Tool |
|----------------|--------|----------|
| sayfa, browser, UI, görünüm | UI | chrome-devtools → take_snapshot |
| tablo, sütun, query, database | Database | dbhub → search_objects |
| metot, sınıf, fonksiyon + isim | Kod (tek) | serena → find_symbol |
| proje, yapı, mimari, genel | Kod (geniş) | repomix CLI |
| library, npm, maven, paket | Harici | git-mcp → fetch_generic_documentation |
| paralel, multi-agent, aynı anda | Orkestrasyon | claude-flow → agent_spawn |
| hatırla, önceki, memory, context | Hafıza | serena memories / claude-mem |

---

## Intent → Skill Seçimi

| Prompt İçeriği | Skill |
|----------------|-------|
| hata, çalışmıyor, bozuk, fix | `/sc:troubleshoot` |
| ekle, yap, oluştur, implement | `/sc:implement` |
| test, coverage, spec | `/sc:test` |
| analiz, incele, nasıl | `/sc:analyze` |
| refactor, temizle, iyileştir | `/sc:improve` |
| commit, push, PR | `/sc:git` |
| tasarım, mimari | `/sc:design` |

---

## Karmaşıklık → Tracking

| Durum | TodoWrite | Planning Files |
|-------|-----------|----------------|
| 1-2 adım | Evet | - |
| 3-5 adım | Evet | Opsiyonel |
| 6+ adım | Evet | **ZORUNLU** (task_plan.md, findings.md, progress.md) |

---

## Referans Dosyaları

Detaylı bilgi gerektiğinde oku:

| Dosya | Ne Zaman |
|-------|----------|
| `~/.claude/docs/skill-reference.md` | Skill bulamadığında |
| `~/.claude/docs/mcp-reference.md` | MCP config/sorun |
| `~/.claude/docs/cli-reference.md` | CLI komut lazım |
| `~/.claude/docs/workflows.md` | Kompleks task planı |

---

## Hata Durumları

| Hata | Aksiyon |
|------|---------|
| MCP disconnect | `claude mcp list` kontrol |
| 3x tool failure | Kullanıcıya bildir, alternatif öner |
| Skill bulunamadı | `/sc:help` ile listele |

---

## Dil & Format

- Türkçe iletişim tercih edilir
- Kod terimleri İngilizce kalabilir
