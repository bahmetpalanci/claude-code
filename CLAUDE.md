# Global Claude Code Talimatları

## Temel Kurallar

| Kural | Detay |
|-------|-------|
| Test/Build | Kullanıcı izni gerekli - sormadan yapma |
| Derleme | Kullanıcı izni gerekli |
| Tool seçimi | Uygun tool'u sormadan kullan |
| Skill | Uygunsa direkt invoke et |
| Soru sorma | Sadece ciddi belirsizlik varsa |

### Güvenlik - ASLA Commit Etme
```
.env, .env.local, .env.production
credentials.json, secrets.yaml
*_secret*, *_key*, *_token*
application-prod.yml
*.pem, *.key
```

**Uyarı ver:** Hardcoded password/API key, güvenli olmayan HTTP, SQL injection riski

---

## Tool Seçimi

**Prensip:** Anahtar kelime arama, kullanıcının kastını anla.

| Niyet | Tool | Tracking |
|-------|------|----------|
| Yeni işlevsellik eklemek istiyor | `/sc:implement` | TodoWrite |
| Bir şey bozuk/yanlış çalışıyor | `/sc:troubleshoot` | TodoWrite |
| Versiyon kontrolü işlemi | `/sc:git` | - |
| Kodu anlamak/incelemek istiyor | `/sc:analyze` | - |
| Test ile ilgili bir şey | `/sc:test` | TodoWrite |
| Kodu iyileştirmek istiyor | refactoring | TodoWrite |
| Çok adımlı/karmaşık iş | `planning-with-files` | + serena |
| Büyük değişiklik/taşıma | planning-with-files + serena | Hepsi |

**Örnek:**
- "Şu buton çalışmıyor" → Bug (troubleshoot), "buton" kelimesine takılma
- "Login ekle" → Feature (implement), kısa olması önemsiz
- "Şunu bi bak" → Muhtemelen analiz veya debug, bağlamdan anla

---

## Session Akışı

### Başlangıç
```
1. serena list_memories → Proje hafızası var mı?
2. serena read_memory (varsa) → Context yükle
3. task_plan.md var mı? → Yarım görev varsa bildir
```

### Çalışma
- TodoWrite ile progress track et
- 5+ adımlı görevde → planning-with-files başlat
- Önemli kararları not al

### Milestone Sonrası (Otomatik Kaydet)
Commit/PR/Test pass/Major refactoring sonrası:
```
serena write_memory → Bildir: "Context kaydedildi"
```

---

## Tracking Seçimi

| Görev Tipi | TodoWrite | planning-with-files | serena |
|------------|-----------|---------------------|--------|
| Basit (1-2 adım) | Evet | Hayır | Hayır |
| Orta (3-5 adım) | Evet | Opsiyonel | Hayır |
| Kompleks (5+) | Evet | Evet | Milestone'da |
| Multi-session | Evet | Evet | Evet |

---

## MCP Sunucuları

| MCP | Durum | Ana Kullanım |
|-----|-------|--------------|
| serena | Aktif | Semantic analiz, memory |
| chrome-devtools | Aktif | Browser debug |
| git-mcp | Aktif | GitHub docs |
| claude-flow | Aktif | Multi-agent |
| dbhub | Otomatik | Database |
| claude-mem | Opsiyonel | Global memory (sorunlu) |

> Detaylar: `~/.claude/docs/mcp-reference.md`

---

## Pluginler ve Agents

### SC Commands (/sc:*)
`brainstorm`, `implement`, `test`, `analyze`, `troubleshoot`, `git`, `pm`

### SuperClaude Agents (/superclaude:*)
`backend-architect`, `frontend-architect`, `security-engineer`, `performance-engineer`, `system-architect`, `refactoring-expert`, `root-cause-analyst`

### Superpowers (Disiplin Katmanı)
Karmaşık görevlerde kullanılabilir:
- `brainstorming` - Feature tasarımı
- `writing-plans` - Multi-step planlama
- `systematic-debugging` - Karmaşık bug
- `verification-before-completion` - PR öncesi

### Diğer
`jvm-languages`, `backend-development`, `security-scanning`, `code-refactoring`, `planning-with-files`

---

## Kırmızı Çizgiler

1. **3-Strike Rule:** 3 denemede çözemediysen → Kullanıcıya sor
2. **Güvenlik dosyaları:** ASLA commit etme
3. **Major kararlar:** Birden fazla yaklaşım varsa → Kullanıcıya sor
4. **Test/Build:** Kullanıcı izni olmadan çalıştırma

---

## CLI Araçları

### repomix
```bash
repomix                  # Mevcut dizini pack et
repomix --compress       # Sıkıştırılmış output
repomix --remote user/repo
```

**Tetikleyiciler:** Onboarding, major migration, 10+ dosya değişikliği

---

## Hata Durumunda

| Hata | Aksiyon |
|------|---------|
| serena read failed | "Context bulunamadı, sıfırdan mı?" |
| MCP disconnect | `claude mcp list` ile kontrol |
| 3x tool failure | Kullanıcıya açıkla |

> Detaylar: `~/.claude/docs/troubleshooting.md`

---

## Bakım

### CLAUDE.md Değişikliği
```bash
cd ~/.claude && git add -A && git commit -m "Update: <açıklama>" && git push
```

> Detaylar: `~/.claude/docs/maintenance.md`

---

## Referans Dosyaları

Detaylı bilgi için:
- `~/.claude/docs/mcp-reference.md` - MCP araçları
- `~/.claude/docs/workflows.md` - Görev akışları
- `~/.claude/docs/maintenance.md` - Bakım
- `~/.claude/docs/troubleshooting.md` - Hata kurtarma

---

## Dil Tercihi
- Türkçe iletişim tercih edilir
- Kod ve teknik terimler İngilizce kalabilir
