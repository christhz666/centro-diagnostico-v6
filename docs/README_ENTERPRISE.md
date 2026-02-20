# Centro Diagnóstico v6 - Guía de implementación (Web + Instalación local)

## Lo implementado en esta entrega

- **Registro clínico por orden** con identificador numérico de 5 dígitos (`00001`, `00002`, ...).
- **Código de barras lógico por orden** en formato `ORD00001` para escaneo en áreas fuera de registro.
- **Búsqueda separada**:
  - por ID/código de barras de registro (devuelve la orden de ese día/registro),
  - por datos del paciente (nombre, teléfono o cédula; devuelve historial global).
- **Personalización por centro**:
  - logos para login, factura y resultados,
  - datos fiscales/identidad (nombre, RNC, dirección, teléfono, email),
  - colores de plantilla (`color_primario`, `color_secundario`, `color_acento`).
- **Registro de menores**: permite registrar paciente menor de edad sin cédula.

## Endpoints nuevos/ajustados

- `GET /api/citas/registro/:registroId`
  - Busca por `00001`, `ORD00001` o equivalente.
  - Responde con la cita/orden y sus resultados asociados.
- `GET /api/citas/busqueda/paciente?query=...`
  - Busca por nombre, apellido, teléfono o cédula.
  - Devuelve historial por paciente ordenado por más reciente.

## Flujo recomendado (recepción)

1. Buscar paciente existente por nombre/cédula/teléfono.
2. Si no existe, registrar (menor o adulto).
3. Seleccionar exámenes por área.
4. Crear orden/cita y generar factura.
5. Imprimir factura con barcode y número de registro.
6. En laboratorio/rayos/sonografía usar escáner para abrir la orden por `ORDxxxxx`.

## Instalación Web (servidor Oracle VPS Ubuntu 22.04)

1. Instalar dependencias base:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git nodejs npm mongodb
```

2. Backend:

```bash
cd backend
npm install
cp .env.example .env  # ajustar variables
npm run dev
```

3. Frontend:

```bash
cd frontend
npm install
npm start
```

4. Producción sugerida:
- Node API con `pm2` o `systemd`.
- Nginx como reverse proxy.
- SSL con Let's Encrypt.

## Instalación Desktop (base nativa)

El repositorio incluye base de cliente nativo Qt6 en `desktop-qt6/`:

```bash
cmake -S desktop-qt6 -B desktop-qt6/build
cmake --build desktop-qt6/build
```

Para modo enterprise en laboratorio:
- desplegar app de escritorio en PC local,
- sincronizar con servidor central por API segura,
- usar cola local offline-first para continuidad operativa.

## Nota de alcance

Se priorizó funcionalidad estable para:
- identificación por orden/registro,
- escaneo operativo,
- personalización multi-centro,
- base para web + instalación local real (sin emular web).

Siguiente fase recomendada: hardening de integración LIS (HL7 listeners por equipo) y módulo PACS (Orthanc + viewer).


## Configuración multi-servidor (IP/host por instancia)

Cada servidor debe tener su propio `backend/.env` (copiado de `backend/.env.example`) con sus valores:

- `HOST` y `PORT`
- `PUBLIC_API_URL`
- `FRONTEND_URL`
- `CORS_ORIGINS`
- `MONGODB_URI`

Ejemplo:

```env
HOST=0.0.0.0
PORT=5000
PUBLIC_API_URL=https://lab-a.midominio.com/api
FRONTEND_URL=https://lab-a.midominio.com
CORS_ORIGINS=https://lab-a.midominio.com,http://10.0.0.12:3000
MONGODB_URI=mongodb://127.0.0.1:27017/centro_diagnostico
```

Además, en **Admin > Configuración de Servidor** puedes guardar metadatos por instalación:
- nombre de servidor
- IP pública
- IP privada
- dominio
- frontend/backend URL
- orígenes CORS esperados

Y consultar runtime real vía API:
- `GET /api/health`
- `GET /api/configuracion/servidor` (autenticado)
