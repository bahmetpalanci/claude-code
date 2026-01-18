# Claude Code Global Instructions

## SESSION BAŞLANGIÇ (ZORUNLU - İLK PROMPT)

**Proje dizinindeysen (serena bağlıysa):**
```
1. serena list_memories → MUTLAKA çağır
2. Sonucu tara → İlgili memory varsa oku (project_overview, style_conventions, vb.)
3. task_plan.md varsa → "Yarım kalan görev var" bildir
4. Prompt'u analiz et → Aşağıdaki tablolara bak
```

---

## ⚠️ BELİRSİZLİK KURALI (EN ÖNEMLİ)

**Eğer:**
- Hangi tool/skill/agent kullanacağından emin değilsen
- Birden fazla yaklaşım mümkünse
- Kullanıcının niyeti net değilse

**→ AskUserQuestion tool'unu kullan, seçenekleri sun, TAHMİN ETME**

---

## Zorunlu Kurallar

| Kural | Detay |
|-------|-------|
| **Belirsizlik** | Emin değilsen → AskUserQuestion ile sor |
| **Skill** | %1 ihtimal bile olsa invoke et |
| **3-Strike** | 3 denemede çözemediysen → Kullanıcıya sor |
| **Test/Build** | Kullanıcı izni gerekli |
| **~/.claude repo** | Her değişiklik sonrası commit & push |

### Güvenlik - ASLA Commit Etme
```
.env, .env.local, credentials.json, secrets.yaml, *.pem, *.key
```

---

## Domain → Tool Seçimi

| Prompt İçeriği | İlk Tool |
|----------------|----------|
| sayfa, browser, UI | chrome-devtools |
| tablo, database, SQL | dbhub |
| tek metot/sınıf + isim | serena find_symbol |
| proje yapısı, 10+ dosya | repomix CLI |
| library docs, npm, maven | git-mcp |
| paralel, aynı anda | claude-flow |
| memory, önceki context | serena memories |

---

## Intent → Skill Seçimi

| Prompt İçeriği | Skill |
|----------------|-------|
| hata, çalışmıyor, fix | `/sc:troubleshoot` |
| ekle, yap, implement | `/sc:implement` |
| test, coverage | `/sc:test` |
| analiz, incele | `/sc:analyze` |
| refactor, iyileştir | `/sc:improve` |
| commit, push, PR | `/sc:git` |

---

## Agent Kullanımı

**Detaylı tetikleme kuralları:** `~/.claude/docs/agent-triggers.md`

**Özet:**
- Java/Spring → `java-pro` agent
- API tasarımı → `backend-architect` agent
- Güvenlik → `security-auditor` agent
- Paralel iş → `claude-flow`
- **Belirsiz → AskUserQuestion ile sor**

---

## Karmaşıklık → Tracking

| Durum | TodoWrite | Planning Files |
|-------|-----------|----------------|
| 1-2 adım | Evet | - |
| 3-5 adım | Evet | Opsiyonel |
| 6+ adım | Evet | **ZORUNLU** |

---

## Referans Dosyaları

| Dosya | Ne Zaman |
|-------|----------|
| `docs/agent-triggers.md` | Agent seçimi detayları |
| `docs/skill-reference.md` | Skill listesi |
| `docs/mcp-reference.md` | MCP/Plugin detayları |
| `docs/workflows.md` | Kompleks task planı |

---

## Dil & Format

- Türkçe iletişim tercih edilir
- Kod terimleri İngilizce kalabilir
