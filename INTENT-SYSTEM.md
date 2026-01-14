# Intent Detection & Tool Routing System

**Version**: 1.0.0
**Date**: 2026-01-14
**Status**: Prototype → Production

---

## 🎯 Amaç

Kullanıcı prompt'larından otomatik olarak:
1. **Intent tespit et** (debug, implement, analyze, vb.)
2. **Domain belirle** (UI, database, code, external)
3. **Tool seç** (serena, chrome-devtools, dbhub, vb.)
4. **Execution sequence oluştur** (parallel/sequential)
5. **Skill invoke et** (gerekirse)

→ **Sonuç**: Deterministik, tekrarlanabilir, yüksek doğruluklu karar alma.

---

## 📂 Dosya Yapısı

```
~/.claude/
├── CLAUDE.md                          # Ana konfigürasyon (güncellenmiş)
│   ├── 🎯 DETERMINISTIK DECISION TREE (YENİ)
│   ├── 🔧 TOOL PRECEDENCE MATRIX (YENİ)
│   └── ✅ MANDATORY EXECUTION PROTOCOL (YENİ)
│
├── INTENT-SYSTEM.md                   # Bu dosya (sistem dokümantasyonu)
│
├── agents/
│   └── intent-classifier.yaml         # Agent tanımı (claude-flow için)
│
├── scripts/
│   └── test-intent-classifier.sh      # Test suite
│
└── test-results/                      # Test çıktıları
    ├── test-1.json
    ├── test-2.json
    └── ...
```

---

## 🚀 Kullanım

### Manuel Mod (Şu An Aktif)

Claude her prompt'ta **CLAUDE.md Decision Tree**'yi takip eder:

```
1. Keyword analizi → Domain belirleme
2. Intent sınıflandırma → Skill seçimi
3. File count estimation → Tool seçimi (serena vs repomix)
4. Tool Precedence Matrix → Çakışma çözümü
5. Execution Protocol → Mandatory checklist
```

**Avantaj**: Hemen kullanıma hazır, ek bağımlılık yok
**Dezavantaj**: LLM'e bağımlı, %100 deterministik değil

### Otomatik Mod (Prototype, Gelecek İçin)

Intent Classifier Agent kullanılır:

```bash
# 1. Agent'ı spawn et
claude-flow agent_spawn \
  --config ~/.claude/agents/intent-classifier.yaml \
  --input "Polen KSeF hatası"

# 2. JSON output al
{
  "domain": "code_specific",
  "intent": "debug",
  "recommended_tools": [...],
  "execution_sequence": [...]
}

# 3. Ana Claude bu JSON'a göre hareket eder (execution)
```

**Avantaj**: %100 deterministik, cache'lenebilir, hızlı
**Dezavantaj**: claude-flow entegrasyonu gerekir

---

## 📊 Test Senaryoları

### Test 1: Database + Code Debug
**Prompt**: "Polen KSeF fatura kuyruğunda certificate_type column missing hatası"

**Beklenen Output**:
```json
{
  "domain": "code_specific",
  "intent": "debug",
  "recommended_tools": [
    {"tool": "serena", "action": "list_memories", "priority": 1},
    {"tool": "serena", "action": "find_symbol", "priority": 2},
    {"tool": "dbhub", "action": "search_objects", "priority": 3}
  ],
  "skill_required": "/sc:troubleshoot",
  "complexity": "medium"
}
```

### Test 2: UI Debug
**Prompt**: "Login sayfasında hata var, console'da error görünüyor"

**Beklenen Output**:
```json
{
  "domain": "ui",
  "intent": "debug",
  "recommended_tools": [
    {"tool": "chrome-devtools", "action": "take_snapshot", "priority": 1},
    {"tool": "chrome-devtools", "action": "list_console_messages", "priority": 2}
  ],
  "skill_required": null,
  "complexity": "simple"
}
```

### Test 3: Feature Implementation
**Prompt**: "User authentication ekle"

**Beklenen Output**:
```json
{
  "domain": "code_broad",
  "intent": "implement",
  "recommended_tools": [
    {"tool": "serena", "action": "list_memories", "priority": 1}
  ],
  "skill_required": "/sc:brainstorming",  # ÖNCELİKLE
  "complexity": "complex"
}
```

### Test 4: External Library Research
**Prompt**: "Spring Security nasıl kullanılır?"

**Beklenen Output**:
```json
{
  "domain": "external",
  "intent": "analyze",
  "recommended_tools": [
    {"tool": "git-mcp", "action": "fetch_generic_documentation", "priority": 1}
  ],
  "skill_required": null,
  "complexity": "simple"
}
```

---

## 🧪 Nasıl Test Edilir

