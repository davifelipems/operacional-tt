//+------------------------------------------------------------------+
//|                                                OperacionalTT.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <../experts/operacional-tt/include/Util.mqh>
#include <../experts/operacional-tt/include/Orders.mqh>

Util util;
Orders orders;

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
     double tick_value;
     double entryPointSt1Buy;
     double entryPointSt1Sell;
     bool new_bar;
     double num_lots;
     datetime deadline;
     datetime start_time;
     
     void init(){
         
     }
     
     void tickEvent(){
         CopyRates(_Symbol,_Period,0,period_true_range,candles);
         ArraySetAsSeries(candles,true);
         SymbolInfoTick(_Symbol,tick);
         new_bar = util.newBar();
         
         closeOperationsForTheDay();
         calculateTrueRangeAvg();
         st1();
         sendOrder();
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
     
     bool sendOrder(){
         
        if(overdue()){
           return false;
        }
        
        if(beforeTime()){
           return false;
        }
        
        if(PositionsTotal() > 0 ){
            entryPointSt1Sell = 0;
            entryPointSt1Buy = 0;
            ObjectDelete(0, "sell here");
            ObjectDelete(0, "buy here");
            return false;
         }
        
        if(entryPointSt1Sell == 0 && entryPointSt1Buy == 0){
            return false;
        }
        
        
        if(entryPointSt1Sell > 0 && tick.last > entryPointSt1Sell){
            double stop_loss_price = tick.last + (exponential_true_range_avg * 1.5);//Stop 1.5 TR
            double tp_price = tick.last - exponential_true_range_avg;               // TP 1 TR
            orders.sell(num_lots, stop_loss_price,tp_price);
             util.textCreate(0,"Sell ST1",0,candles[1].time,candles[1].low,
            "Venda de ST1 TR "+DoubleToString(exponential_true_range_avg, 2)
            ,"Arial",8,clrAntiqueWhite,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);
        }
        
        if(entryPointSt1Buy > 0 && tick.last < entryPointSt1Buy){
            double stop_loss_price = tick.last - (exponential_true_range_avg * 1.5); //Stop 1.5 TR
            double tp_price = tick.last + exponential_true_range_avg;                // TP 1 TR
            orders.buy(num_lots, stop_loss_price,tp_price);
            util.textCreate(0,"Buy ST1",0,candles[1].time,candles[1].low,
            "Compra de ST1 TR "+DoubleToString(exponential_true_range_avg, 2)
            ,"Arial",8,clrAntiqueWhite,0.0,ANCHOR_LEFT_UPPER,false,false,true,0);
        }
        
        return true;
     }
     
     bool st1(){
        
        if(new_bar == false){
            return false;
        }
        
        if(overdue()){
           return false;
        }
        
        if(beforeTime()){
           return false;
        }
       
        int sequenceHigh = getSequenceHigh(5);
        int sequenceLow = getSequenceLow(5);
        
        if(sequenceHigh == 5){
            util.arrowedLineCreate(0,"ST1 de alta",0,
                           candles[5].time,candles[5].low,
                           candles[1].time,candles[1].low,
                           clrAntiqueWhite,STYLE_DOT,1,false,false);
            util.textCreate(0,"ST1 de alta-description",0,candles[3].time,candles[3].low,
            "ST1 de alta"
            ,"Arial",8,clrAntiqueWhite);
            entryPointSt1Buy = candles[1].close - (tick_value * 4); // 4ticks
            
            util.drawHorizontalLine("buy here",candles[1].time,entryPointSt1Buy,clrCadetBlue);            
        }
        
        if(sequenceLow == 5){
            util.arrowedLineCreate(0,"ST1 de baixa",0,
                           candles[5].time,candles[5].high,
                           candles[1].time,candles[1].low,
                           clrAntiqueWhite,STYLE_DOT,1,false,false);
            util.textCreate(0,"ST1 de baixa-description",0,candles[3].time,candles[3].high,
            "ST1 de baixa"
            ,"Arial",8,clrAntiqueWhite); 
            entryPointSt1Sell = candles[1].close + (tick_value * 4); // 4ticks
            util.drawHorizontalLine("sell here",candles[1].time,entryPointSt1Sell,clrCrimson);                
        }
          
        return true;
     }
     
     
     bool calculateTrueRangeAvg(){
     
         if(new_bar == false){
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
     
     bool overdue(){
         datetime now =  TimeCurrent();	
         MqlDateTime now_struct;	
         TimeToStruct(now, now_struct);	
         	
         MqlDateTime deadline_struct;	
         TimeToStruct(deadline, deadline_struct);	
         
         if(now_struct.hour > deadline_struct.hour){
            return true;
         }	
         	
         if(now_struct.hour == deadline_struct.hour && now_struct.min >= deadline_struct.min){
            return true;	
         }
         
         return false;	
      }
      
      bool beforeTime(){
         datetime now =  TimeCurrent();	
         MqlDateTime now_struct;	
         TimeToStruct(now, now_struct);	
         	
         MqlDateTime start_time_struct;	
         TimeToStruct(start_time, start_time_struct);	
         
         if(now_struct.hour < start_time_struct.hour){
            return true;
         }	
         	
         if(now_struct.hour == start_time_struct.hour && now_struct.min <= start_time_struct.min){
            return true;	
         }
         
         return false;	
      }
      
      bool closeOperationsForTheDay(){
         if(PositionsTotal() == 0){
            return false;
         }
         
         MqlDateTime deadline_struct;
         TimeToStruct(deadline, deadline_struct);
         
         if(overdue()){
            orders.closeAllOperations();
            util.textCreate(0,"cancel-orders",0,candles[1].time,candles[1].high,
            "Zera tudo depois de "+deadline_struct.hour+":"+deadline_struct.min
            ,"Arial",8,clrAntiqueWhite);
         }
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
