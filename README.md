# 💰 Bot Ahorros WhatsApp

Un bot personal y de bajo costo que registra ahorros y retiros desde WhatsApp, guarda cada movimiento en Notion y responde con el saldo actualizado. El proyecto se ejecutó en un **Motorola G30 reutilizado**, demostrando que una automatización útil puede montarse sin comprar infraestructura adicional.

> Este repositorio publica una plantilla segura del flujo: los identificadores, la clave de API y los datos de cuenta fueron reemplazados por marcadores antes de subirlo.

## Qué hace

1. Recibe mensajes entrantes en el webhook `POST /whatsapp-ahorros`.
2. Procesa únicamente los mensajes enviados por la cuenta configurada y evita responder a sus propios mensajes.
3. Interpreta frases en español como `ahorré 50 para emergencias` o `retiré $20 transporte`.
4. Crea un registro en una base de datos de Notion con concepto, monto, tipo, fecha y mensaje original.
5. Calcula el saldo acumulado y envía una confirmación por WhatsApp.
6. Responde a `/saldo` con el ahorro actual, el total ahorrado y los retiros.

## Arquitectura

```text
WhatsApp → API local en el Motorola G30 → webhook de n8n
                                         ↓
                                Interpretación del mensaje
                                         ↓
                              Base de datos de Notion
                                         ↓
                         Cálculo de saldo → respuesta WhatsApp
```

## Tecnologías

- [n8n](https://n8n.io/) para la orquestación
- WhatsApp mediante una API local autohospedada
- Notion como almacenamiento de movimientos
- JavaScript en nodos Code de n8n
- Docker/local networking (`host.docker.internal`)
- Android reutilizado: Motorola G30

## Instalación

1. Importa [`workflow/Bot Ahorros WhatsApp.template.json`](workflow/Bot%20Ahorros%20WhatsApp.template.json) en n8n.
2. Crea en Notion una base con estas propiedades:
   - Título: `Concepto`
   - Número: `Cantidad`
   - Selección: `Tipo` (valores `Ahorro` y `Retiro`)
   - Fecha: `Fecha`
   - Texto enriquecido: `Mensaje`
3. Configura las credenciales de Notion en los nodos correspondientes.
4. Sustituye los marcadores del flujo por tu ID de fuente de datos, ID de chat y clave de API local.
5. Expón o conecta el webhook al proveedor/API de WhatsApp que utilices.
6. Activa el flujo y prueba con `ahorré 50 para emergencias` y `/saldo`.

## Mensajes compatibles

El intérprete reconoce verbos de ahorro (`ahorré`, `guardé`, `aparté`, `deposité`) y retiro (`retiré`, `tomé`, `saqué`, `quité`), además de cantidades con `$`, punto o coma decimal. El concepto se infiere del resto del mensaje.

## Consideraciones

- El flujo actual lee todos los registros de Notion para calcular el saldo. Para bases grandes, conviene mantener un saldo acumulado o paginar los resultados.
- El análisis se basa en palabras clave; mensajes ambiguos pueden requerir más reglas o validación.
- Nunca publiques claves, IDs de chat ni identificadores de bases reales. Esta plantilla ya los oculta.

## Créditos

Proyecto creado en colaboración entre **Miguel** y **OpenAI Codex**. Miguel definió el objetivo, probó el sistema en el Motorola G30 y llevó el proyecto a producción; Codex apoyó en el diseño técnico, automatización y documentación.

## Licencia

Este proyecto se publica bajo la licencia MIT. Consulta [LICENSE](LICENSE).
