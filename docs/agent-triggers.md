# Agent Tetikleme Rehberi

> Bu dosya CLAUDE.md'den referans olarak okunur.

---

## Dil/Framework Bazlı Tetikleme

| Tespit | Agent | Tetikleyici |
|--------|-------|-------------|
| Java/Spring/Maven dosyası | `jvm-languages:java-pro` | `.java`, `pom.xml`, Spring annotation |
| Scala/Akka/sbt dosyası | `jvm-languages:scala-pro` | `.scala`, `build.sbt` |
| C#/.NET dosyası | `jvm-languages:csharp-pro` | `.cs`, `.csproj` |

---

## Görev Bazlı Tetikleme

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

---

## Claude-Flow (Paralel İşler)

| Durum | Aksiyon |
|-------|---------|
| 2+ bağımsız analiz görevi | `claude-flow agent_spawn` ile paralel çalıştır |
| Birden fazla dosya/modül inceleme | Her biri için ayrı agent spawn et |
| Test + Lint + Build aynı anda | Paralel agent'lar |
| "aynı anda", "paralel", "eş zamanlı" | claude-flow kullan |

**Tetikleyici Kelimeler:**
- "X ve Y'yi aynı anda analiz et"
- "Paralel çalıştır"
- "Hem ... hem ..."
- 3+ dosya/modül analizi
- Bağımsız görevler listesi

---

## Tetikleme Akışı

```
1. Prompt'u analiz et
2. Yukarıdaki tablolardan eşleşme var mı?
3. EVET → Agent spawn et: Task(subagent_type="plugin:agent-name", prompt="...")
4. Paralel iş var mı? → claude-flow agent_spawn
5. BELİRSİZ → AskUserQuestion ile kullanıcıya sor
6. Agent sonucunu kullan
```

---

## Örnekler

### Örnek 1 - Tek Agent
```
Kullanıcı: "Bu Spring Boot servisine yeni endpoint ekle"
→ Java dosyası + Spring + endpoint = java-pro + backend-architect
→ Task(subagent_type="jvm-languages:java-pro", prompt="Spring Boot endpoint ekle...")
```

### Örnek 2 - Claude-Flow Paralel
```
Kullanıcı: "src/auth, src/api ve src/models modüllerini analiz et"
→ 3 bağımsız modül = paralel analiz
→ claude-flow agent_spawn × 3 (her modül için)
→ Sonuçları birleştir
```

### Örnek 3 - Test + Build Paralel
```
Kullanıcı: "Test çalıştır ve build et"
→ Test ⊥ Build (bağımsız)
→ claude-flow ile paralel çalıştır
```

### Örnek 4 - Belirsiz Durum
```
Kullanıcı: "Bu kodu iyileştir"
→ Hangi açıdan? Performans? Güvenlik? Okunabilirlik?
→ AskUserQuestion ile sor
→ Cevaba göre uygun agent seç
```
