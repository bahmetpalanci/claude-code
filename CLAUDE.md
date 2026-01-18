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

## 🤖 Otomatik Agent Tetikleme (ZORUNLU)

**Aşağıdaki durumlarda ilgili agent'ı SPAWN ET:**

### Dil/Framework Bazlı
| Tespit | Agent | Tetikleyici |
|--------|-------|-------------|
| Java/Spring/Maven dosyası | `jvm-languages:java-pro` | `.java`, `pom.xml`, Spring annotation |
| Scala/Akka/sbt dosyası | `jvm-languages:scala-pro` | `.scala`, `build.sbt` |
| C#/.NET dosyası | `jvm-languages:csharp-pro` | `.cs`, `.csproj` |

### Görev Bazlı
| Prompt İçeriği | Agent | Ne Zaman |
|----------------|-------|----------|
| API tasarla, endpoint, REST, microservice | `backend-development:backend-architect` | Yeni API/servis tasarımı |
| GraphQL, schema, federation | `backend-development:graphql-architect` | GraphQL işleri |
| event sourcing, CQRS, event store | `backend-development:event-sourcing-architect` | Event-driven mimari |
| workflow, saga, Temporal | `backend-development:temporal-python-pro` | Long-running process |
| güvenlik taraması, vulnerability, SAST | `security-scanning:security-auditor` | Güvenlik analizi |
| threat model, attack surface | `security-scanning:threat-modeling-expert` | Tehdit modelleme |
| GDPR, HIPAA, SOC2, compliance | `security-compliance:security-auditor` | Uyumluluk kontrolü |
| legacy, modernize, Java 8→21 | `code-refactoring:legacy-modernizer` | Eski kod güncelleme |
| test coverage, test automation | `codebase-cleanup:test-automator` | Test altyapısı |
| code review, kalite kontrolü | `codebase-cleanup:code-reviewer` | Kod inceleme |
| secure coding, input validation | `backend-api-security:backend-security-coder` | Güvenli kod yazma |

### Tetikleme Kuralı
```
1. Prompt'u analiz et
2. Yukarıdaki tablolardan eşleşme var mı?
3. EVET → Agent spawn et: Task(subagent_type="plugin:agent-name", prompt="...")
4. Agent sonucunu kullan
```

**Örnek:**
```
Kullanıcı: "Bu Spring Boot servisine yeni endpoint ekle"
→ Java dosyası + Spring + endpoint = java-pro + backend-architect
→ Task(subagent_type="jvm-languages:java-pro", prompt="Spring Boot endpoint ekle...")
```

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
