//+------------------------------------------------------------------+
//|                                            SAMU AI v8.5          |
//|     Neural Net + Genetic Pool + Replay + SAML Script Engine     |
//+------------------------------------------------------------------+
#property copyright "SAMU Quant Edition"
#property link      "www.wineboxtool.cloud"
#property version   "8.50"
#property strict

//====================================================================
//======================= PARÁMETROS PRINCIPALES =====================
//====================================================================
extern string  __SIZING__         = "--- GESTIÓN DE CAPITAL ---";
extern double  RiesgoPorTrade     = 1.0;
extern double  FraccionKelly      = 0.25;
extern int     MaxOrdenesSimbolo  = 3;
extern double  DistanciaGridPips  = 25.0;
extern double  StopLossATR        = 1.5;
extern double  TakeProfitATR      = 2.7;

extern string  __MAGIC__          = "--- IDENTIFICADORES ---";
extern int     NumeroMagicoCompra = 99991;
extern int     NumeroMagicoVenta  = 99992;

extern string  __TRAILING__       = "--- TRAILING ---";
extern bool    ActivarTrailing    = true;
extern double  TrailingATR        = 1.0;
extern int     PasoTrailingPips   = 5;

extern string  __IA__             = "--- MOTOR DE IA ---";
extern bool    ActivarRedNeural   = true;
extern double  LearningRateNN     = 0.01;
extern double  MomentumNN         = 0.9;
extern int     VentanaEntrenamiento = 500;
extern int     TamanoPoolEstrategias = 20;
extern int     FrecuenciaEvolucion  = 50;
extern int     MaxExperiencia       = 5000;
extern int     BatchReplay          = 32;
extern int     ReplaysPorHora       = 4;
extern double  PesoRedNeural        = 0.60;
extern double  PesoEnsemble         = 0.40;

extern string  __CRIPTO__         = "--- ADAPTACIÓN CRIPTO ---";
extern bool    ModoCripto         = false;
extern double  MultiplicadorATRCripto = 1.3;
extern double  SpreadMaxCripto    = 15.0;
extern bool    SinFiltroHorarioCripto = true;
extern double  ToleranciaVolatilidad = 3.0;

extern string  __FILTROS__        = "--- FILTROS ---";
extern bool    FiltroRegimen      = true;
extern bool    FiltroTendencia    = true;
extern bool    FiltroSpread       = true;
extern double  SpreadMaxPips      = 3.0;
extern bool    FiltroHorario      = true;
extern string  HoraInicio         = "00:00";
extern string  HoraFin            = "23:59";

extern string  __RISK_CB__        = "--- CIRCUIT BREAKER ---";
extern bool    ActivarCircuitBreaker = true;
extern double  DD_Nivel1          = 5.0;
extern double  DD_Nivel2          = 10.0;
extern double  DD_Nivel3          = 15.0;
extern int     HorasPausaDD       = 24;

// ==== SAML SCRIPT ENGINE ====
extern string  __SAML__           = "--- SAML ENGINE (auto-optimización) ---";
extern bool    ActivarSAML        = true;
extern int     SAML_MaxReglas     = 16;      // reglas vivas en memoria
extern int     SAML_EvolucionCada = 30;      // trades entre evoluciones SAML
extern double  SAML_TasaMutacion  = 0.20;
extern double  SAML_UmbralElite   = 0.55;    // fitness mínimo para clonar
extern bool    SAML_AutoGenerar   = true;    // crear reglas desde patrones

extern string  __SIMBOLOS__       = "--- SÍMBOLOS ---";
extern string Simbolo01="EURUSD"; extern string Simbolo02="GBPUSD";
extern string Simbolo03="USDJPY"; extern string Simbolo04="AUDUSD";
extern string Simbolo05="USDCAD"; extern string Simbolo06="NZDUSD";
extern string Simbolo07="USDCHF"; extern string Simbolo08="EURJPY";
extern string Simbolo09="GBPJPY"; extern string Simbolo10="EURGBP";
extern string Simbolo11="AUDJPY"; extern string Simbolo12="CHFJPY";
extern string Simbolo13="BTCUSD"; extern string Simbolo14="ETHUSD";
extern string Simbolo15="XRPUSD"; extern string Simbolo16="LTCUSD";
extern string Simbolo17="";       extern string Simbolo18="";
extern string Simbolo19="";       extern string Simbolo20="";
extern string Simbolo21="";       extern string Simbolo22="";
extern string Simbolo23="";       extern string Simbolo24="";
extern string Simbolo25="";       extern string Simbolo26="";
extern string Simbolo27="";       extern string Simbolo28="";
extern string Simbolo29="";       extern string Simbolo30="";

extern int     MaxParesSimultaneos = 3;
extern string  ComentarioOrden     = "SAMU AI QUANT v8.5";

extern string  __VISUAL__         = "--- VISUAL ---";
extern bool    PintarVelas        = true;
extern bool    MostrarPisosTechos = true;
extern bool    MostrarCanales     = true;

//====================================================================
//======================= CONSTANTES =================================
//====================================================================
#define NN_INPUTS     10
#define NN_HIDDEN     10
#define NN_OUTPUTS    1
#define NN_W1_SIZE    (NN_INPUTS * NN_HIDDEN)
#define NN_B1_SIZE    NN_HIDDEN
#define NN_W2_SIZE    (NN_HIDDEN * NN_OUTPUTS)
#define NN_B2_SIZE    NN_OUTPUTS
#define STRAT_FEATURES 10

#define MAX_EXP_HARD  20000
#define MAX_TICKETS   200

#define ARCHIVO_CEREBRO     "SAMU_v8_cerebro.bin"
#define ARCHIVO_EXPERIENCIA "SAMU_v8_experiencia.bin"
#define ARCHIVO_JOURNAL     "SAMU_v8_journal.csv"
#define ARCHIVO_STATS       "SAMU_v8_stats.csv"
#define ARCHIVO_EXPORT      "SAMU_v8_export_ia.csv"
#define ARCHIVO_SAML        "SAMU_v85_script.saml"
#define ARCHIVO_SAML_BIN    "SAMU_v85_script.bin"

#define BALANCE_MINIMO  1000.0
#define PANEL_X         10
#define PANEL_Y         20
#define PANEL_ANCHO     500
#define PANEL_ALTO      820
#define FILA_ALTO       20
#define SECCION_ALTO    24
#define PADDING_X       12
#define PADDING_Y       4
#define FUENTE_TAM      9
#define FUENTE_TITULO   11
#define COL_LABEL       12
#define COL_VALOR       210
#define COL_ESTADO      360

#define REG_RANGO  0
#define REG_ALZA   1
#define REG_BAJA   2
#define REG_CAOS   3

// ==== SAML CONSTANTES ====
#define SS_MAX_RULES   32
#define SS_MAX_COND    3
#define SS_FEAT_NN     -1
#define SS_FEAT_ENS    -2
#define SS_FEAT_SCORE  -3
#define SS_FEAT_WR     -4
#define SS_FEAT_DD     -5
#define SS_FEAT_CL     -6
#define SS_FEAT_CW     -7

#define SS_OP_GT  0
#define SS_OP_LT  1
#define SS_OP_GE  2
#define SS_OP_LE  3

#define SS_ACT_BOOST      0
#define SS_ACT_LOT_MULT   1
#define SS_ACT_BLOCK      2
#define SS_ACT_SL_MULT    3
#define SS_ACT_TP_MULT    4
#define SS_ACT_NN_WEIGHT  5
#define SS_ACT_ENS_WEIGHT 6

//====================================================================
//======================= ESTRUCTURA SAML ============================
//====================================================================
struct SSRule
  {
   int    id;
   int    priority;
   int    active;
   int    condCount;
   int    condIdx[SS_MAX_COND];
   int    condOp[SS_MAX_COND];
   double condVal[SS_MAX_COND];
   int    condLogic[SS_MAX_COND];
   int    actionType;
   double actionVal;
   int    hits;
   int    misses;
   double fitness;
   int    generation;
  };

//====================================================================
//======================= ESTADO GLOBAL ==============================
//====================================================================
int      NumSimbolos = 0;
string   ListaSimbolos[30];
string   SufijoSimbolo = "";

// ==== NN ====
double   g_W1[NN_W1_SIZE];
double   g_B1[NN_B1_SIZE];
double   g_W2[NN_W2_SIZE];
double   g_B2[NN_B2_SIZE];
double   g_vW1[NN_W1_SIZE];
double   g_vB1[NN_B1_SIZE];
double   g_vW2[NN_W2_SIZE];
double   g_vB2[NN_B2_SIZE];
double   g_input[NN_INPUTS];
double   g_hidden[NN_HIDDEN];
double   g_output[NN_OUTPUTS];

// ==== Pool genético ====
double   g_Pool[64][STRAT_FEATURES];
double   g_Fitness[64];
int      g_EdadEstrategia[64];
int      g_Generacion = 0;

// ==== Replay ====
double   g_exp_feat[MAX_EXP_HARD][NN_INPUTS];
double   g_exp_acc[MAX_EXP_HARD];
double   g_exp_rew[MAX_EXP_HARD];
datetime g_exp_tim[MAX_EXP_HARD];
int      g_exp_count = 0;
int      g_exp_pos   = 0;
int      g_exp_entrenamientos = 0;

// ==== Tickets ====
int      g_ticketPendiente[MAX_TICKETS];
double   g_ticketFeat[MAX_TICKETS][NN_INPUTS];
double   g_ticketAccion[MAX_TICKETS];
double   g_ticketPredNN[MAX_TICKETS];
double   g_ticketVotoEns[MAX_TICKETS];
double   g_ticketScore[MAX_TICKETS];
datetime g_ticketHora[MAX_TICKETS];
int      g_ticketCount = 0;
int      g_ticketSAMLFire[MAX_TICKETS][SS_MAX_RULES];  // reglas que disparó cada ticket

// ==== Stats por símbolo ====
int      g_trades[30];
int      g_wins[30];
int      g_losses[30];
double   g_pnl[30];
int      g_consecWin[30];
int      g_consecLoss[30];
int      g_ultimaDireccion[30];
double   g_ultimoLote[30];

// ==== Meta ====
double   g_pesoNN      = 0.60;
double   g_pesoEns     = 0.40;
int      g_aciertosNN  = 0;
int      g_fallosNN    = 0;
int      g_aciertosEns = 0;
int      g_fallosEns   = 0;

// ==== Estado global ====
int      g_tradesDesdeEvolucion = 0;
double   g_peakEquity = 0;
datetime g_PausaHasta = 0;
int      g_NivelDD = 0;
datetime g_UltimaBarraEntren = 0;
datetime g_UltimaBarraNiv = 0;
datetime g_UltimoReplay = 0;
bool     g_VisInit = false;
string   g_estadoIA = "INICIANDO";

// ==== Stats globales ====
int      g_totalTrades = 0;
int      g_totalWins   = 0;
int      g_totalLosses = 0;
double   g_totalPnL    = 0;
double   g_maxDDHist   = 0;
double   g_mejorRacha  = 0;
double   g_peorRacha   = 0;

// ==== SAML STATE ====
SSRule   g_SSRules[SS_MAX_RULES];
int      g_SSRuleCount   = 0;
int      g_SSNextId      = 1;
int      g_SSGeneration  = 0;
int      g_SSTradesDesdeEvo = 0;
double   g_SSUltBoost    = 0;
double   g_SSUltLotMult  = 1.0;
bool     g_SSUltBlocked  = false;
int      g_SSUltFired    = 0;

// ==== Panel ====
int      Magic1 = 0, Magic2 = 0;
int      OrdenesCompra = 0, OrdenesVenta = 0;
double   ProfitCompra = 0, ProfitVenta = 0;
double   LoteTotalCompra = 0, LoteTotalVenta = 0;
double   PrecioPromCompra = 0, PrecioPromVenta = 0;
double   UltimoPrecioCompra = 0, UltimoPrecioVenta = 0;
double   UlimoPredNN = 0, UltimoVotoEns = 0, UltimoScore = 0;
string   NombreDia = "";

