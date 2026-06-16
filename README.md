# Kash

App móvil de finanzas personales y empresariales construida con Flutter. Permite gestionar múltiples cuentas, categorizar gastos e ingresos, hacer seguimiento de gastos de empleados, y consultar a una IA financiera integrada — todo con cifrado de nivel bancario y autenticación biométrica.

## Capturas

*(añade aquí 3-4 capturas del emulador cuando tengas las pantallas pulidas)*

## Características

### Modo personal
- Múltiples cuentas (efectivo, banco, ahorros, inversión...) con saldo manual
- Vista consolidada o filtrada por cuenta individual
- Categorías de gasto personalizables con emoji
- Estadísticas con gráficos de barras, donut y evolución diaria
- Presupuesto mensual con seguimiento visual

### Modo empresa
- Gestión de empleados con conceptos de pago (sueldo, comisión, bonus, dieta)
- Cuentas separadas para operaciones, caja chica y nóminas
- Aprobación de gastos pendientes
- Informes exportables

### Kash AI
Asistente financiero integrado que usa la API de Anthropic (Claude) para responder preguntas sobre los propios datos del usuario: patrones de gasto, simulación de escenarios ("¿qué pasa si gasto X este mes?"), y análisis de tendencias. El contexto financiero del usuario se envía automáticamente en cada consulta, sin que el usuario tenga que explicar su situación.

### Seguridad
- Autenticación biométrica (huella / Face ID) con PIN de respaldo
- Base de datos local cifrada con AES-256 (SQLCipher)
- Bloqueo automático al salir de la app
- Pantalla negra en el multitarea (protección contra capturas)
- Clave de cifrado almacenada en Keychain (iOS) / Keystore (Android)

### Internacionalización
- 6 idiomas: español, inglés, portugués, francés, alemán, italiano
- 29 países con formato de moneda automático
- Cambio de idioma en tiempo real sin reiniciar la app

## Stack tecnológico

| Capa | Tecnología |
|------|-----------|
| Framework | Flutter, Dart |
| Estado | Provider |
| Base de datos | SQLite (sqflite_sqlcipher) |
| Seguridad | local_auth, flutter_secure_storage, AES-256 |
| IA | Anthropic API (Claude Haiku) |
| Internacionalización | flutter_localizations, intl |
| Gráficos | fl_chart / custom painters |

## Por qué es 100% local

Kash no usa backend ni servidor propio. Todos los datos viven cifrados en el dispositivo del usuario. Esto significa:

- Cero coste de infraestructura
- Privacidad total — los datos financieros nunca salen del teléfono
- Sin necesidad de licencia de entidad de pago (la app no mueve dinero real, solo lo registra)
- Sin riesgo de brecha de datos en servidor porque no existe servidor

La única llamada externa que hace la app es a la API de Anthropic cuando el usuario consulta a Kash AI, y solo envía el contexto financiero necesario para responder esa consulta concreta.

## Arquitectura

```
lib/
├── theme/          → colores y ThemeData (oscuro/claro)
├── db/             → SQLite cifrado, migraciones
├── models/         → Cuenta, Categoria, Movimiento, Empleado
├── providers/       → estado con Provider (ChangeNotifier)
├── screens/
│   ├── personal/   → Inicio, Añadir, Cuentas, Estadísticas
│   └── empresa/    → Inicio, Empleados, Cuentas, Registrar
├── services/       → KashAiService, AuthService, CurrencyService
└── widgets/        → componentes reutilizables
```

Arquitectura por capas con Provider + Repository pattern. Cada pantalla obtiene sus datos de un Provider que abstrae el acceso a SQLite, lo que facilita testing y mantenimiento.

## Cómo ejecutarlo

### Requisitos
- Flutter SDK (canal estable)
- Android Studio (emulador) o dispositivo físico
- Xcode si quieres compilar para iOS (requiere macOS)

### Pasos

```bash
git clone https://github.com/Mauro-Remeseiro/Kash-app.git
cd Kash-app
flutter pub get
flutter run
```

### Variables de entorno

Crea un archivo `.env` en la raíz con tu clave de la API de Anthropic para que funcione Kash AI:

```env
ANTHROPIC_API_KEY=tu_clave_aqui
```

Sin esta clave la app funciona con normalidad, solo el chat de Kash AI quedará deshabilitado.

## Modelo de monetización

| Plan | Incluye |
|------|---------|
| Gratis | Cuentas, categorías y movimientos ilimitados · 10 consultas a Kash AI/mes · Estadísticas básicas |
| Pro (pago único) | Kash AI ilimitada · Exportar PDF · Histórico completo · Presupuestos por categoría |

El pago se gestiona vía Google Play Billing / Apple In-App Purchase — la app nunca procesa pagos directamente, lo que evita necesitar licencias de entidad de pago.

## Decisiones de diseño

**¿Por qué SQLite local en vez de backend en la nube?**
Para una app de finanzas personales, la privacidad es la feature más valorada por los usuarios. Mantener todo local elimina el riesgo de filtración de datos sensibles y el coste de mantener infraestructura, a cambio de no tener sincronización entre dispositivos en esta primera versión.

**¿Por qué cifrar la base de datos si ya es local?**
Local no significa seguro. Si el dispositivo se pierde, es robado, o alguien con acceso físico extrae el archivo `.db`, el cifrado AES-256 hace que esos datos sean inútiles sin la clave, que vive en el almacenamiento seguro del sistema operativo.

**¿Por qué Claude Haiku y no un modelo más grande para la IA?**
Las consultas de Kash AI son sobre datos estructurados y acotados (los números del propio usuario), no requieren razonamiento complejo. Haiku ofrece respuestas rápidas y bajo coste, lo que permite ofrecer un número de consultas gratuitas generoso sin que el coste de la IA haga inviable el modelo freemium.

## Roadmap

- [ ] Sincronización opcional en la nube (Fase 2, con cuenta de usuario)
- [ ] Conexión con Open Banking para lectura automática de saldos (solo lectura)
- [ ] Widget de inicio para iOS/Android
- [ ] Modo familia — compartir cuentas entre varios usuarios

## Licencia

MIT — ver [LICENSE](LICENSE) para más detalles.

## Autor

**Mauro Remeseiro Estrade**
[LinkedIn](https://www.linkedin.com/in/mauro-remeseiro-500207202/) · [GitHub](https://github.com/Mauro-Remeseiro)
