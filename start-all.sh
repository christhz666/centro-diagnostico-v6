#!/bin/bash
set -e

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKEND_LOG="/tmp/centro_backend.log"
FRONTEND_LOG="/tmp/centro_frontend.log"

LOCAL_IPS=$(hostname -I 2>/dev/null | xargs)

echo ""
echo "=========================================="
echo "   CENTRO DIAGNÓSTICO - SISTEMA COMPLETO"
echo "=========================================="
echo ""
echo "Directorio base: $BASE_DIR"
echo "IPs locales detectadas: ${LOCAL_IPS:-No detectadas}"

echo "[1/2] Iniciando Backend..."
cd "$BASE_DIR/backend"
nohup npm start > "$BACKEND_LOG" 2>&1 &
BACKEND_PID=$!
cd "$BASE_DIR"
sleep 3

echo "[2/2] Iniciando Frontend..."
cd "$BASE_DIR/frontend"
nohup npm start > "$FRONTEND_LOG" 2>&1 &
FRONTEND_PID=$!
cd "$BASE_DIR"
sleep 3

echo ""
echo "Backend PID:  $BACKEND_PID"
echo "Frontend PID: $FRONTEND_PID"
echo ""
echo "Acceso local:"
echo "  Frontend: http://localhost:3000"
echo "  Backend:  http://localhost:5000"
echo "  Health:   http://localhost:5000/api/health"
if [ -n "$LOCAL_IPS" ]; then
  FIRST_IP=$(echo "$LOCAL_IPS" | awk '{print $1}')
  echo "Acceso en red (ejemplo):"
  echo "  Frontend: http://$FIRST_IP:3000"
  echo "  Backend:  http://$FIRST_IP:5000"
fi
echo ""
echo "Logs:"
echo "  Backend:  tail -f $BACKEND_LOG"
echo "  Frontend: tail -f $FRONTEND_LOG"