//====================================================================
//===================== INIT / DEINIT ================================
//====================================================================
int OnInit()
  {
   SufijoSimbolo = StringSubstr(Symbol(), 6, StringLen(Symbol()) - 6);
   Magic1 = NumeroMagicoCompra;
   Magic2 = NumeroMagicoVenta;

   string cfg[30];
   cfg[0]=Simbolo01;  cfg[1]=Simbolo02;  cfg[2]=Simbolo03;
   cfg[3]=Simbolo04;  cfg[4]=Simbolo05;  cfg[5]=Simbolo06;
   cfg[6]=Simbolo07;  cfg[7]=Simbolo08;  cfg[8]=Simbolo09;
   cfg[9]=Simbolo10;  cfg[10]=Simbolo11; cfg[11]=Simbolo12;
   cfg[12]=Simbolo13; cfg[13]=Simbolo14; cfg[14]=Simbolo15;
   cfg[15]=Simbolo16; cfg[16]=Simbolo17; cfg[17]=Simbolo18;
   cfg[18]=Simbolo19; cfg[19]=Simbolo20; cfg[20]=Simbolo21;
   cfg[21]=Simbolo22; cfg[22]=Simbolo23; cfg[23]=Simbolo24;
   cfg[24]=Simbolo25; cfg[25]=Simbolo26; cfg[26]=Simbolo27;
   cfg[27]=Simbolo28; cfg[28]=Simbolo29; cfg[29]=Simbolo30;

   NumSimbolos = 0;
   for(int k = 0; k < 30; k++)
      if(cfg[k] != "") { ListaSimbolos[NumSimbolos] = cfg[k] + SufijoSimbolo; NumSimbolos++; }

   for(int i = 0; i < NumSimbolos; i++)
     {
      g_trades[i]=0; g_wins[i]=0; g_losses[i]=0; g_pnl[i]=0;
      g_consecWin[i]=0; g_consecLoss[i]=0;
      g_ultimaDireccion[i]=0; g_ultimoLote[i]=0;
     }

   if(!CargarCerebro())
     {
      InicializarRedNeural();
      InicializarPool();
      Print("Primera ejecución — cerebro inicializado desde cero");
     }
   CargarExperiencia();

   // ==== SAML ====
   if(ActivarSAML)
     {
      if(!SS_Load())
        {
         SS_InitSemilla();
         Print("SAML: script inicial creado (reglas semilla)");
        }
      else
         Print("SAML: ", g_SSRuleCount, " reglas cargadas, Gen ", g_SSGeneration);
     }

   InicializarJournal();
   g_pesoNN  = PesoRedNeural;
   g_pesoEns = PesoEnsemble;
   g_peakEquity = AccountEquity();

   if(AccountBalance() < BALANCE_MINIMO)
      Print("AVISO: Balance mínimo recomendado $", BALANCE_MINIMO);

   EventSetTimer(60);

   Print("===== SAMU AI v8.5 =====");
   Print("Simbolos activos: ", NumSimbolos);
   Print("Red NN: ", NN_INPUTS, "-", NN_HIDDEN, "-", NN_OUTPUTS);
   Print("Pool genetico: ", TamanoPoolEstrategias);
   Print("SAML: ", (ActivarSAML?"ON":"OFF"), " — reglas=", g_SSRuleCount);
   Print("Modo Cripto: ", (ModoCripto ? "SI" : "NO"));
   Print("Generacion actual: ", g_Generacion, " / SAML Gen: ", g_SSGeneration);
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {
   GuardarCerebro();
   GuardarExperiencia();
   GuardarStatsCSV();
   ExportarParaIAExterna();
   if(ActivarSAML) SS_Save();
   EventKillTimer();

   for(int i = ObjectsTotal() - 1; i >= 0; i--)
     {
      string nm = ObjectName(i);
      if(StringFind(nm, "P_") == 0 ||
         StringFind(nm, "SR_") == 0 ||
         StringFind(nm, "CANAL_") == 0 ||
         StringFind(nm, "MA_") == 0)
         ObjectDelete(nm);
     }
   ChartRedraw();
   Print("SAMU AI v8.5 detenido — memoria guardada");
  }

//====================================================================
//===================== ONTICK =======================================
//====================================================================
void OnTick()
  {
   if(!g_VisInit) { InicializarVisuales(); g_VisInit = true; }

   ProcesarCierres();
   ActualizarCircuitBreaker();
   if(TimeCurrent() < g_PausaHasta) { ActualizarPanel(); return; }

   if(MostrarPisosTechos && Bars > 150) ActualizarNiveles();

   string ocupados[];
   int numOcupados = 0;
   ArrayResize(ocupados, 0);

   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderMagicNumber() != Magic1 && OrderMagicNumber() != Magic2) continue;
      bool dup = false;
      for(int j = 0; j < numOcupados; j++)
         if(ocupados[j] == OrderSymbol()) { dup = true; break; }
      if(!dup)
        {
         numOcupados++;
         ArrayResize(ocupados, numOcupados, 0);
         ocupados[numOcupados-1] = OrderSymbol();
        }
     }

   for(int s = 0; s < NumSimbolos; s++)
      ProcesarSimbolo(s, numOcupados, ocupados);

   ActualizarPanel();
  }

//====================================================================
//===================== ONTIMER ======================================
//====================================================================
void OnTimer()
  {
   if(!ActivarRedNeural) return;
   if(Bars < VentanaEntrenamiento + 50) return;

   if(Time[0] != g_UltimaBarraEntren)
     {
      g_UltimaBarraEntren = Time[0];
      EntrenarRedSupervisado();
     }

   int minutosDesdeReplay = (int)((TimeCurrent() - g_UltimoReplay) / 60);
   if(minutosDesdeReplay >= (60 / MathMax(1, ReplaysPorHora)))
     {
      g_UltimoReplay = TimeCurrent();
      EntrenarConReplay(BatchReplay);
     }

   ChartRedraw();
  }

//====================================================================
//=============== PROCESAMIENTO POR SÍMBOLO ==========================
//====================================================================
void ProcesarSimbolo(int idx, int numOcupados, string &ocupados[])
  {
   string sym = ListaSimbolos[idx];

   bool puedeOperar = false;
   if(numOcupados < MaxParesSimultaneos) puedeOperar = true;
   else
      for(int k = 0; k < numOcupados && k < MaxParesSimultaneos; k++)
         if(sym == ocupados[k]) { puedeOperar = true; break; }

   int    dg   = (int)MarketInfo(sym, MODE_DIGITS);
   double tick = MarketInfo(sym, MODE_TICKSIZE);
   double lMin = MarketInfo(sym, MODE_MINLOT);
   double lMax = MarketInfo(sym, MODE_MAXLOT);
   double lStep= MarketInfo(sym, MODE_LOTSTEP);
   if(tick <= 0 || dg <= 0) return;

   int dLote = 2;
   if(lStep == 0.1) dLote = 1; else if(lStep == 1.0) dLote = 0;

   bool esCripto = EsSimboloCripto(sym);
   double fPip = 10;
   if(dg == 3 && StringFind(sym, "JPY") > 0) fPip = 100;
   if(esCripto && dg <= 2) fPip = 1;
   if(esCripto && dg == 3) fPip = 10;

   int oC = 0, oV = 0;
   double sumPC = 0, sumPV = 0, pC = 0, pV = 0;
   double uPC = 0, uPV = 0, loteC = 0, loteV = 0;

   for(int i = 0; i < OrdersTotal(); i++)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderSymbol() != sym) continue;
      if(OrderMagicNumber() == Magic1 && OrderType() == OP_BUY)
        { oC++; sumPC += OrderOpenPrice(); loteC += OrderLots(); pC = sumPC/oC; uPC = OrderOpenPrice(); }
      if(OrderMagicNumber() == Magic2 && OrderType() == OP_SELL)
        { oV++; sumPV += OrderOpenPrice(); loteV += OrderLots(); pV = sumPV/oV; uPV = OrderOpenPrice(); }
     }

   if(sym == Symbol())
     {
      OrdenesCompra = oC; OrdenesVenta = oV;
      LoteTotalCompra = loteC; LoteTotalVenta = loteV;
      PrecioPromCompra = pC; PrecioPromVenta = pV;
      UltimoPrecioCompra = uPC; UltimoPrecioVenta = uPV;
     }

   int regimen = DetectarRegimen(sym);
   if(FiltroRegimen && regimen == REG_CAOS) return;

   if(FiltroSpread)
     {
      double spr = (MarketInfo(sym, MODE_ASK) - MarketInfo(sym, MODE_BID)) / tick / fPip;
      double maxSpread = esCripto ? SpreadMaxCripto : SpreadMaxPips;
      if(spr > maxSpread) return;
     }

   bool aplicarFiltroHorario = FiltroHorario;
   if(esCripto && SinFiltroHorarioCripto) aplicarFiltroHorario = false;

   if(aplicarFiltroHorario)
      if(!(TimeCurrent() >= StringToTime(HoraInicio) && TimeCurrent() < StringToTime(HoraFin))) return;

   // ==== FEATURES ====
   double features[NN_INPUTS];
   ExtraerFeatures(sym, features);

   // ==== NN ====
   double predNN = ForwardPass(features);
   double votoNN = (predNN - 0.5) * 2.0;

   // ==== Ensemble ====
   double votoEns = VotarEstrategias(features);

   // ==== Score base ====
   double scoreFinal = g_pesoNN * votoNN + g_pesoEns * votoEns;

   // ==== SAML: EVALUAR REGLAS ====
   double samlBoost = 0;
   double samlLotMult = 1.0;
   bool   samlBlocked = false;
   double samlSLMult = 1.0;
   double samlTPMult = 1.0;
   int    fired[SS_MAX_RULES];
   int    nFired = 0;

   if(ActivarSAML && g_SSRuleCount > 0)
      SS_Evaluate(idx, sym, features, predNN, votoEns, scoreFinal,
                  samlBoost, samlLotMult, samlBlocked,
                  samlSLMult, samlTPMult, fired, nFired);

   scoreFinal += samlBoost;

   if(sym == Symbol())
     {
      UlimoPredNN = predNN;
      UltimoVotoEns = votoEns;
      UltimoScore = scoreFinal;
      g_SSUltBoost = samlBoost;
      g_SSUltLotMult = samlLotMult;
      g_SSUltBlocked = samlBlocked;
      g_SSUltFired = nFired;
     }

   if(samlBlocked) return;

   int direccion = 0;
   double umbral = esCripto ? 0.25 : 0.30;
   if(scoreFinal >  umbral) direccion =  1;
   if(scoreFinal < -umbral) direccion = -1;
   if(direccion == 0) return;

   if(FiltroTendencia)
     {
      double ema50  = iMA(sym, PERIOD_CURRENT, 50, 0, MODE_EMA, PRICE_CLOSE, 0);
      double ema200 = iMA(sym, PERIOD_CURRENT, 200, 0, MODE_EMA, PRICE_CLOSE, 0);
      if(direccion > 0 && ema50 < ema200) return;
      if(direccion < 0 && ema50 > ema200) return;
     }

   if(FiltroRegimen)
     {
      if(direccion > 0 && regimen == REG_BAJA) return;
      if(direccion < 0 && regimen == REG_ALZA) return;
     }

   double atr = iATR(sym, PERIOD_CURRENT, 14, 0);
   if(atr <= 0) return;
   double multATR = esCripto ? MultiplicadorATRCripto : 1.0;
   double slDist = atr * StopLossATR * multATR * samlSLMult;
   double tpDist = atr * TakeProfitATR * multATR * samlTPMult;

   double ask = MarketInfo(sym, MODE_ASK);
   double bid = MarketInfo(sym, MODE_BID);
   double sl, tp, precio;

   if(direccion > 0)
     { precio = ask; sl = NormalizeDouble(ask - slDist, dg); tp = NormalizeDouble(ask + tpDist, dg); }
   else
     { precio = bid; sl = NormalizeDouble(bid + slDist, dg); tp = NormalizeDouble(bid - tpDist, dg); }

   double loteBase = CalcularLoteKelly(idx, slDist, fPip, lMin, lMax, dLote);
   double loteFin  = AjustarPorRacha(idx, loteBase, lMin, lMax, dLote);

   loteFin = NormalizeDouble(loteFin * samlLotMult, dLote);
   if(loteFin < lMin) loteFin = lMin;
   if(loteFin > lMax) loteFin = lMax;

   if(g_NivelDD >= 1) loteFin = NormalizeDouble(loteFin * 0.5, dLote);
   if(g_NivelDD >= 2) loteFin = NormalizeDouble(lMin, dLote);
   if(loteFin < lMin) loteFin = lMin;

   if(direccion > 0 && oC >= MaxOrdenesSimbolo) return;
   if(direccion < 0 && oV >= MaxOrdenesSimbolo) return;

   if(direccion > 0 && oC > 0)
     {
      double nextLvl = uPC - DistanciaGridPips * fPip * tick;
      if(ask > nextLvl) return;
     }
   if(direccion < 0 && oV > 0)
     {
      double nextLvl = uPV + DistanciaGridPips * fPip * tick;
      if(bid < nextLvl) return;
     }

   if(!puedeOperar) return;
   if(AccountFreeMargin() < MarketInfo(sym, MODE_MARGINREQUIRED) * loteFin) return;

   int tk = -1;
   if(direccion > 0)
      tk = OrderSend(sym, OP_BUY, loteFin, ask, 20, sl, tp, ComentarioOrden, Magic1, 0, clrLime);
   else
      tk = OrderSend(sym, OP_SELL, loteFin, bid, 20, sl, tp, ComentarioOrden, Magic2, 0, clrRed);

   if(tk > 0)
     {
      g_ultimoLote[idx] = loteFin;
      g_ultimaDireccion[idx] = direccion;
      RegistrarApertura(tk, features, (double)direccion, predNN, votoEns, scoreFinal);
      // Guardar reglas SAML que dispararon para este ticket
      for(int k = 0; k < g_ticketCount; k++)
         if(g_ticketPendiente[k] == tk)
           {
            for(int r = 0; r < SS_MAX_RULES; r++) g_ticketSAMLFire[k][r] = 0;
            for(int f = 0; f < nFired; f++)
               if(fired[f] >= 0 && fired[f] < SS_MAX_RULES) g_ticketSAMLFire[k][fired[f]] = 1;
            break;
           }
     }
   else
      Print("OrderSend falló [", sym, "]: ", GetLastError());
  }

