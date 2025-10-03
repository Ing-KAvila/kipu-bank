**KipuBank** es un contrato inteligente en Solidity que permite a los usuarios depositar y retirar ETH (tokens nativos de Ethereum) en una bóveda personal. El contrato impone límites seguros tanto a nivel individual como global, y sigue buenas prácticas de seguridad como errores personalizados, eventos, y el patrón checks-effects-interactions.

**Descripción del contrato**
- Cada usuario tiene una bóveda personal donde puede depositar ETH.
- Los retiros están limitados por una cantidad máxima por transacción (`withdrawalLimit`).
- El contrato tiene un límite global de depósitos (`bankCap`) definido al momento del despliegue.
- Se registran eventos en cada depósito y retiro exitoso.
- Se lleva un conteo total de depósitos y retiros.
- Se aplican errores personalizados para validar condiciones.
- El contrato incluye funciones `external`, `view`, `private`, y modificadores para validar lógica.

**Seguridad y buenas prácticas**
- Uso de errores personalizados en lugar de cadenas en require.
- Patrón checks-effects-interactions para evitar reentrancia.
- Transferencias nativas con call y verificación de éxito.
- Variables immutable para límites definidos en el constructor.
- Eventos para trazabilidad de acciones.
- Comentarios NatSpec para documentación clara. 
- Se aplicó convenciones de nombres adecuadas.

**Instrucciones de despliegue**
1. **Requisitos previos**:
   - Cuenta de Ethereum y fondos en testnet (por ejemplo, Sepolia)

2. **Despliegue en Remix**:
   - Copiá el código del contrato en un archivo `.sol` dentro de Remix.
   - Seleccioná la versión de compilador `0.8.30`.
   - Compilá el contrato.
   - En la pestaña "Deploy & Run Transactions":
     - Seleccioná el contrato `KipuBank`.
     - Ingresá los valores para `bankCap` y `withdrawalLimit` en wei.
     - Hacé clic en "Deploy".

3. **Cómo interactuar con el contrato**
   - **Depositar ETH**
   - **Retirar ETH**
   - **Consultar saldo**




Ubicación: **Buenos Aires, Argentina.** 
Fecha:     **Octubre 2025**
