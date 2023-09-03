//+------------------------------------------------------------------+
//|                                                OperacionalTT.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"
class OperacionalTT
  {
private:

public:
      OperacionalTT();
     ~OperacionalTT();
     
     void init(){
         Print("init!");
     }
     
     void tick(){
         Print("Tick!");
     }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OperacionalTT::OperacionalTT()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OperacionalTT::~OperacionalTT()
  {
  }
//+------------------------------------------------------------------+