//====================================================================
//=================== FEATURES =======================================
//====================================================================
void ExtraerFeatures(string sym, double &f[])
  {
   double rsi = iRSI(sym, PERIOD_CURRENT, 14, PRICE_CLOSE, 0);
   f[0] = (rsi - 50.0) / 50.0;

   double macd = iMACD(sym, PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, 0);
   double atr  = iATR(sym, PERIOD_CURRENT, 14, 0);
   f[1] = (atr > 0) ? MathMax(-1.0, MathMin(1.0, macd / atr)) : 0;

   double ema20 = iMA(sym, PERIOD_CURRENT, 20, 0, MODE_EMA, PRICE_CLOSE, 0);
   double ema50 = iMA(sym, PERIOD_CURRENT, 50, 0, MODE_EMA, PRICE_CLOSE, 0);
   double precio = MarketInfo(sym, MODE_BID);
   f[2] = (precio > 0) ? MathMax(-1.0, MathMin(1.0, (ema20 - ema50) / precio * 500)) : 0;

   double up = iBands(sym, PERIOD_CURRENT, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, 0);
   double lo = iBands(sym, PERIOD_CURRENT, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, 0);
   f[3] = (up > lo) ? ((precio - lo) / (up - lo)) * 2.0 - 1.0 : 0;

   double atr100 = iATR(sym, PERIOD_CURRENT, 100, 0);
   f[4] = (atr100 > 0) ? MathMax(-1.0, MathMin(1.0, (atr / atr100) - 1.0)) : 0;

   if(Bars > 6)
     {
      double mom = (Close[0] - Close[5]) / MathMax(atr, 0.00001);
      f[5] = MathMax(-1.0, MathMin(1.0, mom));
     }
   else f[5] = 0;

   double stoch = iStochastic(sym, PERIOD_CURRENT, 14, 3, 3, MODE_SMA, 0, MODE_MAIN, 0);
   f[6] = (stoch - 50.0) / 50.0;

   double cci = iCCI(sym, PERIOD_CURRENT, 20, PRICE_TYPICAL, 0);
   f[7] = MathMax(-1.0, MathMin(1.0, cci / 200.0));

   int h = Hour();
   f[8] = MathSin(2.0 * 3.14159 * h / 24.0);

   int dw = DayOfWeek();
   f[9] = MathCos(2.0 * 3.14159 * dw / 7.0);
  }

//====================================================================
//=================== RED NEURONAL ===================================
//====================================================================
void InicializarRedNeural()
  {
   MathSrand((int)TimeLocal());
   for(int i = 0; i < NN_W1_SIZE; i++)
     { g_W1[i] = (MathRand()/32767.0 - 0.5) * 0.5; g_vW1[i] = 0; }
   for(int i = 0; i < NN_B1_SIZE; i++) { g_B1[i] = 0; g_vB1[i] = 0; }
   for(int i = 0; i < NN_W2_SIZE; i++)
     { g_W2[i] = (MathRand()/32767.0 - 0.5) * 0.5; g_vW2[i] = 0; }
   for(int i = 0; i < NN_B2_SIZE; i++) { g_B2[i] = 0; g_vB2[i] = 0; }
  }

double Sigmoid(double x)
  {
   if(x >  20) return 1.0;
   if(x < -20) return 0.0;
   return 1.0 / (1.0 + MathExp(-x));
  }
double SigmoidDeriv(double y) { return y * (1.0 - y); }
double Tanh(double x) { return 2.0 * Sigmoid(2.0 * x) - 1.0; }

// *** FIX: 'input' -> 'entrada' ***
double ForwardPass(double &entrada[])
  {
   for(int i = 0; i < NN_INPUTS; i++) g_input[i] = entrada[i];

   for(int h = 0; h < NN_HIDDEN; h++)
     {
      double s = g_B1[h];
      for(int i = 0; i < NN_INPUTS; i++)
         s += g_input[i] * g_W1[i * NN_HIDDEN + h];
      g_hidden[h] = Tanh(s);
     }

   double out = g_B2[0];
   for(int h = 0; h < NN_HIDDEN; h++)
      out += g_hidden[h] * g_W2[h];
   g_output[0] = Sigmoid(out);
   return g_output[0];
  }

//====================================================================
//=================== ENTRENAMIENTO SUPERVISADO ======================
//====================================================================
void EntrenarRedSupervisado()
  {
   if(!ActivarRedNeural) return;
   int maxB = MathMin(VentanaEntrenamiento, Bars - 20);
   if(maxB < 50) return;

   double sumaErr = 0;
   int muestras = 0;
   g_estadoIA = "ENTRENANDO";

   for(int b = 1; b <= maxB; b++)
     {
      double f[NN_INPUTS];
      if(!FeaturesEnBarra(Symbol(), b, f)) continue;

      double ret = Close[b-1] - Close[b];
      double target = (ret > 0) ? 1.0 : 0.0;

      double pred = ForwardPass(f);
      double error = target - pred;
      sumaErr += error * error;
      muestras++;

      BackpropUnaMuestra(f, target);

      if(muestras >= 200) break;
     }

   double mse = (muestras > 0) ? sumaErr / muestras : 0;
   g_estadoIA = "MSE=" + DoubleToString(mse, 4);
  }

bool FeaturesEnBarra(string sym, int bar, double &f[])
  {
   if(bar + 100 >= Bars) return false;

   double rsi = iRSI(sym, PERIOD_CURRENT, 14, PRICE_CLOSE, bar);
   f[0] = (rsi - 50.0) / 50.0;

   double macd = iMACD(sym, PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, bar);
   double atr  = iATR(sym, PERIOD_CURRENT, 14, bar);
   f[1] = (atr > 0) ? MathMax(-1.0, MathMin(1.0, macd / atr)) : 0;

   double ema20 = iMA(sym, PERIOD_CURRENT, 20, 0, MODE_EMA, PRICE_CLOSE, bar);
   double ema50 = iMA(sym, PERIOD_CURRENT, 50, 0, MODE_EMA, PRICE_CLOSE, bar);
   double precio = Close[bar];
   f[2] = (precio > 0) ? MathMax(-1.0, MathMin(1.0, (ema20 - ema50) / precio * 500)) : 0;

   double up = iBands(sym, PERIOD_CURRENT, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, bar);
   double lo = iBands(sym, PERIOD_CURRENT, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, bar);
   f[3] = (up > lo) ? ((precio - lo) / (up - lo)) * 2.0 - 1.0 : 0;

   double atr100 = iATR(sym, PERIOD_CURRENT, 100, bar);
   f[4] = (atr100 > 0) ? MathMax(-1.0, MathMin(1.0, (atr / atr100) - 1.0)) : 0;

   if(bar + 5 < Bars)
     {
      double mom = (Close[bar] - Close[bar+5]) / MathMax(atr, 0.00001);
      f[5] = MathMax(-1.0, MathMin(1.0, mom));
     }
   else f[5] = 0;

   double stoch = iStochastic(sym, PERIOD_CURRENT, 14, 3, 3, MODE_SMA, 0, MODE_MAIN, bar);
   f[6] = (stoch - 50.0) / 50.0;

   double cci = iCCI(sym, PERIOD_CURRENT, 20, PRICE_TYPICAL, bar);
   f[7] = MathMax(-1.0, MathMin(1.0, cci / 200.0));

   datetime t = Time[bar];
   f[8] = MathSin(2.0 * 3.14159 * TimeHour(t) / 24.0);
   f[9] = MathCos(2.0 * 3.14159 * TimeDayOfWeek(t) / 7.0);

   return true;
  }

// *** FIX: 'input' -> 'entrada' ***
void BackpropUnaMuestra(double &entrada[], double target)
  {
   double pred = ForwardPass(entrada);
   double error = target - pred;
   double dOut = error * SigmoidDeriv(pred);

   double dHidden[NN_HIDDEN];
   for(int h = 0; h < NN_HIDDEN; h++)
      dHidden[h] = dOut * g_W2[h] * (1.0 - g_hidden[h] * g_hidden[h]);

   for(int h = 0; h < NN_HIDDEN; h++)
     {
      double grad = dOut * g_hidden[h];
      g_vW2[h] = MomentumNN * g_vW2[h] + LearningRateNN * grad;
      g_W2[h] += g_vW2[h];
     }
   g_vB2[0] = MomentumNN * g_vB2[0] + LearningRateNN * dOut;
   g_B2[0] += g_vB2[0];

   for(int i = 0; i < NN_INPUTS; i++)
      for(int h = 0; h < NN_HIDDEN; h++)
        {
         double grad = dHidden[h] * entrada[i];
         int idxW = i * NN_HIDDEN + h;
         g_vW1[idxW] = MomentumNN * g_vW1[idxW] + LearningRateNN * grad;
         g_W1[idxW] += g_vW1[idxW];
        }
   for(int h = 0; h < NN_HIDDEN; h++)
     {
      g_vB1[h] = MomentumNN * g_vB1[h] + LearningRateNN * dHidden[h];
      g_B1[h] += g_vB1[h];
     }
  }

//====================================================================
//=================== POOL GENÉTICO ==================================
//====================================================================
void InicializarPool()
  {
   MathSrand((int)TimeLocal() + 42);
   for(int s = 0; s < TamanoPoolEstrategias; s++)
     {
      for(int i = 0; i < STRAT_FEATURES; i++)
         g_Pool[s][i] = (MathRand()/32767.0 - 0.5) * 2.0;
      g_Fitness[s] = 0;
      g_EdadEstrategia[s] = 0;
     }
  }

double VotarEstrategias(double &features[])
  {
   double sumaPond = 0, sumaPesos = 0;
   for(int s = 0; s < TamanoPoolEstrategias; s++)
     {
      double voto = 0;
      for(int i = 0; i < STRAT_FEATURES; i++)
         voto += g_Pool[s][i] * features[i];
      voto = Tanh(voto);
      double peso = MathMax(0.01, g_Fitness[s] + 0.5);
      sumaPond += voto * peso;
      sumaPesos += peso;
     }
   if(sumaPesos < 0.001) return 0;
   return sumaPond / sumaPesos;
  }

void EvolucionarPool()
  {
   for(int s = 0; s < TamanoPoolEstrategias; s++)
      g_Fitness[s] = EvaluarEstrategia(s, 200);

   int indices[64];
   for(int i = 0; i < TamanoPoolEstrategias; i++) indices[i] = i;
   for(int i = 0; i < TamanoPoolEstrategias - 1; i++)
      for(int j = i + 1; j < TamanoPoolEstrategias; j++)
         if(g_Fitness[indices[j]] > g_Fitness[indices[i]])
           { int t = indices[i]; indices[i] = indices[j]; indices[j] = t; }

   int top = TamanoPoolEstrategias / 2;
   double nueva[64][STRAT_FEATURES];
   double nuevosFit[64];

   for(int i = 0; i < top; i++)
     {
      int src = indices[i];
      for(int k = 0; k < STRAT_FEATURES; k++) nueva[i][k] = g_Pool[src][k];
      nuevosFit[i] = g_Fitness[src];
     }

   MathSrand((int)TimeLocal() + g_Generacion * 97);
   for(int i = top; i < TamanoPoolEstrategias; i++)
     {
      int p1 = indices[MathRand() % top];
      int p2 = indices[MathRand() % top];
      int cruce = MathRand() % STRAT_FEATURES;
      for(int k = 0; k < STRAT_FEATURES; k++)
        {
         double gen = (k < cruce) ? g_Pool[p1][k] : g_Pool[p2][k];
         if((MathRand() % 100) < 15)
            gen += (MathRand()/32767.0 - 0.5) * 0.8;
         if(gen >  2.0) gen =  2.0;
         if(gen < -2.0) gen = -2.0;
         nueva[i][k] = gen;
        }
      nuevosFit[i] = 0;
     }

   for(int i = 0; i < TamanoPoolEstrategias; i++)
     {
      for(int k = 0; k < STRAT_FEATURES; k++) g_Pool[i][k] = nueva[i][k];
      g_Fitness[i] = nuevosFit[i];
      g_EdadEstrategia[i]++;
     }
   g_Generacion++;
   Print("Generación #", g_Generacion, " — mejor fitness: ",
         DoubleToString(g_Fitness[indices[0]], 4));
  }

double EvaluarEstrategia(int idx, int barras)
  {
   int maxB = MathMin(barras, Bars - 20);
   double aciertos = 0, total = 0;
   for(int b = 1; b <= maxB; b++)
     {
      double f[NN_INPUTS];
      if(!FeaturesEnBarra(Symbol(), b, f)) continue;
      double voto = 0;
      for(int k = 0; k < STRAT_FEATURES; k++)
         voto += g_Pool[idx][k] * f[k];
      voto = Tanh(voto);
      double ret = Close[b-1] - Close[b];
      if(MathAbs(voto) < 0.2) continue;
      if(voto > 0 && ret > 0) aciertos++;
      else if(voto < 0 && ret < 0) aciertos++;
      total++;
     }
   return (total > 0) ? aciertos / total : 0.5;
  }

//====================================================================
//=================== EXPERIENCE REPLAY ==============================
//====================================================================
void RegistrarExperiencia(double &features[], double accion, double recompensa)
  {
   int cap = MathMin(MaxExperiencia, MAX_EXP_HARD);
   int pos = g_exp_pos;
   for(int i = 0; i < NN_INPUTS; i++) g_exp_feat[pos][i] = features[i];
   g_exp_acc[pos] = accion;
   g_exp_rew[pos] = recompensa;
   g_exp_tim[pos] = TimeCurrent();
   g_exp_pos = (g_exp_pos + 1) % cap;
   if(g_exp_count < cap) g_exp_count++;
  }

