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
     
     int period_true_range;
     MqlRates candles[];
     MqlTick  tick;
     double exponential_true_range_avg;
     double simple_true_range_avg;
     
     void init(){
         
     }
     
     void tickEvent(){
         CopyRates(_Symbol,_Period,0,period_true_range,candles);
         ArraySetAsSeries(candles,true);
         SymbolInfoTick(_Symbol,tick);
         
         calculateTrueRangeAvg();
     }
     
     void calculateTrueRangeAvg(){
         double simple_avg = 0;
         double total_true_range;
         for(int i =0; i < ArraySize(candles); i++){
            double candle_size = candles[i].high - candles[i].low;
            total_true_range += MathAbs(candle_size);
         }
         
         simple_true_range_avg = total_true_range / period_true_range;
         double period_true_range_double = period_true_range;
         double weigth =  2.0 / (1.0 +period_true_range_double);
         
         double current_true_range_size = candles[1].high - candles[1].low;
         double current_true_range = MathAbs(current_true_range_size);
         
         exponential_true_range_avg = ((current_true_range - simple_true_range_avg) * weigth) + simple_true_range_avg;
         
         Comment("Simple true range avg "+StringFormat("%.5f",simple_true_range_avg)+"\n"+
                 "Exponential true range avg "+StringFormat("%.5f",exponential_true_range_avg));
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
