# CLI Reference

> Bu dosya gerektiginde referans amaçlidir. Session'da otomatik yuklenmez.

---

## Maven

```bash
# Derleme
./mvnw compile
./mvnw clean compile

# Test
./mvnw test
./mvnw test -Dtest=ClassName

# Paketleme
./mvnw package
./mvnw clean package -DskipTests

# Calistirma
./mvnw spring-boot:run

# Install
./mvnw install
./mvnw install:install-file -Dfile=... -DgroupId=... -DartifactId=... -Dversion=...
```

---

## Gradle

```bash
# Derleme
./gradlew build
./gradlew clean build

# Test
./gradlew test

# Calistirma
./gradlew bootRun
```

---

## Git

```bash
# Durum
git status
git diff
git diff --staged

# Log
git log --oneline -10
git log --graph --oneline --all

# Branch
git branch
git checkout -b feature/xyz
git switch main

# Commit
git add -A
git commit -m "mesaj"
git push origin feature/xyz

# PR (GitHub CLI)
gh pr create --title "baslik" --body "aciklama"
gh pr list
gh pr view 123
```

---

## Repomix

```bash
# Token dagilimi gorsellelstir
repomix --token-count-tree

# Sikistirilmis analiz (~%70 token azaltma)
repomix --compress

# Harici repo analizi
repomix --remote user/repo --compress

# Filtreleme
repomix --include "src/**/*.ts" --ignore "**/*.test.ts"

# XML cikti (AI icin)
repomix --compress --style xml -o analysis.xml

# MCP server modu
repomix --mcp

# Skill olustur
repomix --skill-generate
```

---

## Claude MCP

```bash
# Bagli MCP'leri listele
claude mcp list

# MCP ekle
claude mcp add <name> -- <command>

# MCP kaldir
claude mcp remove <name>

# Ornekler
claude mcp add dbhub-dev -- npx -y @bytebase/dbhub --dsn "postgresql://..."
claude mcp add git-mcp -- npx -y mcp-remote https://gitmcp.io/docs
```

---

## Docker

```bash
# Imaj
docker build -t myapp .
docker images

# Container
docker run -d -p 8080:8080 myapp
docker ps
docker logs <container-id>
docker stop <container-id>

# Compose
docker-compose up -d
docker-compose down
docker-compose logs -f
```

---

## Node/npm

```bash
# Install
npm install
npm install <package>
npm install -g <package>

# Run
npm run build
npm run test
npm run dev

# Update
npm update
npm update -g
```

---

## Python

```bash
# Virtual environment
python3 -m venv venv
source venv/bin/activate

# Install
pip install -r requirements.txt
pip install <package>

# Run
python3 script.py
uvicorn main:app --reload
```

---

## Homebrew (macOS)

```bash
# Install
brew install <package>

# Update
brew update
brew upgrade

# List
brew list
```

---

## Sistem

```bash
# Port kontrol
lsof -i :8080

# Process
ps aux | grep java
pkill -f "java"

# Disk
du -sh ~/.claude*
df -h
```