// *** FIX: pasar fila 2D a 1D buffer ***
void EntrenarConReplay(int batchSize)
  {
   if(g_exp_count < 100) return;
   MathSrand((int)TimeLocal() + g_exp_entrenamientos);

   double sumaErr = 0;
   int exitos = 0;
   double buffer[NN_INPUTS];   // buffer 1D

   for(int b = 0; b < batchSize; b++)
     {
      int idx = MathRand() % g_exp_count;
      double target;
      if(g_exp_acc[idx] > 0.5)        target = (g_exp_rew[idx] > 0) ? 1.0 : 0.0;
      else if(g_exp_acc[idx] < -0.5)  target = (g_exp_rew[idx] > 0) ? 0.0 : 1.0;
      else continue;

      for(int i = 0; i < NN_INPUTS; i++) buffer[i] = g_exp_feat[idx][i];

      double pred = ForwardPass(buffer);
      double error = target - pred;
      sumaErr += error * error;
      exitos++;
      BackpropUnaMuestra(buffer, target);
     }

   g_exp_entrenamientos++;
   double mse = (exitos > 0) ? sumaErr / exitos : 0;

   if(g_exp_entrenamientos % 10 == 0)
      Print("Replay #", g_exp_entrenamientos, " MSE=", DoubleToString(mse,4),
            " buffer=", g_exp_count);
  }

//====================================================================
//=================== REGISTRAR APERTURA/CIERRE ======================
//====================================================================
void RegistrarApertura(int ticket, double &features[], double accion,
                       double predNN, double votoEns, double score)
  {
   if(g_ticketCount >= MAX_TICKETS) return;
   g_ticketPendiente[g_ticketCount] = ticket;
   for(int i = 0; i < NN_INPUTS; i++)
      g_ticketFeat[g_ticketCount][i] = features[i];
   g_ticketAccion[g_ticketCount]  = accion;
   g_ticketPredNN[g_ticketCount]  = predNN;
   g_ticketVotoEns[g_ticketCount] = votoEns;
   g_ticketScore[g_ticketCount]   = score;
   g_ticketHora[g_ticketCount]    = TimeCurrent();
   for(int r = 0; r < SS_MAX_RULES; r++) g_ticketSAMLFire[g_ticketCount][r] = 0;
   g_ticketCount++;
  }

void ProcesarCierres()
  {
   int total = OrdersHistoryTotal();
   for(int h = total - 1; h >= 0 && h >= total - 20; h--)
     {
      if(!OrderSelect(h, SELECT_BY_POS, MODE_HISTORY)) continue;
      if(OrderMagicNumber() != Magic1 && OrderMagicNumber() != Magic2) continue;
      if(OrderType() != OP_BUY && OrderType() != OP_SELL) continue;

      int tk = OrderTicket();
      bool procesado = false;
      for(int k = 0; k < g_ticketCount; k++)
         if(g_ticketPendiente[k] == -tk) { procesado = true; break; }
      if(procesado) continue;

      double pnl = OrderProfit() + OrderSwap() + OrderCommission();
      double sl  = OrderStopLoss();
      double op  = OrderOpenPrice();
      double riesgo = MathAbs(op - sl);
      double tickVal = MarketInfo(OrderSymbol(), MODE_TICKVALUE);
      double lots = OrderLots();
      double rewardR = 0;
      if(riesgo > 0 && tickVal > 0)
        {
         double riskMoney = (riesgo / MarketInfo(OrderSymbol(), MODE_TICKSIZE)) * tickVal * lots;
         if(riskMoney > 0) rewardR = pnl / riskMoney;
        }

      double f[NN_INPUTS];
      ArrayInitialize(f, 0);
      double accion = 0, predNN = 0, votoEns = 0, score = 0;
      datetime hora = 0;
      int fired[SS_MAX_RULES];
      for(int r = 0; r < SS_MAX_RULES; r++) fired[r] = 0;

      for(int k = 0; k < g_ticketCount; k++)
        {
         if(g_ticketPendiente[k] == tk)
           {
            for(int i = 0; i < NN_INPUTS; i++) f[i] = g_ticketFeat[k][i];
            accion  = g_ticketAccion[k];
            predNN  = g_ticketPredNN[k];
            votoEns = g_ticketVotoEns[k];
            score   = g_ticketScore[k];
            hora    = g_ticketHora[k];
            for(int r = 0; r < SS_MAX_RULES; r++) fired[r] = g_ticketSAMLFire[k][r];
            g_ticketPendiente[k] = -tk;
            break;
           }
        }

      RegistrarExperiencia(f, accion, rewardR);

      // ==== SAML: actualizar fitness de las reglas que dispararon ====
      if(ActivarSAML)
        {
         bool win = (pnl > 0);
         for(int r = 0; r < g_SSRuleCount; r++)
           {
            if(fired[r] == 1)
              {
               if(win) g_SSRules[r].hits++;
               else    g_SSRules[r].misses++;
               int tot = g_SSRules[r].hits + g_SSRules[r].misses;
               if(tot > 0)
                  g_SSRules[r].fitness = (double)g_SSRules[r].hits / tot;
              }
           }
         g_SSTradesDesdeEvo++;
         if(g_SSTradesDesdeEvo >= SAML_EvolucionCada)
           {
            g_SSTradesDesdeEvo = 0;
            SS_Evolve();
           }
        }

      int duracion = (hora > 0) ? (int)((TimeCurrent()-hora)/60) : 0;
      EscribirJournal(tk, OrderSymbol(), (OrderType()==OP_BUY?1:-1),
                      lots, op, OrderClosePrice(), sl, OrderTakeProfit(),
                      OrderProfit(), OrderSwap(), OrderCommission(), duracion,
                      predNN, votoEns, score, rewardR);

      g_totalTrades++;
      if(pnl > 0) g_totalWins++; else g_totalLosses++;
      g_totalPnL += pnl;

      int idx = BuscarIndiceSimbolo(OrderSymbol());
      if(idx >= 0)
        {
         g_trades[idx]++;
         if(pnl > 0) { g_wins[idx]++; g_consecWin[idx]++; g_consecLoss[idx] = 0; }
         else        { g_losses[idx]++; g_consecLoss[idx]++; g_consecWin[idx] = 0; }
         g_pnl[idx] += pnl;
        }
     }

   g_tradesDesdeEvolucion++;
   if(g_tradesDesdeEvolucion >= FrecuenciaEvolucion)
     {
      g_tradesDesdeEvolucion = 0;
      EvolucionarPool();
     }

   ActualizarMetaPesos();
  }

//====================================================================
//=================== META-LEARNER ===================================
//====================================================================
void ActualizarMetaPesos()
  {
   int totNN  = g_aciertosNN + g_fallosNN;
   int totEns = g_aciertosEns + g_fallosEns;
   if(totNN < 10 && totEns < 10) return;

   double wrNN  = (totNN > 0)  ? (double)g_aciertosNN / totNN   : 0.5;
   double wrEns = (totEns > 0) ? (double)g_aciertosEns / totEns : 0.5;

   double sNN  = MathMax(0.1, wrNN  - 0.5) * 2.0;
   double sEns = MathMax(0.1, wrEns - 0.5) * 2.0;
   double suma = sNN + sEns;
   if(suma < 0.01) { g_pesoNN = 0.5; g_pesoEns = 0.5; return; }
   g_pesoNN  = sNN  / suma;
   g_pesoEns = sEns / suma;
  }

//====================================================================
//=================== CIRCUIT BREAKER ================================
//====================================================================
void ActualizarCircuitBreaker()
  {
   if(!ActivarCircuitBreaker) return;
   double eq = AccountEquity();
   if(eq > g_peakEquity) g_peakEquity = eq;
   double dd = (g_peakEquity > 0) ? (g_peakEquity - eq)/g_peakEquity*100.0 : 0;
   if(dd > g_maxDDHist) g_maxDDHist = dd;

   if(dd >= DD_Nivel3)
     {
      g_NivelDD = 3;
      g_PausaHasta = TimeCurrent() + HorasPausaDD * 3600;
      CerrarTodo();
      Print("CIRCUIT BREAKER: DD ", DoubleToString(dd,2), "% — pausa ", HorasPausaDD, "h");
     }
   else if(dd >= DD_Nivel2) g_NivelDD = 2;
   else if(dd >= DD_Nivel1) g_NivelDD = 1;
   else                     g_NivelDD = 0;
  }

void CerrarTodo()
  {
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderMagicNumber() != Magic1 && OrderMagicNumber() != Magic2) continue;
      if(OrderType() == OP_BUY)
         OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 20, clrRed);
      else if(OrderType() == OP_SELL)
         OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 20, clrRed);
     }
  }

//====================================================================
//=================== KELLY + ANTI-MARTINGALA ========================
//====================================================================
double CalcularLoteKelly(int idx, double slDist, double fPip,
                         double lMin, double lMax, int dLote)
  {
   double winRate = 0.55, payoff = 1.8;
   if(g_trades[idx] >= 10)
     {
      winRate = (double)g_wins[idx] / g_trades[idx];
      if(winRate < 0.1) winRate = 0.1;
      if(winRate > 0.9) winRate = 0.9;
     }

   double kelly = (winRate * payoff - (1 - winRate)) / payoff;
   if(kelly <= 0) kelly = 0.005;
   double fraccion = kelly * FraccionKelly;
   double riesgo = AccountBalance() * fraccion;

   double tickVal = MarketInfo(ListaSimbolos[idx], MODE_TICKVALUE);
   double tickSz  = MarketInfo(ListaSimbolos[idx], MODE_TICKSIZE);
   if(tickVal <= 0 || slDist <= 0 || tickSz <= 0) return lMin;

   double pipsRiesgo = slDist / tickSz;
   double lotes = riesgo / (pipsRiesgo * tickVal);

   if(lotes < lMin) lotes = lMin;
   if(lotes > lMax) lotes = lMax;
   return NormalizeDouble(lotes, dLote);
  }

double AjustarPorRacha(int idx, double base, double lMin, double lMax, int dLote)
  {
   double mult = 1.0;
   if(g_consecLoss[idx] == 1) mult = 0.75;
   else if(g_consecLoss[idx] >= 2) mult = 0.50;
   if(g_consecWin[idx] == 2) mult = 1.25;
   else if(g_consecWin[idx] >= 3) mult = 1.50;
   double l = NormalizeDouble(base * mult, dLote);
   if(l < lMin) l = lMin;
   if(l > lMax) l = lMax;
   return l;
  }

//====================================================================
//=================== REGÍMENES ======================================
//====================================================================
int DetectarRegimen(string sym)
  {
   double atr14  = iATR(sym, PERIOD_CURRENT, 14, 0);
   double atr100 = iATR(sym, PERIOD_CURRENT, 100, 0);
   if(atr100 <= 0) return REG_RANGO;
   double ratio = atr14 / atr100;
   double limiteCaos = ModoCripto ? ToleranciaVolatilidad : 1.8;
   if(ratio > limiteCaos) return REG_CAOS;

   double adx = iADX(sym, PERIOD_CURRENT, 14, PRICE_CLOSE, MODE_MAIN, 0);
   double ema50  = iMA(sym, PERIOD_CURRENT, 50, 0, MODE_EMA, PRICE_CLOSE, 0);
   double ema200 = iMA(sym, PERIOD_CURRENT, 200, 0, MODE_EMA, PRICE_CLOSE, 0);
   if(adx > 25)
     {
      if(ema50 > ema200) return REG_ALZA;
      if(ema50 < ema200) return REG_BAJA;
     }
   return REG_RANGO;
  }

bool EsSimboloCripto(string sym)
  {
   if(!ModoCripto) return false;
   if(StringFind(sym, "BTC") >= 0) return true;
   if(StringFind(sym, "ETH") >= 0) return true;
   if(StringFind(sym, "XRP") >= 0) return true;
   if(StringFind(sym, "LTC") >= 0) return true;
   if(StringFind(sym, "ADA") >= 0) return true;
   if(StringFind(sym, "DOT") >= 0) return true;
   if(StringFind(sym, "SOL") >= 0) return true;
   if(StringFind(sym, "BNB") >= 0) return true;
   return false;
  }

//====================================================================
//====================================================================
//=================== SAML SCRIPT ENGINE =============================
//====================================================================
//====================================================================

//--------------------------------------------------------------------
// Inicializa reglas semilla (heurísticas humanas)
//--------------------------------------------------------------------
void SS_InitSemilla()
  {
   g_SSRuleCount = 0;
   g_SSNextId = 1;
   g_SSGeneration = 0;

   // R1: RSI extremo + MACD negativo → BOOST alcista
   SS_AddRule(10, 0, 0, 0.5, 0, 1, 0, 0.3, 0, 0.15);

   // R2: NN muy bajista → aumentar lote (mean reversion)
   SS_AddRule(8, 0, SS_FEAT_NN, SS_OP_LT, -0.4, 1, 0, 0.0, 0, 1.20);

   // R3: DD ≥ 8% → bloquear
   SS_AddRule(15, 0, SS_FEAT_DD, SS_OP_GE, 8.0, 2, 0.0, 0, 0.0, 0);

   // R4: FEAT3 (posición en BB) muy alto → BOOST bajista
   SS_AddRule(6, 0, 3, SS_OP_GT, 0.7, 0, -0.10, 0, 0.0, 0);

   // R5: Dos pérdidas consecutivas → reducir lote
   SS_AddRule(7, 0, SS_FEAT_CL, SS_OP_GE, 2.0, 1, 0.7, 0, 0.0, 0);

   Print("SAML: ", g_SSRuleCount, " reglas semilla generadas");
  }

