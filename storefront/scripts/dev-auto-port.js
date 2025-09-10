#!/usr/bin/env node
/*
 * Finds the next available port starting from PORT or 8000
 * and runs `next dev` on that port.
 */
const net = require('net')
const { spawn } = require('child_process')

const startPort = parseInt(process.env.PORT, 10) || 8000

function checkPort(port) {
  return new Promise((resolve) => {
    const server = net.createServer()
    server.once('error', (err) => {
      if (err && (err.code === 'EADDRINUSE' || err.code === 'EACCES')) {
        resolve(false)
      } else {
        // For other errors, assume port not usable
        resolve(false)
      }
    })
    server.once('listening', () => {
      server.close(() => resolve(true))
    })
    server.listen(port, '0.0.0.0')
  })
}

async function findOpenPort(from) {
  let port = from
  // Cap attempts to avoid infinite loops
  for (let i = 0; i < 1000; i++) {
    // eslint-disable-next-line no-await-in-loop
    const free = await checkPort(port)
    if (free) return port
    port += 1
  }
  throw new Error('Could not find an open port')
}

async function run() {
  const port = await findOpenPort(startPort)
  if (port !== startPort) {
    console.log(`Port ${startPort} in use. Starting dev server on ${port}...`)
  } else {
    console.log(`Starting dev server on ${port}...`)
  }

  const nextBin = require.resolve('next/dist/bin/next')
  const child = spawn(
    process.execPath,
    [nextBin, 'dev', '-p', String(port)],
    { stdio: 'inherit', env: { ...process.env, PORT: String(port) } }
  )

  child.on('exit', (code) => {
    process.exit(code ?? 0)
  })
}

run().catch((err) => {
  console.error(err)
  process.exit(1)
})
