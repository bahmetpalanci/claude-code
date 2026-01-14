# Claude Code Global Instructions

## Zorunlu Kurallar

| Kural | Detay |
|-------|-------|
| **Skill** | %1 ihtimal bile olsa invoke et |
| **3-Strike** | 3 denemede cozemediysen → Kullaniciya sor |
| **Test/Build** | Kullanici izni gerekli - sormadan calistirma |
| **Major karar** | Birden fazla yaklasim varsa → Kullaniciya sor |
| **Dongu onleme** | 3 analyze/arastirma sonrasi → Kullaniciya sor |
| **~/.claude repo** | Her degisiklik sonrasi commit & push |

### Guvenlik - ASLA Commit Etme
```
.env, .env.local, .env.production, credentials.json, secrets.yaml
*_secret*, *_key*, *_token*, application-prod.yml, *.pem, *.key
```

---

## Karar Agaci

```
PROMPT GELDI
     |
     v
+---------------------------+
| 1. NE ISTIYOR?            |
|    Bug/Hata → troubleshoot|
|    Feature  → implement   |
|    Test     → test        |
|    Analiz   → analyze     |
|    Refactor → improve     |
|    Git      → git         |
|    Diger    → Tabloya bak |
+---------------------------+
     |
     v
+---------------------------+
| 2. CONTEXT NE?            |
|    Proje var → MCP kullan |
|    6+ adim   → planning   |
|    Her adim  → TodoWrite  |
+---------------------------+
```

---

## Quick Reference

### Gorev → Skill

| Kullanici Ne Diyor | Skill | Tracking |
|--------------------|-------|----------|
| hata, calismıyor, bozuk, fix | `/sc:troubleshoot` | TodoWrite |
| ekle, yap, olustur, implement | `/sc:implement` | TodoWrite |
| test, coverage, spec | `/sc:test` | TodoWrite |
| analiz, incele, bak, nasil | `/sc:analyze` | - |
| commit, push, branch, PR | `/sc:git` | - |
| refactor, temizle, iyilestir | `/sc:improve` | TodoWrite |
| tasarim, mimari, design | `/sc:design` | TodoWrite |
| brainstorm, dusunelim | `/sc:brainstorm` | - |
| dokumantasyon, acikla | `/sc:document` | - |
| build, derle, package | `/sc:build` | - |
| arastir, bul, research | `/sc:research` | - |

> Tam liste: `docs/skill-reference.md`

### Domain → MCP (Proje Icindeyken)

| Domain | MCP | Ilk Tool |
|--------|-----|----------|
| UI/Browser | chrome-devtools | `take_snapshot` |
| Database | dbhub-* | `search_objects` |
| Kod (spesifik) | serena | `find_symbol` |
| Kod (genis) | repomix | `--token-count-tree` |
| Harici repo | git-mcp | `fetch_generic_documentation` |
| Multi-agent | claude-flow | `agent spawn` |
| Gecmis | serena + claude-mem | `list_memories` |

> Detay: `docs/mcp-reference.md`

---

## Tracking

| Karmasiklik | TodoWrite | Planning Files |
|-------------|-----------|----------------|
| Basit (1-2 adim) | Evet | - |
| Orta (3-5 adim) | Evet | Opsiyonel |
| Kompleks (6+) | Evet | **Zorunlu** |
| Multi-session | Evet | **Zorunlu** |

**Planning Files:** `task_plan.md`, `findings.md`, `progress.md`

---

## Superpowers (Otomatik)

Bu skill'ler context'e gore **otomatik aktive** olur:

| Tetikleyici | Skill |
|-------------|-------|
| Feature baslangici | brainstorming |
| Bug fix | systematic-debugging |
| Test yazimi | test-driven-development |
| Is bitiminde | verification-before-completion |
| Multi-step task | writing-plans → executing-plans |

---

## Session Lifecycle (Proje Icindeyken)

```
BASLANGIC:
  serena list_memories → read_memory (ilgili olanlar)
  task_plan.md var mi? → Varsa kullaniciya bildir

CALISMA:
  Skill invoke et (yukaridaki tablodan)
  TodoWrite ile her adimi track et

MILESTONE SONU:
  serena write_memory (ne yapildi, hangi dosyalar degisti)
```

**Milestone:** Commit, PR, Test pass, Major refactoring

---

## Hata Durumlari

| Hata | Aksiyon |
|------|---------|
| serena read failed | "Context bulunamadi, sifirdan mi baslayalim?" |
| MCP disconnect | `claude mcp list` kontrol, kullaniciya bildir |
| 3x tool failure | Durumu acikla, alternatif oner |

> Detay: `docs/troubleshooting.md`

---

## Referanslar

| Dosya | Icerik |
|-------|--------|
| `docs/skill-reference.md` | Tum skill kategorileri |
| `docs/mcp-reference.md` | MCP detaylari ve tool'lar |
| `docs/cli-reference.md` | CLI komutlari |
| `docs/workflows.md` | Gorev akislari |
| `docs/troubleshooting.md` | Hata kurtarma |
| `docs/maintenance.md` | Bakim ve guncelleme |

---

## Dil & Format

- Turkce iletisim tercih edilir
- Kod ve teknik terimler Ingilizce kalabilir
- Tablo formati kullan (okunabilirlik)