//--------------------------------------------------------------------
// Añade una regla (helper de una condición + una acción)
//--------------------------------------------------------------------
void SS_AddRule(int prio, int nCond,
                int idx1, int op1, double v1, int log1,
                int idx2, int op2, double v2, int log2)
  {
   if(g_SSRuleCount >= SS_MAX_RULES) return;
   int i = g_SSRuleCount;

   g_SSRules[i].id         = g_SSNextId++;
   g_SSRules[i].priority   = prio;
   g_SSRules[i].active     = 1;
   g_SSRules[i].condCount  = (nCond < 1) ? 1 : ((nCond > SS_MAX_COND) ? SS_MAX_COND : nCond);

   g_SSRules[i].condIdx[0]   = idx1;
   g_SSRules[i].condOp[0]    = op1;
   g_SSRules[i].condVal[0]   = v1;
   g_SSRules[i].condLogic[0] = log1;

   g_SSRules[i].condIdx[1]   = idx2;
   g_SSRules[i].condOp[1]    = op2;
   g_SSRules[i].condVal[1]   = v2;
   g_SSRules[i].condLogic[1] = log2;

   g_SSRules[i].condIdx[2]   = 0;
   g_SSRules[i].condOp[2]    = 0;
   g_SSRules[i].condVal[2]   = 0;
   g_SSRules[i].condLogic[2] = 0;

   // Detectar actionType desde nCond==0 (marcador interno) — por defecto BOOST
   // Se sobreescribe según patrón: si v1 es 0 y v2 no → es BOOST
   g_SSRules[i].actionType = SS_ACT_BOOST;
   g_SSRules[i].actionVal  = 0.10;

   g_SSRules[i].hits        = 0;
   g_SSRules[i].misses      = 0;
   g_SSRules[i].fitness     = 0.5;
   g_SSRules[i].generation  = 0;

   g_SSRuleCount++;
  }

//--------------------------------------------------------------------
// Versión avanzada: añade regla completa (con actionType explícito)
//--------------------------------------------------------------------
void SS_AddRuleFull(int prio, int nCond,
                    int idx1, int op1, double v1, int log1,
                    int idx2, int op2, double v2, int log2,
                    int idx3, int op3, double v3,
                    int actType, double actVal)
  {
   if(g_SSRuleCount >= SS_MAX_RULES) return;
   int i = g_SSRuleCount;

   g_SSRules[i].id         = g_SSNextId++;
   g_SSRules[i].priority   = prio;
   g_SSRules[i].active     = 1;
   g_SSRules[i].condCount  = (nCond < 1) ? 1 : ((nCond > SS_MAX_COND) ? SS_MAX_COND : nCond);

   g_SSRules[i].condIdx[0] = idx1; g_SSRules[i].condOp[0] = op1;
   g_SSRules[i].condVal[0] = v1;   g_SSRules[i].condLogic[0] = log1;
   g_SSRules[i].condIdx[1] = idx2; g_SSRules[i].condOp[1] = op2;
   g_SSRules[i].condVal[1] = v2;   g_SSRules[i].condLogic[1] = log2;
   g_SSRules[i].condIdx[2] = idx3; g_SSRules[i].condOp[2] = op3;
   g_SSRules[i].condVal[2] = v3;   g_SSRules[i].condLogic[2] = 0;

   g_SSRules[i].actionType = actType;
   g_SSRules[i].actionVal  = actVal;

   g_SSRules[i].hits = 0; g_SSRules[i].misses = 0;
   g_SSRules[i].fitness = 0.5;
   g_SSRules[i].generation = g_SSGeneration;

   g_SSRuleCount++;
  }

//--------------------------------------------------------------------
// Evalúa una condición contra el estado actual
//--------------------------------------------------------------------
bool SS_EvalCond(int idx, int op, double val,
                 double &features[], double predNN, double votoEns,
                 double score, double winRate, double dd,
                 int consecLoss, int consecWin)
  {
   double lhs = 0;
   switch(idx)
     {
      case SS_FEAT_NN:    lhs = (predNN - 0.5) * 2.0; break;
      case SS_FEAT_ENS:   lhs = votoEns;              break;
      case SS_FEAT_SCORE: lhs = score;                break;
      case SS_FEAT_WR:    lhs = winRate;              break;
      case SS_FEAT_DD:    lhs = dd;                   break;
      case SS_FEAT_CL:    lhs = (double)consecLoss;   break;
      case SS_FEAT_CW:    lhs = (double)consecWin;    break;
      default:
         if(idx >= 0 && idx < NN_INPUTS) lhs = features[idx];
         else return false;
     }

   switch(op)
     {
      case SS_OP_GT: return (lhs >  val);
      case SS_OP_LT: return (lhs <  val);
      case SS_OP_GE: return (lhs >= val);
      case SS_OP_LE: return (lhs <= val);
     }
   return false;
  }

//--------------------------------------------------------------------
// Evalúa todas las reglas y devuelve acumuladores ajustados
//--------------------------------------------------------------------
void SS_Evaluate(int symIdx, string sym, double &features[],
                 double predNN, double votoEns, double score,
                 double &outBoost, double &outLotMult, bool &outBlocked,
                 double &outSLMult, double &outTPMult,
                 int &fired[], int &nFired)
  {
   outBoost   = 0;
   outLotMult = 1.0;
   outBlocked = false;
   outSLMult  = 1.0;
   outTPMult  = 1.0;
   nFired     = 0;

   double eq = AccountEquity();
   double dd = (g_peakEquity > 0) ? (g_peakEquity - eq)/g_peakEquity*100.0 : 0;

   double winRate = 0.5;
   int cl = 0, cw = 0;
   if(symIdx >= 0 && symIdx < 30)
     {
      if(g_trades[symIdx] > 0)
         winRate = (double)g_wins[symIdx] / g_trades[symIdx];
      cl = g_consecLoss[symIdx];
      cw = g_consecWin[symIdx];
     }

   // Ordenar por prioridad (bubble simple sobre índices)
   int order[SS_MAX_RULES];
   for(int i = 0; i < g_SSRuleCount; i++) order[i] = i;
   for(int i = 0; i < g_SSRuleCount - 1; i++)
      for(int j = i + 1; j < g_SSRuleCount; j++)
         if(g_SSRules[order[j]].priority > g_SSRules[order[i]].priority)
           { int t = order[i]; order[i] = order[j]; order[j] = t; }

   for(int oi = 0; oi < g_SSRuleCount; oi++)
     {
      int i = order[oi];
      if(g_SSRules[i].active == 0) continue;

      bool result = false;
      int nc = g_SSRules[i].condCount;
      if(nc >= 1)
         result = SS_EvalCond(g_SSRules[i].condIdx[0], g_SSRules[i].condOp[0],
                              g_SSRules[i].condVal[0], features, predNN, votoEns,
                              score, winRate, dd, cl, cw);

      if(nc >= 2)
        {
         bool r2 = SS_EvalCond(g_SSRules[i].condIdx[1], g_SSRules[i].condOp[1],
                               g_SSRules[i].condVal[1], features, predNN, votoEns,
                               score, winRate, dd, cl, cw);
         if(g_SSRules[i].condLogic[0] == 0) result = result && r2;
         else                                result = result || r2;
        }

      if(nc >= 3)
        {
         bool r3 = SS_EvalCond(g_SSRules[i].condIdx[2], g_SSRules[i].condOp[2],
                               g_SSRules[i].condVal[2], features, predNN, votoEns,
                               score, winRate, dd, cl, cw);
         if(g_SSRules[i].condLogic[1] == 0) result = result && r3;
         else                                result = result || r3;
        }

      if(!result) continue;

      // Registrar disparo
      if(nFired < SS_MAX_RULES) { fired[nFired] = i; nFired++; }

      // Aplicar acción
      switch(g_SSRules[i].actionType)
        {
         case SS_ACT_BOOST:
            outBoost += g_SSRules[i].actionVal;
            break;
         case SS_ACT_LOT_MULT:
            outLotMult *= g_SSRules[i].actionVal;
            break;
         case SS_ACT_BLOCK:
            outBlocked = true;
            break;
         case SS_ACT_SL_MULT:
            outSLMult *= g_SSRules[i].actionVal;
            break;
         case SS_ACT_TP_MULT:
            outTPMult *= g_SSRules[i].actionVal;
            break;
         case SS_ACT_NN_WEIGHT:
            g_pesoNN = MathMax(0.05, MathMin(0.95, g_SSRules[i].actionVal));
            g_pesoEns = 1.0 - g_pesoNN;
            break;
         case SS_ACT_ENS_WEIGHT:
            g_pesoEns = MathMax(0.05, MathMin(0.95, g_SSRules[i].actionVal));
            g_pesoNN  = 1.0 - g_pesoEns;
            break;
        }
     }

   // Clamps de seguridad
   if(outBoost >  0.8) outBoost =  0.8;
   if(outBoost < -0.8) outBoost = -0.8;
   if(outLotMult > 3.0) outLotMult = 3.0;
   if(outLotMult < 0.2) outLotMult = 0.2;
   if(outSLMult > 2.5) outSLMult = 2.5;
   if(outSLMult < 0.3) outSLMult = 0.3;
   if(outTPMult > 3.0) outTPMult = 3.0;
   if(outTPMult < 0.3) outTPMult = 0.3;
  }

//--------------------------------------------------------------------
// Evoluciona el pool de reglas SAML
//--------------------------------------------------------------------
void SS_Evolve()
  {
   if(g_SSRuleCount == 0) return;
   g_SSGeneration++;

   // Ordenar por fitness descendente
   int order[SS_MAX_RULES];
   for(int i = 0; i < g_SSRuleCount; i++) order[i] = i;
   for(int i = 0; i < g_SSRuleCount - 1; i++)
      for(int j = i + 1; j < g_SSRuleCount; j++)
         if(g_SSRules[order[j]].fitness > g_SSRules[order[i]].fitness)
           { int t = order[i]; order[i] = order[j]; order[j] = t; }

   int eliteN = g_SSRuleCount / 4;
   if(eliteN < 2) eliteN = 2;

   // Desactivar reglas con fitness muy bajo y pocas muestras
   for(int i = 0; i < g_SSRuleCount; i++)
     {
      int tot = g_SSRules[i].hits + g_SSRules[i].misses;
      if(tot >= 8 && g_SSRules[i].fitness < 0.35)
         g_SSRules[i].active = 0;
     }

   // Mutación de la élite
   MathSrand((int)TimeLocal() + g_SSGeneration * 137 + g_totalTrades);
   for(int i = 0; i < eliteN; i++)
     {
      int src = order[i];
      if((MathRand() % 100) < (int)(SAML_TasaMutacion * 100))
        {
         // Mutar umbral de una condición
         int c = MathRand() % g_SSRules[src].condCount;
         double delta = (MathRand()/32767.0 - 0.5) * 0.4;
         g_SSRules[src].condVal[c] += delta;

         // Mutar actionVal
         if((MathRand() % 2) == 0)
           {
            double am = 1.0 + (MathRand()/32767.0 - 0.5) * 0.3;
            g_SSRules[src].actionVal *= am;
           }
        }
     }

   // Crear nueva regla mutada (cruce de dos padres élite) si hay espacio
   if(g_SSRuleCount < SS_MAX_RULES && eliteN >= 2)
     {
      int p1 = order[MathRand() % eliteN];
      int p2 = order[MathRand() % eliteN];

      int i = g_SSRuleCount;
      g_SSRules[i].id        = g_SSNextId++;
      g_SSRules[i].priority  = (g_SSRules[p1].priority + g_SSRules[p2].priority) / 2;
      g_SSRules[i].active    = 1;
      g_SSRules[i].condCount = MathMax(g_SSRules[p1].condCount, g_SSRules[p2].condCount);
      if(g_SSRules[i].condCount > SS_MAX_COND) g_SSRules[i].condCount = SS_MAX_COND;

      for(int c = 0; c < SS_MAX_COND; c++)
        {
         int par = ((MathRand() % 2) == 0) ? p1 : p2;
         if(c < g_SSRules[par].condCount)
           {
            g_SSRules[i].condIdx[c]   = g_SSRules[par].condIdx[c];
            g_SSRules[i].condOp[c]    = g_SSRules[par].condOp[c];
            g_SSRules[i].condVal[c]   = g_SSRules[par].condVal[c] +
                                        (MathRand()/32767.0 - 0.5) * 0.2;
            g_SSRules[i].condLogic[c] = g_SSRules[par].condLogic[c];
           }
         else
           {
            g_SSRules[i].condIdx[c]   = 0;
            g_SSRules[i].condOp[c]    = SS_OP_GT;
            g_SSRules[i].condVal[c]   = 0;
            g_SSRules[i].condLogic[c] = 0;
           }
        }

      int parA = ((MathRand() % 2) == 0) ? p1 : p2;
      g_SSRules[i].actionType = g_SSRules[parA].actionType;
      g_SSRules[i].actionVal  = g_SSRules[parA].actionVal *
                                (1.0 + (MathRand()/32767.0 - 0.5) * 0.25);

      g_SSRules[i].hits = 0;
      g_SSRules[i].misses = 0;
      g_SSRules[i].fitness = 0.5;
      g_SSRules[i].generation = g_SSGeneration;
      g_SSRuleCount++;
     }

   // Auto-generar una regla nueva desde patrón estadístico
   if(SAML_AutoGenerar && g_SSRuleCount < SS_MAX_RULES && g_exp_count >= 100)
      SS_GenerateFromPattern();

   SS_Save();

   // Log
   double fitTop = (g_SSRuleCount > 0) ? g_SSRules[order[0]].fitness : 0;
   Print("SAML Gen #", g_SSGeneration,
         " — reglas=", g_SSRuleCount,
         " top_fitness=", DoubleToString(fitTop,3));
  }

