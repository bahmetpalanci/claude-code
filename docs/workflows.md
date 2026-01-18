# Detaylı Görev Akışları

> Bu dosya gerektiğinde referans amaçlıdır. Session'da otomatik yüklenmez.

---

## Yeni Özellik Akışı

```
1. Brainstorming (superpowers:brainstorming)
   └─ Socratic design discovery
   └─ Alternatif yaklaşımları değerlendir

2. Gereksinim analizi
   ├─ Belirsizlik varsa kullanıcıya sor
   ├─ Library kullanılacaksa → git-mcp ile docs fetch
   └─ DB değişikliği varsa → dbhub ile şema kontrol

3. Planlama
   ├─ Basit → Direkt başla
   └─ Kompleks → planning-with-files başlat

4. Implementation
   └─ /sc:implement veya direkt kod yaz

5. Doğrulama
   ├─ Kullanıcı isterse test çalıştır
   └─ Frontend varsa → chrome-devtools ile UI test

6. Tamamlama
   └─ serena write_memory (milestone ise)
```

---

## Bug Düzeltme Akışı

```
1. Hata analizi
   ├─ Backend → /sc:troubleshoot + serena
   └─ Frontend → /sc:troubleshoot + chrome-devtools
       ├─ take_snapshot → DOM durumu
       ├─ list_console_messages → JS hataları
       └─ list_network_requests → API hataları

2. DB ile ilgiliyse
   └─ dbhub execute_sql → Veri kontrolü

3. Root cause bul
   └─ Log, stack trace, kod oku

4. Fix uygula

5. Doğrulama
   └─ Kullanıcı isterse test çalıştır

6. Tamamlama
```

---

## Migration/Major Değişiklik Akışı

```
1. serena read_memory → Mevcut context

2. planning-with-files başlat
   ├─ task_plan.md → Fazlar, hedefler
   ├─ findings.md → Araştırma bulguları
   └─ progress.md → Session log

3. Fazlar halinde implement
   └─ Her faz sonunda progress.md güncelle

4. serena write_memory → Context kaydet

5. repomix (opsiyonel) → Baseline güncelle
```

---

## Superpowers Entegrasyonu

Superpowers = Disiplin katmanı. Karmaşık görevlerde kullanılabilir:

| Superpowers Skill | Ne Zaman |
|-------------------|----------|
| `brainstorming` | Feature tasarımı |
| `writing-plans` | Multi-step task planı |
| `test-driven-development` | TDD gerektiren durumlar |
| `systematic-debugging` | Karmaşık bug |
| `verification-before-completion` | PR öncesi |

**Not:** Basit görevlerde superpowers zorunlu değil.

---

## Session Akışı

> **Detay için:** Ana CLAUDE.md → Session Lifecycle bölümüne bak.

**Kısa özet:**
1. `serena list_memories` → Context yükle
2. Görev tipine göre skill seç (CLAUDE.md tablosu)
3. Milestone'da `serena write_memory`

**Milestone:** Commit, PR, Test pass, Major refactoring

---

## Multi-Session Devam

Önceki görev yarım kaldıysa:

```
1. task_plan.md kontrol et
2. Varsa ve tamamlanmamışsa:
   ├─ progress.md oku → Son durum
   └─ Kullanıcıya bildir: "Yarım kalan görev var"
3. Devam kararı kullanıcıda
```

---

## Onboarding (Yeni Proje)

```
1. serena onboarding → Proje yapısını öğren
2. Kullanıcıya sor: "Projenin amacı? Ana teknolojiler?"
3. repomix çalıştır (opsiyonel) → Baseline
4. serena write_memory → Bilgileri kaydet
```
