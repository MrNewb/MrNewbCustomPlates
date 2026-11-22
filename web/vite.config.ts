import path from 'node:path'
import { fileURLToPath } from 'node:url'
import { defineConfig, type Plugin } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

const rootDir = path.dirname(fileURLToPath(import.meta.url))

// FiveM's CEF predates color-mix, so drop the Tailwind blocks that use it
function stripColorMix(): Plugin {
  return {
    name: 'strip-color-mix',
    generateBundle(_options, bundle) {
      for (const item of Object.values(bundle)) {
        if (item.type !== 'asset' || !item.fileName.endsWith('.css')) continue
        const source = typeof item.source === 'string' ? item.source : item.source.toString()
        item.source = source
          .replace(/@supports\s*\(color:\s*color-mix\([^)]*\)\)\{(?:[^{}]|\{[^{}]*\})*\}/g, '')
          .replace(/color-mix\([^)]*\)/g, 'transparent')
      }
    },
  }
}

export default defineConfig({
  plugins: [react(), tailwindcss(), stripColorMix()],
  base: './',
  resolve: { alias: { '@': path.resolve(rootDir, './src') } },
  build: { outDir: 'build', emptyOutDir: true },
})
