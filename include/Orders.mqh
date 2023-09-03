//+------------------------------------------------------------------+
//|                                                       Orders.mqh |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <Trade\Trade.mqh>

class Orders
{
private:

public:
      Orders();
     ~Orders();
     
     bool buy(double num_lots, double stop_loss, double tp){
         CTrade *trade=new CTrade();
         trade.Buy(num_lots, _Symbol, 0, stop_loss, tp);
         return true;
     }
     
     bool sell(double num_lots, double stop_loss, double tp){
         CTrade *trade=new CTrade();
         trade.Sell(num_lots, _Symbol,0 , stop_loss, tp);
         return true;
     }
     
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Orders::Orders()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Orders::~Orders()
{
}
//+------------------------------------------------------------------+
