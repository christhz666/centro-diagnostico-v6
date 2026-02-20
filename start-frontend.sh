#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR/frontend"

echo "=========================================="
echo "   CENTRO DIAGNÓSTICO - FRONTEND"
echo "=========================================="
echo ""

if [ ! -d "node_modules" ]; then
  echo "Instalando dependencias frontend..."
  npm install
fi

echo "Iniciando React..."
npm start
