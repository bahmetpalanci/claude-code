# Detaylı Görev Akışları

> Bu dosya gerektiğinde referans amaçlıdır. Session'da otomatik yüklenmez.

---

## Yeni Özellik Akışı

```
1. Gereksinim analizi
   └─ Belirsizlik varsa kullanıcıya sor

2. Planlama
   ├─ Basit → Direkt başla
   └─ Kompleks → planning-with-files başlat

3. Implementation
   └─ /sc:implement veya direkt kod yaz

4. Doğrulama
   └─ Kullanıcı isterse test çalıştır

5. Tamamlama
   └─ serena write_memory (milestone ise)
```

---

## Bug Düzeltme Akışı

```
1. Hata analizi
   └─ /sc:troubleshoot veya manuel araştır

2. Root cause bul
   └─ Log, stack trace, kod oku

3. Fix uygula

4. Doğrulama
   └─ Kullanıcı isterse test çalıştır

5. Tamamlama
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

### Başlangıç
```
1. serena list_memories → Proje hafızası var mı?
2. serena read_memory (varsa) → Context yükle
3. task_plan.md var mı? → Devam mı, yeni mi?
```

### Çalışma Sırasında
- TodoWrite ile progress track et
- Kompleks görevde planning-with-files kullan
- Önemli kararları not al

### Bitiş (Milestone)
```
Milestone = Commit, PR, Test pass, Major refactoring

→ serena write_memory otomatik çalışır
→ Kullanıcıya bildir: "Context kaydedildi"
```

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