//--------------------------------------------------------------------
// Genera una regla nueva analizando el buffer de experiencia
// (busca correlación de un feature con ganancia)
//--------------------------------------------------------------------
void SS_GenerateFromPattern()
  {
   // Elegir feature aleatorio y dirección
   int fi = MathRand() % NN_INPUTS;
   int signo = (MathRand() % 2) == 0 ? 1 : -1;

   // Calcular umbral como percentil 70
   double vals[500];
   int n = MathMin(g_exp_count, 500);
   for(int i = 0; i < n; i++)
     {
      int idx = (g_exp_count < MAX_EXP_HARD) ? i : ((g_exp_pos + i) % MAX_EXP_HARD);
      vals[i] = g_exp_feat[idx][fi];
     }
   // Ordenar (simple)
   for(int i = 0; i < n - 1; i++)
      for(int j = i + 1; j < n; j++)
         if(vals[j] < vals[i]) { double t = vals[i]; vals[i] = vals[j]; vals[j] = t; }

   double umbral = vals[(int)(n * 0.7)];
   double umbralBajo = vals[(int)(n * 0.3)];

   int op, ci; double cv;
   if(signo > 0) { op = SS_OP_GT; cv = umbral; }
   else          { op = SS_OP_LT; cv = umbralBajo; }
   ci = fi;

   // Buscar el actionType dominante entre los trades que cumplen
   double sumRewPos = 0, sumRewNeg = 0; int nPos = 0, nNeg = 0;
   for(int i = 0; i < n; i++)
     {
      int idx = (g_exp_count < MAX_EXP_HARD) ? i : ((g_exp_pos + i) % MAX_EXP_HARD);
      bool cumple = (signo > 0) ? (g_exp_feat[idx][fi] > umbral) : (g_exp_feat[idx][fi] < umbralBajo);
      if(!cumple) continue;
      if(g_exp_rew[idx] > 0) { sumRewPos += g_exp_rew[idx]; nPos++; }
      else                   { sumRewNeg += g_exp_rew[idx]; nNeg++; }
     }

   if(nPos + nNeg < 10) return;

   double wrPatron = (double)nPos / (nPos + nNeg);
   if(wrPatron > 0.6)
     {
      // Regla BUENA → reforzar
      int act = SS_ACT_BOOST;
      double av = (wrPatron - 0.5) * 0.4;
      if(wrPatron > 0.7) { act = SS_ACT_LOT_MULT; av = 1.15; }

      SS_AddRuleFull(5, 1, ci, op, cv, 0, 0, 0, 0, 0, 0, 0, 0, act, av);
      Print("SAML: nueva regla auto-generada desde patrón (WR=", DoubleToString(wrPatron,2), ")");
     }
   else if(wrPatron < 0.35)
     {
      // Patrón malo → BLOCK
      SS_AddRuleFull(12, 1, ci, op, cv, 0, 0, 0, 0, 0, 0, 0, 0, SS_ACT_BLOCK, 1.0);
      Print("SAML: regla BLOCK auto-generada (WR=", DoubleToString(wrPatron,2), ")");
     }
  }

//--------------------------------------------------------------------
// Persistencia: guardar/leer SAML en texto + binario
//--------------------------------------------------------------------
void SS_Save()
  {
   // Texto legible (editable)
   int h = FileOpen(ARCHIVO_SAML, FILE_WRITE | FILE_TXT | FILE_ANSI);
   if(h != INVALID_HANDLE)
     {
      FileWrite(h, "REM SAMU Auto-Learning Script v1.0");
      FileWrite(h, "REM Generacion global: " + IntegerToString(g_SSGeneration));
      FileWrite(h, "REM Formato: RULE|id|prio|active|hits|miss|fitness|gen|actionType|actionVal|nCond|idx1|op1|val1|log1|idx2|op2|val2|log2|idx3|op3|val3");
      for(int i = 0; i < g_SSRuleCount; i++)
        {
         string ln = "RULE|" +
            IntegerToString(g_SSRules[i].id)         + "|" +
            IntegerToString(g_SSRules[i].priority)   + "|" +
            IntegerToString(g_SSRules[i].active)     + "|" +
            IntegerToString(g_SSRules[i].hits)       + "|" +
            IntegerToString(g_SSRules[i].misses)     + "|" +
            DoubleToString(g_SSRules[i].fitness, 4)  + "|" +
            IntegerToString(g_SSRules[i].generation) + "|" +
            IntegerToString(g_SSRules[i].actionType) + "|" +
            DoubleToString(g_SSRules[i].actionVal,4) + "|" +
            IntegerToString(g_SSRules[i].condCount)  + "|" +
            IntegerToString(g_SSRules[i].condIdx[0]) + "|" +
            IntegerToString(g_SSRules[i].condOp[0])  + "|" +
            DoubleToString(g_SSRules[i].condVal[0],4)+ "|" +
            IntegerToString(g_SSRules[i].condLogic[0]) + "|" +
            IntegerToString(g_SSRules[i].condIdx[1]) + "|" +
            IntegerToString(g_SSRules[i].condOp[1])  + "|" +
            DoubleToString(g_SSRules[i].condVal[1],4)+ "|" +
            IntegerToString(g_SSRules[i].condLogic[1]) + "|" +
            IntegerToString(g_SSRules[i].condIdx[2]) + "|" +
            IntegerToString(g_SSRules[i].condOp[2])  + "|" +
            DoubleToString(g_SSRules[i].condVal[2],4);
         FileWrite(h, ln);
        }
      FileClose(h);
     }

   // Binario (rápido)
   int hb = FileOpen(ARCHIVO_SAML_BIN, FILE_WRITE | FILE_BIN);
   if(hb == INVALID_HANDLE) return;
   FileWriteInteger(hb, 0x534D4C31);       // "SML1"
   FileWriteInteger(hb, g_SSRuleCount);
   FileWriteInteger(hb, g_SSNextId);
   FileWriteInteger(hb, g_SSGeneration);
   for(int i = 0; i < g_SSRuleCount; i++)
     {
      FileWriteInteger(hb, g_SSRules[i].id);
      FileWriteInteger(hb, g_SSRules[i].priority);
      FileWriteInteger(hb, g_SSRules[i].active);
      FileWriteInteger(hb, g_SSRules[i].condCount);
      for(int c = 0; c < SS_MAX_COND; c++)
        {
         FileWriteInteger(hb, g_SSRules[i].condIdx[c]);
         FileWriteInteger(hb, g_SSRules[i].condOp[c]);
         FileWriteDouble (hb, g_SSRules[i].condVal[c]);
         FileWriteInteger(hb, g_SSRules[i].condLogic[c]);
        }
      FileWriteInteger(hb, g_SSRules[i].actionType);
      FileWriteDouble (hb, g_SSRules[i].actionVal);
      FileWriteInteger(hb, g_SSRules[i].hits);
      FileWriteInteger(hb, g_SSRules[i].misses);
      FileWriteDouble (hb, g_SSRules[i].fitness);
      FileWriteInteger(hb, g_SSRules[i].generation);
     }
   FileClose(hb);
  }

bool SS_Load()
  {
   if(!FileIsExist(ARCHIVO_SAML_BIN)) return false;
   int h = FileOpen(ARCHIVO_SAML_BIN, FILE_READ | FILE_BIN);
   if(h == INVALID_HANDLE) return false;

   int firma = FileReadInteger(h);
   if(firma != 0x534D4C31) { FileClose(h); return false; }

   int n = FileReadInteger(h);
   if(n < 0 || n > SS_MAX_RULES) n = 0;
   g_SSNextId     = FileReadInteger(h);
   g_SSGeneration = FileReadInteger(h);

   g_SSRuleCount = 0;
   for(int i = 0; i < n; i++)
     {
      g_SSRules[i].id       = FileReadInteger(h);
      g_SSRules[i].priority = FileReadInteger(h);
      g_SSRules[i].active   = FileReadInteger(h);
      g_SSRules[i].condCount= FileReadInteger(h);
      for(int c = 0; c < SS_MAX_COND; c++)
        {
         g_SSRules[i].condIdx[c]   = FileReadInteger(h);
         g_SSRules[i].condOp[c]    = FileReadInteger(h);
         g_SSRules[i].condVal[c]   = FileReadDouble(h);
         g_SSRules[i].condLogic[c] = FileReadInteger(h);
        }
      g_SSRules[i].actionType = FileReadInteger(h);
      g_SSRules[i].actionVal  = FileReadDouble(h);
      g_SSRules[i].hits       = FileReadInteger(h);
      g_SSRules[i].misses     = FileReadInteger(h);
      g_SSRules[i].fitness    = FileReadDouble(h);
      g_SSRules[i].generation = FileReadInteger(h);
      g_SSRuleCount++;
     }
   FileClose(h);
   return (g_SSRuleCount > 0);
  }

//====================================================================
//=================== PERSISTENCIA PRINCIPAL =========================
//====================================================================
void GuardarCerebro()
  {
   int h = FileOpen(ARCHIVO_CEREBRO, FILE_WRITE | FILE_BIN);
   if(h == INVALID_HANDLE) { Print("Error cerebro: ", GetLastError()); return; }

   FileWriteInteger(h, 0x53414D55);
   FileWriteInteger(h, 850);

   FileWriteArray(h, g_W1, 0, NN_W1_SIZE);
   FileWriteArray(h, g_B1, 0, NN_B1_SIZE);
   FileWriteArray(h, g_W2, 0, NN_W2_SIZE);
   FileWriteArray(h, g_B2, 0, NN_B2_SIZE);

   for(int s = 0; s < TamanoPoolEstrategias; s++)
      for(int k = 0; k < STRAT_FEATURES; k++)
         FileWriteDouble(h, g_Pool[s][k]);

   FileWriteDouble(h, g_pesoNN);
   FileWriteDouble(h, g_pesoEns);
   FileWriteInteger(h, g_Generacion);
   FileWriteInteger(h, g_aciertosNN);
   FileWriteInteger(h, g_fallosNN);
   FileWriteInteger(h, g_aciertosEns);
   FileWriteInteger(h, g_fallosEns);
   FileWriteInteger(h, g_totalTrades);
   FileWriteInteger(h, g_totalWins);
   FileWriteInteger(h, g_totalLosses);
   FileWriteDouble(h,  g_totalPnL);
   FileWriteDouble(h,  g_maxDDHist);
   FileWriteDouble(h,  g_mejorRacha);
   FileWriteDouble(h,  g_peorRacha);
   FileClose(h);
  }

bool CargarCerebro()
  {
   if(!FileIsExist(ARCHIVO_CEREBRO)) return false;
   int h = FileOpen(ARCHIVO_CEREBRO, FILE_READ | FILE_BIN);
   if(h == INVALID_HANDLE) return false;

   int firma = FileReadInteger(h);
   if(firma != 0x53414D55) { FileClose(h); return false; }
   int ver = FileReadInteger(h);
   if(ver != 850 && ver != 800) { FileClose(h); return false; }

   FileReadArray(h, g_W1, 0, NN_W1_SIZE);
   FileReadArray(h, g_B1, 0, NN_B1_SIZE);
   FileReadArray(h, g_W2, 0, NN_W2_SIZE);
   FileReadArray(h, g_B2, 0, NN_B2_SIZE);

   for(int s = 0; s < TamanoPoolEstrategias; s++)
      for(int k = 0; k < STRAT_FEATURES; k++)
         g_Pool[s][k] = FileReadDouble(h);

   g_pesoNN      = FileReadDouble(h);
   g_pesoEns     = FileReadDouble(h);
   g_Generacion  = FileReadInteger(h);
   g_aciertosNN  = FileReadInteger(h);
   g_fallosNN    = FileReadInteger(h);
   g_aciertosEns = FileReadInteger(h);
   g_fallosEns   = FileReadInteger(h);
   g_totalTrades = FileReadInteger(h);
   g_totalWins   = FileReadInteger(h);
   g_totalLosses = FileReadInteger(h);
   g_totalPnL    = FileReadDouble(h);
   g_maxDDHist   = FileReadDouble(h);
   g_mejorRacha  = FileReadDouble(h);
   g_peorRacha   = FileReadDouble(h);
   FileClose(h);

   Print("Cerebro cargado — ", g_totalTrades, " trades previos, Gen ", g_Generacion);
   return true;
  }

void GuardarExperiencia()
  {
   int h = FileOpen(ARCHIVO_EXPERIENCIA, FILE_WRITE | FILE_BIN);
   if(h == INVALID_HANDLE) return;
   FileWriteInteger(h, g_exp_count);
   FileWriteInteger(h, g_exp_pos);

   int cap = MathMin(MaxExperiencia, MAX_EXP_HARD);
   int inicio = (g_exp_count < cap) ? 0 : g_exp_pos;
   for(int k = 0; k < g_exp_count; k++)
     {
      int idx = (inicio + k) % cap;
      for(int i = 0; i < NN_INPUTS; i++) FileWriteDouble(h, g_exp_feat[idx][i]);
      FileWriteDouble(h, g_exp_acc[idx]);
      FileWriteDouble(h, g_exp_rew[idx]);
      FileWriteInteger(h, (int)g_exp_tim[idx]);
     }
   FileClose(h);
  }

void CargarExperiencia()
  {
   if(!FileIsExist(ARCHIVO_EXPERIENCIA)) return;
   int h = FileOpen(ARCHIVO_EXPERIENCIA, FILE_READ | FILE_BIN);
   if(h == INVALID_HANDLE) return;
   int cap = MathMin(MaxExperiencia, MAX_EXP_HARD);
   int count = FileReadInteger(h);
   int pos   = FileReadInteger(h);
   if(count > cap) count = cap;
   for(int k = 0; k < count; k++)
     {
      int idx = k % cap;
      for(int i = 0; i < NN_INPUTS; i++) g_exp_feat[idx][i] = FileReadDouble(h);
      g_exp_acc[idx] = FileReadDouble(h);
      g_exp_rew[idx] = FileReadDouble(h);
      g_exp_tim[idx] = (datetime)FileReadInteger(h);
     }
   g_exp_count = count;
   g_exp_pos   = pos;
   FileClose(h);
   Print("Experiencia cargada: ", g_exp_count, " muestras");
  }

