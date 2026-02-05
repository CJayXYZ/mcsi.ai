#!/usr/bin/env node

import { createServer } from 'http';
import { readFileSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

const PORT = 8080;

const server = createServer((req, res) => {
  try {
    // Serve index.html for all requests
    const htmlContent = readFileSync(join(__dirname, 'index.html'), 'utf8');
    
    res.writeHead(200, { 
      'Content-Type': 'text/html',
      'Cache-Control': 'no-cache'
    });
    res.end(htmlContent);
  } catch (error) {
    console.error('Error serving file:', error);
    res.writeHead(500, { 'Content-Type': 'text/plain' });
    res.end('Internal Server Error');
  }
});

server.listen(PORT, () => {
  console.log(`🚀 mcsi.ai server running at http://localhost:${PORT}/`);
  console.log(`📁 Serving from: ${__dirname}`);
  console.log(`⏰ Started at: ${new Date().toISOString()}`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('🛑 Received SIGTERM, shutting down gracefully');
  server.close(() => {
    console.log('✅ Server closed');
    process.exit(0);
  });
});

process.on('SIGINT', () => {
  console.log('🛑 Received SIGINT, shutting down gracefully');
  server.close(() => {
    console.log('✅ Server closed');
    process.exit(0);
  });
});