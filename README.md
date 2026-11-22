# Registro de Ventas en Solana (Track Advanced)

Proyecto final desarrollado para la certificación **Solana Engineering Track: Advanced** de WayLearn.

## 1. Ruta Elegida y Propósito

* **Ruta:** Proyecto guiado ampliado con aporte funcional propio.
* **Base de partida:** Repositorio de referencia `WayLearnLatam/Registro-Ventas-Solana-PDA` y `WayLearnLatam/Registro-Ventas-Solana-App`.
* **Propósito:** Gestionar un sistema de negocio en Solana con arquitectura jerárquica basada en PDAs (Cuentas independientes para `Registro`, `Cliente` y `Venta`), cliente generado con Codama y frontend reactivo con soporte de wallet (Solflare) en **Devnet**.

---

## 2. Aporte Funcional y Mejoras Implementadas

1. **Instrucción `eliminar_cliente` (Día 5 - Vibe Coding):**
   * **Regla de negocio onchain:** Permite al `owner` dar de baja a un cliente y recuperar el rent de la cuenta (`close = owner`).
   * **Precondición estricta:** Comprueba en Rust que el cliente no tenga ventas activas (`cliente.historial.is_empty() && cliente.compras == 0`). Si tiene ventas, la transacción se revierte con el error `ClienteConVentasActivas`.
   * **Consistencia de índices:** Se retira únicamente la dirección del cliente del vector `registro.clientes`.
   * **Preservación del contador:** El contador `id_counter` se mantiene intacto para evitar colisiones de identificadores en futuras altas.
2. **Validación de negocio onchain adicional (Mejora propia):**
   * Validación estricta en Rust (`require!(monto > 0, Errores::MontoInvalido)`) en las instrucciones `registrar_venta` y `cambiar_monto`, impidiendo la creación o actualización de ventas con montos nulos o negativos.

---

## 3. Despliegue en Devnet

* **Program ID:** [`AFAyoCUgudQWLQAZCn5fSFHKpBqYYubfEV3ZZvUx1dvF`](https://explorer.solana.com/address/AFAyoCUgudQWLQAZCn5fSFHKpBqYYubfEV3ZZvUx1dvF?cluster=devnet)
* **Cluster:** Solana Devnet
* **Explorer / Solscan:** [Ver en Solscan](https://solscan.io/account/AFAyoCUgudQWLQAZCn5fSFHKpBqYYubfEV3ZZvUx1dvF?cluster=devnet)

---

## 4. Pruebas y Evidencias Verificables

Todas las transacciones fueron ejecutadas en Devnet y son auditables públicamente:

| Operación | Descripción | Firma / Enlace en Explorer |
| :--- | :--- | :--- |
| **Crear Registro** | Creación del negocio `Cafe WayLearn D5` con autoridad | [`4BCEJcGeoUDtxk7msna4oJzo...`](https://solscan.io/tx/4BCEJcGeoUDtxk7msna4oJzoAC9ekXBkMgCpgei7GuLZxHeEk9H1ZduHxxFewuyGxXgizGj6uB1neVXpLcvrmBL7?cluster=devnet) |
| **Crear Cliente #1** | Alta de cliente Luis (ID: 1) | [`4AWb85KmTNfNy2eeHsKGr8Av...`](https://solscan.io/tx/4AWb85KmTNfNy2eeHsKGr8AvfMniF8jPJAuBSqTFeZC1eLtg9UM5kmTNNZbjbMe37UxSq8iNsKkxpWzKw8QC8t5B?cluster=devnet) |
| **Crear Cliente #2** | Alta de cliente Ana (ID: 2) | [`3zufpXWyp6CThKPsLdR7UvC1...`](https://solscan.io/tx/3zufpXWyp6CThKPsLdR7UvC1tpuAhyfGUGpAAEU1bLDbXZ7NS7bS5JvZ1BtdpSvjRajy6SCdD6rSRGy89vNm8spU?cluster=devnet) |
| **Registrar Venta** | Venta SKU `CAF01` (50 unidades) para Cliente #1 | [`27HDR186rJ9hhH6td8LxMmv2...`](https://solscan.io/tx/27HDR186rJ9hhH6td8LxMmv2GUEJSAsvYtikciP3FQitGdaxMWJU2asgeSkK19D1xrkvjvJ5SVEgKuRTN1dLDn8F?cluster=devnet) |
| **Devolución / Cierre Venta** | Baja de la venta `CAF01` y cierre de la cuenta | [`2oWZzeR3ceuAvTJVsWAfyNTL...`](https://solscan.io/tx/2oWZzeR3ceuAvTJVsWAfyNTL1qnxT7Yv8qAKg42yRWx5tuzWxN71m2jr8YTmukztAvRZPpx7BhVhdEV3eHaAzhfm?cluster=devnet) |
| **Baja de Cliente (Día 5)** | Eliminación de Cliente #1 y cierre de cuenta de datos | [`21gdyNge8C3J5mXQ5qanH26n...`](https://solscan.io/tx/21gdyNge8C3J5mXQ5qanH26nWwMVNnLH7bgRe9YiMGTDHo9C6w884pwfEyyoswiRNJyXN7FJhzoVaAiDVQwEJcrA?cluster=devnet) |

### Casos de Rechazo Comprobados:
1. **Rechazo por Ventas Activas (`ClienteConVentasActivas`):** Al intentar dar de baja a un cliente con compras > 0 o ventas activas en su historial, el programa en Rust rechaza la transacción protegiendo la integridad del árbol de cuentas.
2. **Rechazo de Autoridad (`NoOwner`):** Intentar firmar una operación de modificación o baja desde una wallet distinta a `registro.owner` es rechazado de inmediato.
3. **Rechazo por Monto Inválido (`MontoInvalido`):** El programa rechaza cualquier intento de venta con monto 0.

---

## 5. Instrucciones de Ejecución

### Prerrequisitos
* Node.js v18+ y npm
* Wallet Solflare configurada en **Devnet** con fondos de prueba.

### Instalación y arranque
```bash
# 1. Clonar el repositorio
git clone <URL_DE_TU_REPOSITORIO>
cd frontend-base

# 2. Instalar dependencias
npm install --legacy-peer-deps

# 3. Comprobar contrato IDL y suite de tests
npm run comprobar:idl
npm test

# 4. Iniciar servidor de desarrollo
npm run dev
```

Abre `http://localhost:5173/` en tu navegador, conecta Solflare en Devnet e interactúa con el registro.
