# SAMU AI

### Red neuronal, evolución de estrategias y aprendizaje local en MQL4

SAMU AI es un Expert Advisor para **MetaTrader 4** desarrollado íntegramente en **MQL4**.

Este repositorio comparte la **versión 8.5**, que combina aprendizaje neuronal, estrategias evolutivas, memoria de experiencias y un motor de reglas denominado **SAML**.

La inferencia y el entrenamiento se ejecutan localmente dentro del terminal.

## Contexto del proyecto

Como neuropsicólogo y desarrollador, me interesa explorar cómo un sistema representa información, utiliza experiencias anteriores y combina mecanismos de decisión.

SAMU AI reúne estos procesos en una arquitectura cuyo código permite inspeccionar las entradas, el entrenamiento, las reglas y las decisiones operativas.

La conexión con mi trabajo neuropsicológico está en esas preguntas de investigación y desarrollo. El programa no constituye una simulación validada del cerebro ni un modelo clínico.

## Arquitectura

| Componente | Función |
|---|---|
| Red neuronal | Produce una puntuación direccional a partir de 10 variables |
| Ensemble evolutivo | Combina votos de estrategias representadas por vectores de pesos |
| Replay | Reutiliza experiencias de operaciones para entrenar la red |
| SAML | Evalúa y modifica reglas que intervienen en la decisión |
| Dimensionamiento | Utiliza una fórmula de Kelly fraccionado y ajustes por rachas |
| Circuit breaker | Reduce lotaje o intenta cerrar posiciones y pausar nuevas entradas |
| Persistencia | Guarda pesos, experiencias, reglas y parte de las estadísticas |

## Red neuronal

Implementa una red de:

- **10 entradas**.
- **10 neuronas ocultas**, con activación tangente hiperbólica.
- **1 salida**, con activación sigmoide.

El entrenamiento utiliza backpropagation con tasa de aprendizaje y momentum configurables.

La salida se transforma a una escala entre −1 y 1 para combinarla con el ensemble.

No debe interpretarse como una probabilidad calibrada de éxito.

## Variables de entrada

1. RSI normalizado.
2. MACD relativo al ATR.
3. Diferencia entre EMA20 y EMA50 normalizada por precio.
4. Posición respecto de las bandas de Bollinger.
5. Relación entre ATR14 y ATR100.
6. Momentum de cinco barras relativo al ATR.
7. Estocástico normalizado.
8. CCI normalizado.
9. Componente cíclica de la hora.
10. Componente cíclica del día de la semana.

Los cálculos utilizan el período del gráfico. Varias características incluyen información de la vela en formación.

## Mecanismos de aprendizaje

### Entrenamiento supervisado

Entrena sobre características históricas del símbolo del gráfico y etiquetas construidas a partir de movimientos posteriores del precio.

La configuración contempla una ventana de entrenamiento y comprobaciones periódicas mediante temporizador.

### Replay de experiencias

Al procesar cierres, registra características, dirección y recompensa de las operaciones.

El replay selecciona experiencias almacenadas para construir nuevos ejemplos de entrenamiento.

Esta implementación reutiliza resultados como etiquetas supervisadas; no implementa Q-learning ni un modelo explícito de valor futuro.

### Evolución de estrategias

Cada integrante del pool contiene un vector de pesos sobre las 10 características.

El sistema evalúa su acierto direccional histórico, selecciona estrategias y genera variantes mediante cruce y mutación.

La evaluación del pool no equivale a un backtest completo con costes y gestión de posiciones.

## Motor SAML

SAML permite representar condiciones y acciones mediante estructuras de reglas.

Las condiciones pueden consultar:

- Características de mercado.
- Salida neuronal y voto del ensemble.
- Puntuación combinada.
- Drawdown.
- Estadísticas y rachas.

Las acciones disponibles incluyen:

- Ajustar la puntuación.
- Modificar el lotaje.
- Bloquear entradas.
- Modificar las distancias de SL y TP.
- Asignar pesos a la red neuronal y al ensemble.

El motor incorpora reglas iniciales, actualización de fitness, mutación, cruce y generación de reglas a partir de patrones del buffer.

El archivo `.saml` es una exportación legible. La carga implementada utiliza el archivo binario de reglas.

## Construcción de la señal

La decisión combina:

    peso neuronal × voto neuronal
    + peso del ensemble × voto del ensemble
    + ajuste SAML

Los pesos iniciales son **0.60** y **0.40**.

La puntuación se compara con umbrales direccionales y luego se aplican filtros de régimen, tendencia, spread y horario.

Los mecanismos adaptativos pueden modificar el comportamiento. Su presencia no demuestra por sí sola una mejora de rendimiento.

## Gestión de operaciones

Incluye:

- Stop loss y take profit basados en ATR.
- Trailing basado en ATR.
- Entradas adicionales ante desplazamientos adversos, condicionadas por señal.
- Dimensionamiento mediante Kelly fraccionado.
- Reducción de lote después de pérdidas.
- Incremento de lote después de determinadas rachas ganadoras.
- Reducción de lotaje según drawdown.
- Intento de cierre y pausa en el nivel superior del circuit breaker.

El cálculo Kelly utiliza un payoff supuesto de **1.8** y una tasa de acierto inicial de **0.55**. No estima ambos componentes de manera completa a partir de resultados observados.

## Parámetros principales