```bash
# 1. Test script'i çalıştırılabilir yap
chmod +x ~/.claude/scripts/test-intent-classifier.sh

# 2. Test suite'i çalıştır
~/.claude/scripts/test-intent-classifier.sh

# 3. Manuel validation
# Her test case için:
#   - Prompt'u CLAUDE.md Decision Tree'ye göre manuel analiz et
#   - Agent output ile karşılaştır
#   - Doğruluk oranı hesapla
```

---

## 📈 Başarı Metrikleri

| Metrik | Target | Ölçüm Yöntemi |
|--------|--------|---------------|
| **Intent Accuracy** | >95% | Doğru intent tespit / Toplam test |
| **Tool Selection Accuracy** | >90% | Doğru tool seçimi / Toplam test |
| **Sequence Optimality** | >85% | Gereksiz tool call yok / Toplam |
| **Response Time** | <30s | Intent detection → İlk tool execution |
| **Cache Hit Rate** | >70% | Cached response / Toplam query |

---

## 🔄 Roadmap

### ✅ Tamamlandı (2026-01-14)

- [x] CLAUDE.md Decision Tree eklendi
- [x] Tool Precedence Matrix eklendi
- [x] Mandatory Execution Protocol eklendi
- [x] Intent Classifier Agent tanımı (YAML)
- [x] Test script şablonu

### 🔨 Devam Eden (Bu Hafta)

- [ ] claude-flow MCP ile agent entegrasyonu
- [ ] 8 test senaryosu çalıştır
- [ ] Accuracy benchmarking
- [ ] False positive analizi

### 🚀 Gelecek (Bu Ay)

- [ ] Production deployment
- [ ] Caching mekanizması
- [ ] Metrics dashboard
- [ ] A/B testing (manuel vs otomatik)

### 🔮 Uzun Vade

- [ ] MCP Router custom server (Option C)
- [ ] Pre-processing hook (Option A)
- [ ] ML-based intent refinement (isteğe bağlı)

---

## 🎓 Nasıl Çalışıyor

### Decision Tree Örneği

```
User: "Login sayfası hata veriyor ama kod temiz görünüyor"
           ↓
    KEYWORD ANALIZI
    ✓ "sayfa" bulundu → UI domain
    ✓ "hata" bulundu → Debug intent
           ↓
    INTENT CLASSIFICATION
    → UI + debug → chrome-devtools
           ↓
    TOOL PRECEDENCE MATRIX
    → chrome-devtools > log files (Real-time, interactive)
           ↓
    EXECUTION SEQUENCE
    1. chrome-devtools.take_snapshot (parallel)
    2. chrome-devtools.list_console_messages (parallel)
    ↓
    3. Synthesis: "Console'da X hatası var, Y satırında"
           ↓
    MEMORY WRITE (if milestone)
    → serena write_memory
```

### Enforcement

```
❌ YANLIŞ AKIŞ:
  User → Claude → Tahmin → Tool Call → Belki Doğru

✅ DOĞRU AKIŞ:
  User → Claude → Decision Tree → Tool Precedence → Execution Protocol → Tool Call → Doğru
```

---

## 💡 SSS

### S: Neden LLM hala decision tree'yi yorumluyor?

**C**: Prototype fazındayız. Gelecekte intent-classifier agent otomatik çalışacak.

### S: Agent olmadan da deterministik olabilir miyiz?

**C**: Kısmen. CLAUDE.md Decision Tree kuralları net ama LLM yine yorumluyor. %85-90 doğruluk.

### S: Agent'la %100 deterministik mi?

**C**: Teorik olarak evet. Haiku (sıcaklık=0) ile aynı input → aynı output.

### S: Cache nasıl çalışacak?

**C**: Intent classifier sonuçları cache'lenir (TTL: 1 saat). Aynı prompt → anında sonuç.

### S: Şu an production'da kullanılabilir mi?

**C**: Manuel mod (Decision Tree) evet. Otomatik mod (agent) henüz prototype.

---

## 🤝 Katkı

Yeni test senaryoları eklemek için:

```bash
# test-intent-classifier.sh dosyasına prompt ekle
TEST_PROMPTS+=(
    "Yeni test senaryosu buraya"
)
```

Accuracy raporlamak için:

```bash
# test-results/ altında JSON output'u incele
cat test-results/test-1.json
```

---

## 📝 Notlar

- **Manuel mod** her zaman fallback olarak kalacak (fail-safe)
- **Agent mod** production'a geçmeden extensive testing gerekli
- **Metrics** sürekli izlenmeli (accuracy drift detection)

---

**Son Güncelleme**: 2026-01-14
**Maintainer**: Claude Code System
**Feedback**: Issues via session logs
