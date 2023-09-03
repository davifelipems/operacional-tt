//+------------------------------------------------------------------+
//|                                                OperacionalTT.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <../experts/operacional-tt/include/Util.mqh>

Util util;

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
     
     bool temos_nova_vela;
     
     void init(){
         
     }
     
     void tickEvent(){
         CopyRates(_Symbol,_Period,0,period_true_range,candles);
         ArraySetAsSeries(candles,true);
         SymbolInfoTick(_Symbol,tick);
         temos_nova_vela = util.newBar();
         
         calculateTrueRangeAvg();
         st1();
     }
     
     int getSequenceHigh(int qtdCandles){
       int sequenceHigh = 0;
        for(int i = 1; i <=qtdCandles; i++){
           int nextCandle = i+1;
           
           if(candles[i].high > candles[nextCandle].high
           && candles[i].low > candles[nextCandle].low
           ){
                sequenceHigh++;
           }
        }
        return sequenceHigh;
     }
     
     int getSequenceLow(int qtdCandles){
        int sequenceLow = 0;
        for(int i = 1; i <=qtdCandles; i++){
           int nextCandle = i+1;
           
           if(candles[i].high < candles[nextCandle].high
           && candles[i].low < candles[nextCandle].low
           ){
                sequenceLow++;
           }
        }
        
        return sequenceLow;
     }
     
     bool st1(){
        
        if(temos_nova_vela == false){
            return false;
         }
       
        int sequenceHigh = getSequenceHigh(5);
        int sequenceLow = getSequenceLow(5);
        
        if(sequenceHigh == 5){
            util.arrowedLineCreate(0,"ST1 de alta",0,
                           candles[5].time,candles[5].high,
                           candles[1].time,candles[1].low,
                           clrAntiqueWhite,STYLE_DOT,1,false,false);
            util.textCreate(0,"ST1 de alta-descricao",0,candles[3].time,candles[3].high,
            "ST1 de alta"
            ,"Arial",8,clrAntiqueWhite,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);            
        }
        
        if(sequenceLow == 5){
            util.arrowedLineCreate(0,"ST1 de baixa",0,
                           candles[5].time,candles[5].high,
                           candles[1].time,candles[1].low,
                           clrAntiqueWhite,STYLE_DOT,1,false,false);
            util.textCreate(0,"ST1 de baixa-descricao",0,candles[3].time,candles[3].high,
            "ST1 de baixa"
            ,"Arial",8,clrAntiqueWhite,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);                
        }
          
        return true;
     }
     
     
     bool calculateTrueRangeAvg(){
     
         if(temos_nova_vela == false){
            return false;
         }
         
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
         return true;        
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