| Parámetro | Valor predeterminado |
|---|---:|
| Versión | `8.50` |
| `RiesgoPorTrade` | `1.0`, declarado pero no utilizado en el cálculo del lote |
| `FraccionKelly` | `0.25` |
| `MaxOrdenesSimbolo` | `3`, comprobado por dirección |
| `DistanciaGridPips` | `25.0` |
| `StopLossATR` | `1.5` |
| `TakeProfitATR` | `2.7` |
| `LearningRateNN` | `0.01` |
| `MomentumNN` | `0.9` |
| `VentanaEntrenamiento` | `500` |
| `TamanoPoolEstrategias` | `20` |
| `MaxExperiencia` | `5000` |
| `BatchReplay` | `32` |
| `ReplaysPorHora` | `4` |
| `SAML_EvolucionCada` | `30` |
| `SAML_TasaMutacion` | `0.20` |
| `MaxParesSimultaneos` | `3` |
| Niveles de drawdown | `5%, 10%, 15%` |
| `HorasPausaDD` | `24` |
| `ModoCripto` | `false` |

Estos valores describen el código publicado. No son recomendaciones ni límites garantizados de pérdida.

## Instrumentos

Permite configurar hasta 30 símbolos.

La lista inicial contiene 12 pares de divisas y cuatro instrumentos cripto:

EURUSD, GBPUSD, USDJPY, AUDUSD, USDCAD, NZDUSD, USDCHF, EURJPY, GBPJPY, EURGBP, AUDJPY, CHFJPY, BTCUSD, ETHUSD, XRPUSD y LTCUSD.

Los símbolos cripto están incluidos en la lista aunque `ModoCripto` está desactivado por defecto. Revisar ambos ajustes antes de las pruebas.

La disponibilidad depende del bróker. No incluye conexión directa a exchanges ni gestión de billeteras.

## Instalación para pruebas

1. Abrir MetaTrader 4 en una cuenta demo.
2. Seleccionar **Archivo → Abrir carpeta de datos**.
3. Copiar `SAMU_AI.mq4` dentro de `MQL4/Experts`.
4. Abrirlo en MetaEditor y compilar.
5. Revisar errores y advertencias.
6. Actualizar la lista de Expert Advisors.
7. Cargar el EA y comprobar símbolos, históricos, parámetros y permisos.

Sin archivos previos, el programa inicializa la red y el pool.

Utiliza por defecto los identificadores `99991` y `99992`. No compartirlos con otras instancias o variantes de SAMU: sus rutinas podrían gestionar las mismas posiciones.

## Archivos generados

| Archivo | Contenido |
|---|---|
| `SAMU_v8_cerebro.bin` | Pesos, pool y parte del estado estadístico |
| `SAMU_v8_experiencia.bin` | Experiencias almacenadas |
| `SAMU_v85_script.bin` | Reglas SAML persistidas |
| `SAMU_v85_script.saml` | Exportación legible de reglas |
| `SAMU_v8_journal.csv` | Registro de operaciones procesadas |
| `SAMU_v8_stats.csv` | Estadísticas |
| `SAMU_v8_export_ia.csv` | Exportación para análisis externo |

Los nombres son fijos. Varias instancias en el mismo espacio de archivos pueden sobrescribir datos.

## Estado y limitaciones conocidas

Puntos identificados mediante lectura del código:

- **Riesgo declarado:** `RiesgoPorTrade` no limita el cálculo Kelly. Los ajustes por rachas y SAML pueden aumentar el lotaje.
- **Meta-learner:** existe una rutina para redistribuir pesos por aciertos, pero los contadores correspondientes no se actualizan en el código compartido. Desde una inicialización nueva, esa adaptación no progresa.
- **Configuración SAML:** `SAML_MaxReglas` y `SAML_UmbralElite` están declarados, pero no se aplican en la lógica correspondiente.
- **Contexto multiactivo:** algunas características utilizan series del gráfico principal en lugar del símbolo procesado.
- **Historial duplicado:** los cierres sin contexto registrado pueden procesarse repetidamente, alterando estadísticas, journal y experiencias.
- **Capacidad de tickets:** el registro tiene 200 entradas y no libera las procesadas.
- **Frecuencia evolutiva:** el contador del pool avanza por llamada a procesamiento, incluso sin nuevos cierres.
- **Evaluación:** falta una separación formal entre entrenamiento, selección y prueba fuera de muestra.
- **Recompensa:** se normaliza mediante el stop disponible al cierre, que puede diferir del riesgo original.
- **Circuit breaker:** puede extender la pausa en cada tick mientras persiste el drawdown de nivel 3.
- **Límite de símbolos:** el conteo no se actualiza tras cada apertura dentro del recorrido.
- **Persistencia:** no reconstruye todo el contexto de tickets ni conserva íntegramente el estado del aprendizaje.
- **Ejecución:** requiere validar pasos de lote, conversiones de unidades, históricos y restricciones del bróker.

## Validación

La documentación se basa en la lectura del archivo fuente. No acredita compilación, ejecución ni resultados de backtesting.

El repositorio no incluye un historial auditado ni una validación independiente de rentabilidad.

El entrenamiento continuo puede introducir sobreajuste e inestabilidad. Su evaluación requiere pruebas reproducibles, costes de ejecución y datos fuera de muestra.

## Autor

Desarrollado por **Emanuel**, neuropsicólogo y desarrollador del proyecto **WineBOX**.

- https://winebox.cloud
- https://wineboxtool.cloud

## Contribuciones

Se reciben reportes de errores y propuestas mediante Issues y Pull Requests.

Incluir versión de MetaTrader 4, instrumento, período del gráfico, parámetros y registros relevantes, sin credenciales ni datos personales.

## Licencia

Este proyecto se distribuye bajo la licencia **Apache License 2.0**.

Consultar el archivo [LICENSE](LICENSE) para conocer los términos completos.

## Aviso

Material técnico y educativo. No constituye asesoramiento financiero ni una promesa de resultados.
