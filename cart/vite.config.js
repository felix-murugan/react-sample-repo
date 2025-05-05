export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    port: 5173,
    strictPort: true,
    open: true, // Don't open the browser automatically in CI
  },
  build: {
    sourcemap: true, // Enable sourcemaps in build (useful for debugging)
  },
})
