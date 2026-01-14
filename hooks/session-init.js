#!/usr/bin/env node

/**
 * Session Init Hook
 *
 * Checks for incomplete tasks and reminds about session lifecycle.
 * Works alongside claude-mem's session-start hook.
 */

import { existsSync, readFileSync } from 'fs';
import { join } from 'path';

let input = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', (chunk) => {
  input += chunk;
});

process.stdin.on('end', async () => {
  try {
    const payload = input ? JSON.parse(input) : {};
    const { cwd, source } = payload;

    // Only run on startup or /clear
    if (source !== 'startup' && source !== 'clear') {
      console.log(JSON.stringify({ continue: true }));
      process.exit(0);
    }

    const messages = [];

    // Check for task_plan.md in current directory
    if (cwd) {
      const taskPlanPath = join(cwd, 'task_plan.md');
      if (existsSync(taskPlanPath)) {
        try {
          const content = readFileSync(taskPlanPath, 'utf8');
          const lines = content.split('\n').slice(0, 10).join('\n');
          messages.push(`⚠️ YARIM KALAN GÖREV BULUNDU: task_plan.md\n\`\`\`\n${lines}\n...\n\`\`\`\nKullanıcıya sor: "Önceki göreve devam edelim mi?"`);
        } catch (e) {
          messages.push(`⚠️ task_plan.md mevcut ama okunamadı`);
        }
      }

      // Check for progress.md
      const progressPath = join(cwd, 'progress.md');
      if (existsSync(progressPath)) {
        messages.push(`📋 progress.md mevcut - önceki session'dan kalan ilerleme var`);
      }
    }

    // Session lifecycle reminder
    messages.push(`🚀 SESSION BAŞLATILDI - CLAUDE.md kurallarına göre:\n1. Proje context'i için: serena list_memories\n2. Her prompt için: Intent→Action tablosuna bak\n3. Skill gerekiyorsa: HEMEN invoke et`);

    if (messages.length > 0) {
      console.log(JSON.stringify({
        continue: true,
        context: messages.join('\n\n---\n\n')
      }));
    } else {
      console.log(JSON.stringify({ continue: true }));
    }

    process.exit(0);
  } catch (error) {
    // Don't block on errors
    console.log(JSON.stringify({ continue: true }));
    process.exit(0);
  }
});
