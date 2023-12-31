//+------------------------------------------------------------------+
//|                                                OperacionalTT.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <../Experts/operacional-tt/include/OperacionalTT.mqh>

OperacionalTT robo;

//--- input parameters
input int      period_true_range=500; // Period Range
input double   tick_value = 5;        // Tick value
input double   num_lots   = 1;        // Num. Lots
input datetime start_time  = D' 09:20'; // Start time
input datetime deadline   = D' 17:30'; // Deadline 
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
    robo.period_true_range = period_true_range;
    robo.tick_value = tick_value;
    robo.num_lots = num_lots;
    robo.deadline = deadline;
    robo.start_time = start_time;
    robo.init();  
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
    robo.tickEvent();  
  }
//+------------------------------------------------------------------+