//====================================================================
//=================== JOURNAL + STATS CSV ============================
//====================================================================
void InicializarJournal()
  {
   if(FileIsExist(ARCHIVO_JOURNAL)) return;
   int h = FileOpen(ARCHIVO_JOURNAL, FILE_WRITE | FILE_CSV, ';');
   if(h == INVALID_HANDLE) return;
   FileWrite(h,"Fecha","Ticket","Simbolo","Dir","Lote","PAp","PCierre","SL","TP",
               "PnL","Swap","Com","Dur_min","PredNN","VotoEns","Score","RewardR","Gen");
   FileClose(h);
  }

void EscribirJournal(int tk, string sym, int dir, double lote,
                     double pAp, double pCi, double sl, double tp,
                     double pnl, double swap, double comm, int dur,
                     double predNN, double votoEns, double score, double rew)
  {
   int h = FileOpen(ARCHIVO_JOURNAL, FILE_READ|FILE_WRITE|FILE_CSV, ';');
   if(h == INVALID_HANDLE) return;
   FileSeek(h, 0, SEEK_END);
   FileWrite(h, TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS),
      IntegerToString(tk), sym, (dir>0?"BUY":"SELL"), DoubleToString(lote,2),
      DoubleToString(pAp,5), DoubleToString(pCi,5),
      DoubleToString(sl,5), DoubleToString(tp,5),
      DoubleToString(pnl,2), DoubleToString(swap,2), DoubleToString(comm,2),
      IntegerToString(dur), DoubleToString(predNN,4), DoubleToString(votoEns,4),
      DoubleToString(score,4), DoubleToString(rew,3), IntegerToString(g_Generacion));
   FileClose(h);
  }

void GuardarStatsCSV()
  {
   int h = FileOpen(ARCHIVO_STATS, FILE_WRITE | FILE_CSV, ';');
   if(h == INVALID_HANDLE) return;
   FileWrite(h,"Simbolo","Trades","Wins","Losses","WinRate","PnL","RachaW","RachaL");
   for(int i = 0; i < NumSimbolos; i++)
     {
      double wr = (g_trades[i] > 0) ? (double)g_wins[i]/g_trades[i]*100 : 0;
      FileWrite(h, ListaSimbolos[i], IntegerToString(g_trades[i]),
                   IntegerToString(g_wins[i]), IntegerToString(g_losses[i]),
                   DoubleToString(wr,1), DoubleToString(g_pnl[i],2),
                   IntegerToString(g_consecWin[i]), IntegerToString(g_consecLoss[i]));
     }
   FileWrite(h, "");
   FileWrite(h, "GLOBAL");
   FileWrite(h, "TotalTrades", IntegerToString(g_totalTrades));
   FileWrite(h, "TotalWins",   IntegerToString(g_totalWins));
   FileWrite(h, "TotalLosses", IntegerToString(g_totalLosses));
   FileWrite(h, "TotalPnL",    DoubleToString(g_totalPnL,2));
   FileWrite(h, "MaxDD",       DoubleToString(g_maxDDHist,2));
   FileWrite(h, "Generacion",  IntegerToString(g_Generacion));
   FileWrite(h, "Replays",     IntegerToString(g_exp_entrenamientos));
   FileWrite(h, "SAML_Gen",    IntegerToString(g_SSGeneration));
   FileWrite(h, "SAML_Rules",  IntegerToString(g_SSRuleCount));
   FileClose(h);
  }

//====================================================================
//=================== EXPORTAR PARA IA EXTERNA =======================
//====================================================================
void ExportarParaIAExterna()
  {
   int h = FileOpen(ARCHIVO_EXPORT, FILE_WRITE | FILE_CSV, ',');
   if(h == INVALID_HANDLE) return;

   FileWrite(h, "# SAMU AI v8.5 — Exportación completa para IA externa");
   FileWrite(h, "# Formato: CSV. Puede importarse en Python/PyTorch/TensorFlow.");
   FileWrite(h, "# Timestamp: ", TimeToString(TimeCurrent(), TIME_DATE|TIME_SECONDS));
   FileWrite(h, "");

   FileWrite(h, "# ARQUITECTURA");
   FileWrite(h, "NN_INPUTS,", IntegerToString(NN_INPUTS));
   FileWrite(h, "NN_HIDDEN,", IntegerToString(NN_HIDDEN));
   FileWrite(h, "NN_OUTPUTS,", IntegerToString(NN_OUTPUTS));
   FileWrite(h, "POOL_SIZE,", IntegerToString(TamanoPoolEstrategias));
   FileWrite(h, "STRAT_FEATURES,", IntegerToString(STRAT_FEATURES));
   FileWrite(h, "GENERACION,", IntegerToString(g_Generacion));
   FileWrite(h, "REPLAYS,", IntegerToString(g_exp_entrenamientos));
   FileWrite(h, "EXPERIENCIA_BUFFER,", IntegerToString(g_exp_count));
   FileWrite(h, "SAML_RULES,", IntegerToString(g_SSRuleCount));
   FileWrite(h, "SAML_GEN,", IntegerToString(g_SSGeneration));
   FileWrite(h, "");

   FileWrite(h, "# PESOS_CAPA1_W1 [", NN_INPUTS, "x", NN_HIDDEN, "]");
   for(int i = 0; i < NN_INPUTS; i++)
     {
      string linea = "";
      for(int hh = 0; hh < NN_HIDDEN; hh++)
        {
         if(hh > 0) linea += ",";
         linea += DoubleToString(g_W1[i*NN_HIDDEN + hh], 6);
        }
      FileWrite(h, linea);
     }
   FileWrite(h, "");

   FileWrite(h, "# BIAS_CAPA1_B1");
   string sB1 = "";
   for(int hh = 0; hh < NN_HIDDEN; hh++)
     { if(hh>0) sB1 += ","; sB1 += DoubleToString(g_B1[hh], 6); }
   FileWrite(h, sB1);
   FileWrite(h, "");

   FileWrite(h, "# PESOS_CAPA2_W2");
   string sW2 = "";
   for(int hh = 0; hh < NN_HIDDEN; hh++)
     { if(hh>0) sW2 += ","; sW2 += DoubleToString(g_W2[hh], 6); }
   FileWrite(h, sW2);
   FileWrite(h, "# BIAS_CAPA2_B2,", DoubleToString(g_B2[0], 6));
   FileWrite(h, "");

   FileWrite(h, "# POOL_GENETICO [", TamanoPoolEstrategias, "x", STRAT_FEATURES, "]");
   for(int s = 0; s < TamanoPoolEstrategias; s++)
     {
      string ln = "";
      for(int k = 0; k < STRAT_FEATURES; k++)
        { if(k>0) ln += ","; ln += DoubleToString(g_Pool[s][k], 6); }
      FileWrite(h, ln);
     }
   FileWrite(h, "");

   FileWrite(h, "# META_PESOS");
   FileWrite(h, "PesoNN,",  DoubleToString(g_pesoNN, 4));
   FileWrite(h, "PesoEns,", DoubleToString(g_pesoEns, 4));
   FileWrite(h, "");

   FileWrite(h, "# ESTADISTICAS_GLOBALES");
   FileWrite(h, "TotalTrades,",  IntegerToString(g_totalTrades));
   FileWrite(h, "TotalWins,",    IntegerToString(g_totalWins));
   FileWrite(h, "TotalLosses,",  IntegerToString(g_totalLosses));
   FileWrite(h, "TotalPnL,",     DoubleToString(g_totalPnL, 2));
   FileWrite(h, "MaxDD,",        DoubleToString(g_maxDDHist, 2));
   FileWrite(h, "");

   FileWrite(h, "# EXPERIENCIA [features x ", NN_INPUTS, " + accion + reward]");
   int maxExp = MathMin(g_exp_count, 500);
   for(int k = 0; k < maxExp; k++)
     {
      int idx = (g_exp_count < MAX_EXP_HARD) ? k : ((g_exp_pos + k) % MAX_EXP_HARD);
      string ln = "";
      for(int i = 0; i < NN_INPUTS; i++)
        { ln += DoubleToString(g_exp_feat[idx][i], 6) + ","; }
      ln += DoubleToString(g_exp_acc[idx], 2) + ",";
      ln += DoubleToString(g_exp_rew[idx], 4);
      FileWrite(h, ln);
     }

   FileClose(h);
   Print("Exportación completa: ", ARCHIVO_EXPORT);
  }

//====================================================================
//=================== UTILIDADES =====================================
//====================================================================
int BuscarIndiceSimbolo(string sym)
  {
   for(int i = 0; i < NumSimbolos; i++)
      if(ListaSimbolos[i] == sym) return i;
   return -1;
  }

//====================================================================
//=================== VISUALES =======================================
//====================================================================
void InicializarVisuales()
  {
   if(PintarVelas)
     {
      ChartSetInteger(0, CHART_COLOR_CANDLE_BULL, clrLime);
      ChartSetInteger(0, CHART_COLOR_CANDLE_BEAR, clrRed);
      ChartSetInteger(0, CHART_COLOR_CHART_UP,   clrLime);
      ChartSetInteger(0, CHART_COLOR_CHART_DOWN, clrRed);
      ChartSetInteger(0, CHART_COLOR_CHART_LINE, clrWhite);
      ChartSetInteger(0, CHART_COLOR_GRID,       C'60,60,60');
     }
   ChartRedraw();
  }

void ActualizarNiveles()
  {
   if(Time[0] == g_UltimaBarraNiv) return;
   g_UltimaBarraNiv = Time[0];
   if(Bars < 150) return;

   for(int i = ObjectsTotal() - 1; i >= 0; i--)
     {
      string nm = ObjectName(i);
      if(StringFind(nm, "SR_") == 0 || StringFind(nm, "CANAL_") == 0) ObjectDelete(nm);
     }

   int iHi = iHighest(Symbol(), PERIOD_CURRENT, MODE_HIGH, 100, 1);
   int iLo = iLowest (Symbol(), PERIOD_CURRENT, MODE_LOW,  100, 1);
   if(iHi < 0 || iLo < 0) return;

   double t = iHigh(Symbol(), PERIOD_CURRENT, iHi);
   double p = iLow (Symbol(), PERIOD_CURRENT, iLo);
   datetime t1 = Time[100];
   datetime t2 = Time[0] + PeriodSeconds() * 20;

   ObjectCreate("SR_Techo", OBJ_TREND, 0, t1, t, t2, t);
   ObjectSet("SR_Techo", OBJPROP_COLOR, clrTomato);
   ObjectSet("SR_Techo", OBJPROP_STYLE, STYLE_DASH);
   ObjectSet("SR_Techo", OBJPROP_RAY_RIGHT, true);

   ObjectCreate("SR_Piso", OBJ_TREND, 0, t1, p, t2, p);
   ObjectSet("SR_Piso", OBJPROP_COLOR, clrLime);
   ObjectSet("SR_Piso", OBJPROP_STYLE, STYLE_DASH);
   ObjectSet("SR_Piso", OBJPROP_RAY_RIGHT, true);

   if(MostrarCanales)
     {
      double med = (t + p) / 2.0;
      ObjectCreate("CANAL_Med", OBJ_TREND, 0, t1, med, t2, med);
      ObjectSet("CANAL_Med", OBJPROP_COLOR, clrGoldenrod);
      ObjectSet("CANAL_Med", OBJPROP_STYLE, STYLE_DASHDOT);
      ObjectSet("CANAL_Med", OBJPROP_RAY_RIGHT, true);
     }
  }

