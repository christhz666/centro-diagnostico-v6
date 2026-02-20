#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR/backend"

echo "=========================================="
echo "   CENTRO DIAGNÓSTICO - BACKEND"
echo "=========================================="
echo ""

if [ ! -f ".env" ]; then
  echo "⚠️  No existe backend/.env. Copia backend/.env.example -> backend/.env"
fi

if [ ! -d "node_modules" ]; then
  echo "Instalando dependencias backend..."
  npm install
fi

echo "Iniciando backend Node..."
npm start