//====================================================================
//=================== PANEL ==========================================
//====================================================================
void Etiqueta(string nm, int x, int y, string txt, int tam, string fnt, color clr)
  {
   if(ObjectFind(nm) < 0) ObjectCreate(nm, OBJ_LABEL, 0, 0, 0);
   ObjectSet(nm, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSet(nm, OBJPROP_XDISTANCE, x);
   ObjectSet(nm, OBJPROP_YDISTANCE, y);
   ObjectSet(nm, OBJPROP_BACK, false);
   ObjectSet(nm, OBJPROP_SELECTABLE, false);
   ObjectSet(nm, OBJPROP_ZORDER, 100);
   ObjectSetText(nm, txt, tam, fnt, clr);
  }

void Rectangulo(string nm, int x, int y, int w, int h, color cf, color cb)
  {
   if(ObjectFind(nm) < 0) ObjectCreate(nm, OBJ_RECTANGLE_LABEL, 0, 0, 0);
   ObjectSet(nm, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSet(nm, OBJPROP_XDISTANCE, x);
   ObjectSet(nm, OBJPROP_YDISTANCE, y);
   ObjectSet(nm, OBJPROP_XSIZE, w);
   ObjectSet(nm, OBJPROP_YSIZE, h);
   ObjectSet(nm, OBJPROP_BGCOLOR, cf);
   ObjectSet(nm, OBJPROP_COLOR, cb);
   ObjectSet(nm, OBJPROP_BORDER_TYPE, BORDER_FLAT);
   ObjectSet(nm, OBJPROP_BACK, false);
   ObjectSet(nm, OBJPROP_ZORDER, 1);
  }

void ActualizarPanel()
  {
   color FP=C'15,22,36', FC=C'0,90,150', FS=C'35,52,78';
   color FF1=C'24,35,52', FF2=C'19,28,42', BRD=C'90,120,160';
   color TBL=clrWhite, TGR=C'200,210,225', TAZ=C'130,200,255';
   color TVE=C'120,230,140', TRO=C'255,130,130', TAM=C'255,210,90';
   color TVIO=C'180,140,255';

   int x=PANEL_X, y=PANEL_Y, W=PANEL_ANCHO;
   int dy=FILA_ALTO, ds=SECCION_ALTO;
   int pX=PADDING_X, pY=PADDING_Y;
   int cL=COL_LABEL, cV=COL_VALOR, cE=COL_ESTADO;

   bool balBajo = (AccountBalance() < BALANCE_MINIMO);
   color cBal = balBajo ? TRO : TVE;
   color cEq  = (AccountEquity() > AccountBalance()) ? TAZ : TRO;
   double dd=0;
   if(g_peakEquity>0) dd = (g_peakEquity - AccountEquity())/g_peakEquity*100.0;
   color cDD = (g_NivelDD==0) ? TVE : (g_NivelDD==1 ? TAM : TRO);

   int yCab=y,hCab=26;
   int yFec=yCab+hCab,hFec=dy;
   int yS1=yFec+hFec,hS1=ds;
   int yF1=yS1+hS1,hF1=dy;
   int yF2=yF1+hF1,hF2=dy;
   int yF3=yF2+hF2,hF3=dy;
   int yS2=yF3+hF3+3,hS2=ds;
   int yF4=yS2+hS2,hF4=dy;
   int yF5=yF4+hF4,hF5=dy;
   int yF6=yF5+hF5,hF6=dy;
   int yF7=yF6+hF6,hF7=dy;
   int yS3=yF7+hF7+3,hS3=ds;
   int yF8=yS3+hS3,hF8=dy;
   int yF9=yF8+hF8,hF9=dy;
   int yF10=yF9+hF9,hF10=dy;
   int yS4=yF10+hF10+3,hS4=ds;
   int yF11=yS4+hS4,hF11=dy;
   int yF12=yF11+hF11,hF12=dy;
   int yF13=yF12+hF12,hF13=dy;
   int yS5=yF13+hF13+3,hS5=ds;
   int yF14=yS5+hS5,hF14=dy;
   int yF15=yF14+hF14,hF15=dy;
   int yF16=yF15+hF15,hF16=dy;
   // ==== SAML ====
   int yS6=yF16+hF16+3,hS6=ds;
   int yF17=yS6+hS6,hF17=dy;
   int yF18=yF17+hF17,hF18=dy;
   int yF19=yF18+hF18,hF19=dy;
   int yPL=yF19+hF19+3,hPL=dy+4;

   Rectangulo("P_Fondo",x,y,W,PANEL_ALTO,FP,BRD);
   Rectangulo("P_Cab",x,yCab,W,hCab,FC,BRD);
   Rectangulo("P_FecBg",x,yFec,W,hFec,FF1,FF1);
   Rectangulo("P_S1Bg",x,yS1,W,hS1,FS,FS);
   Rectangulo("P_F1",x,yF1,W,hF1,FF1,FF1);
   Rectangulo("P_F2",x,yF2,W,hF2,FF2,FF2);
   Rectangulo("P_F3",x,yF3,W,hF3,FF1,FF1);
   Rectangulo("P_S2Bg",x,yS2,W,hS2,FS,FS);
   Rectangulo("P_F4",x,yF4,W,hF4,FF1,FF1);
   Rectangulo("P_F5",x,yF5,W,hF5,FF2,FF2);
   Rectangulo("P_F6",x,yF6,W,hF6,FF1,FF1);
   Rectangulo("P_F7",x,yF7,W,hF7,FF2,FF2);
   Rectangulo("P_S3Bg",x,yS3,W,hS3,C'25,65,110',C'25,65,110');
   Rectangulo("P_F8",x,yF8,W,hF8,FF1,FF1);
   Rectangulo("P_F9",x,yF9,W,hF9,FF2,FF2);
   Rectangulo("P_F10",x,yF10,W,hF10,FF1,FF1);
   Rectangulo("P_S4Bg",x,yS4,W,hS4,C'80,35,110',C'80,35,110');
   Rectangulo("P_F11",x,yF11,W,hF11,FF1,FF1);
   Rectangulo("P_F12",x,yF12,W,hF12,FF2,FF2);
   Rectangulo("P_F13",x,yF13,W,hF13,FF1,FF1);
   Rectangulo("P_S5Bg",x,yS5,W,hS5,C'110,42,42',C'110,42,42');
   Rectangulo("P_F14",x,yF14,W,hF14,FF1,FF1);
   Rectangulo("P_F15",x,yF15,W,hF15,FF2,FF2);
   Rectangulo("P_F16",x,yF16,W,hF16,FF1,FF1);
   Rectangulo("P_S6Bg",x,yS6,W,hS6,C'40,90,60',C'40,90,60');
   Rectangulo("P_F17",x,yF17,W,hF17,FF1,FF1);
   Rectangulo("P_F18",x,yF18,W,hF18,FF2,FF2);
   Rectangulo("P_F19",x,yF19,W,hF19,FF1,FF1);
   Rectangulo("P_PLBg",x,yPL,W,hPL,C'28,60,36',cEq);

   Etiqueta("P_Titulo",x+pX,yCab+7,"SAMU AI v8.5 — Neural + Genetic + SAML",FUENTE_TITULO,"Consolas",TBL);
   Etiqueta("P_Modo",x+cE,yCab+7,(ModoCripto?"CRIPTO":"FOREX"),FUENTE_TITULO,"Consolas",(ModoCripto?TAM:TAZ));

   Etiqueta("P_Fecha",x+pX,yFec+pY,
            NombreDia+"  "+TimeToString(TimeCurrent(),TIME_DATE|TIME_SECONDS),
            FUENTE_TAM,"Consolas",TGR);

   // Cuenta
   Etiqueta("P_S1",x+pX,yS1+6,"CUENTA",FUENTE_TAM,"Consolas",TAZ);
   Etiqueta("P_L1",x+cL,yF1+pY,"Balance",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V1",x+cV,yF1+pY,"$ "+DoubleToString(AccountBalance(),2),FUENTE_TAM,"Consolas",cBal);
   Etiqueta("P_L2",x+cL,yF2+pY,"Equity",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V2",x+cV,yF2+pY,"$ "+DoubleToString(AccountEquity(),2),FUENTE_TAM,"Consolas",cEq);
   Etiqueta("P_L3",x+cL,yF3+pY,"Drawdown / Nivel CB",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V3",x+cV,yF3+pY,
            DoubleToString(dd,2)+" % / N"+IntegerToString(g_NivelDD),
            FUENTE_TAM,"Consolas",cDD);

   // Red Neuronal
   Etiqueta("P_S2",x+pX,yS2+6,"RED NEURONAL "+IntegerToString(NN_INPUTS)+"-"+IntegerToString(NN_HIDDEN)+"-"+IntegerToString(NN_OUTPUTS),
            FUENTE_TAM,"Consolas",TAZ);
   Etiqueta("P_L4",x+cL,yF4+pY,"Estado entrenamiento",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V4",x+cV,yF4+pY,g_estadoIA,FUENTE_TAM,"Consolas",TBL);
   Etiqueta("P_L5",x+cL,yF5+pY,"Peso NN / Ensemble",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V5",x+cV,yF5+pY,
            DoubleToString(g_pesoNN*100,0)+"% / "+DoubleToString(g_pesoEns*100,0)+"%",
            FUENTE_TAM,"Consolas",TAM);
   Etiqueta("P_L6",x+cL,yF6+pY,"Pred NN / Voto Ens",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V6",x+cV,yF6+pY,
            DoubleToString(UlimoPredNN,3)+" / "+DoubleToString(UltimoVotoEns,3),
            FUENTE_TAM,"Consolas",TBL);
   Etiqueta("P_L7",x+cL,yF7+pY,"Score final",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V7",x+cV,yF7+pY,
            DoubleToString(UltimoScore,3)+"  (umbral "+(ModoCripto?"0.25":"0.30")+")",
            FUENTE_TAM,"Consolas",(MathAbs(UltimoScore)>0.3?TAM:TGR));

   // Pool Genético
   Etiqueta("P_S3",x+pX,yS3+6,"POOL GENÉTICO",FUENTE_TAM,"Consolas",TAZ);
   double fitMax=-10, fitProm=0;
   for(int s=0;s<TamanoPoolEstrategias;s++)
     {
      if(g_Fitness[s]>fitMax) fitMax=g_Fitness[s];
      fitProm += g_Fitness[s];
     }
   fitProm /= TamanoPoolEstrategias;
   Etiqueta("P_L8",x+cL,yF8+pY,"Generación / Replays",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V8",x+cV,yF8+pY,
            IntegerToString(g_Generacion)+" / "+IntegerToString(g_exp_entrenamientos),
            FUENTE_TAM,"Consolas",TBL);
   Etiqueta("P_L9",x+cL,yF9+pY,"Fitness max / prom",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V9",x+cV,yF9+pY,
            DoubleToString(fitMax,3)+" / "+DoubleToString(fitProm,3),
            FUENTE_TAM,"Consolas",TBL);
   Etiqueta("P_L10",x+cL,yF10+pY,"Trades hasta evol.",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V10",x+cV,yF10+pY,
            IntegerToString(g_tradesDesdeEvolucion)+" / "+IntegerToString(FrecuenciaEvolucion),
            FUENTE_TAM,"Consolas",TBL);

   // Memoria
   Etiqueta("P_S4",x+pX,yS4+6,"MEMORIA PERSISTENTE",FUENTE_TAM,"Consolas",TVIO);
   Etiqueta("P_L11",x+cL,yF11+pY,"Buffer experiencia",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V11",x+cV,yF11+pY,
            IntegerToString(g_exp_count)+" / "+IntegerToString(MaxExperiencia),
            FUENTE_TAM,"Consolas",TBL);
   Etiqueta("P_L12",x+cL,yF12+pY,"Trades globales",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V12",x+cV,yF12+pY,
            IntegerToString(g_totalTrades)+" (W:"+IntegerToString(g_totalWins)+" L:"+IntegerToString(g_totalLosses)+")",
            FUENTE_TAM,"Consolas",TBL);
   Etiqueta("P_L13",x+cL,yF13+pY,"PnL histórico / MaxDD",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V13",x+cV,yF13+pY,
            "$ "+DoubleToString(g_totalPnL,2)+" / "+DoubleToString(g_maxDDHist,2)+"%",
            FUENTE_TAM,"Consolas",(g_totalPnL>=0?TVE:TRO));

   // Operaciones
   Etiqueta("P_S5",x+pX,yS5+6,"OPERACIONES ABIERTAS",FUENTE_TAM,"Consolas",TRO);
   Etiqueta("P_L14",x+cL,yF14+pY,"Compras / Ventas",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V14",x+cV,yF14+pY,
            IntegerToString(OrdenesCompra)+" / "+IntegerToString(OrdenesVenta),
            FUENTE_TAM,"Consolas",TBL);
   Etiqueta("P_L15",x+cL,yF15+pY,"P/L flotante",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V15",x+cV,yF15+pY,
            "$ "+DoubleToString(ProfitCompra+ProfitVenta,2),
            FUENTE_TAM,"Consolas",((ProfitCompra+ProfitVenta)>=0?TVE:TRO));
   int idxSym = BuscarIndiceSimbolo(Symbol());
   double wr = 0;
   if(idxSym>=0 && g_trades[idxSym]>0)
      wr = (double)g_wins[idxSym]/g_trades[idxSym]*100;
   Etiqueta("P_L16",x+cL,yF16+pY,"WinRate "+Symbol(),FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V16",x+cV,yF16+pY,
            DoubleToString(wr,1)+"%  ("+IntegerToString((idxSym>=0?g_trades[idxSym]:0))+" trades)",
            FUENTE_TAM,"Consolas",(wr>=50?TVE:TRO));

   // ==== SAML ====
   Etiqueta("P_S6",x+pX,yS6+6,"SAML ENGINE (auto-optimización)",FUENTE_TAM,"Consolas",TVE);
   Etiqueta("P_L17",x+cL,yF17+pY,"Reglas / Generación",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V17",x+cV,yF17+pY,
            IntegerToString(g_SSRuleCount)+" / "+IntegerToString(g_SSGeneration),
            FUENTE_TAM,"Consolas",TBL);
   Etiqueta("P_L18",x+cL,yF18+pY,"Boost SAML aplicado",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V18",x+cV,yF18+pY,
            (g_SSUltBoost>=0?"+":"")+DoubleToString(g_SSUltBoost,3)+
            "  Lot×"+DoubleToString(g_SSUltLotMult,2),
            FUENTE_TAM,"Consolas",(MathAbs(g_SSUltBoost)>0.05?TAM:TGR));
   Etiqueta("P_L19",x+cL,yF19+pY,"Reglas activas este tick",FUENTE_TAM,"Consolas",TGR);
   Etiqueta("P_V19",x+cV,yF19+pY,
            IntegerToString(g_SSUltFired)+(g_SSUltBlocked?"  [BLOCKED]":""),
            FUENTE_TAM,"Consolas",(g_SSUltBlocked?TRO:TBL));

   Etiqueta("P_PLL",x+cL,yPL+pY+2,"P/L TOTAL",FUENTE_TAM,"Consolas",cEq);
   Etiqueta("P_PLV",x+cV,yPL+pY+2,
            "$ "+DoubleToString(ProfitCompra+ProfitVenta,2),
            FUENTE_TAM,"Consolas",cEq);

   ChartRedraw();
  }
//+------------------------------------------------------------------+