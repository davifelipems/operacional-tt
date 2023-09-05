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
     
     bool closeAllOperations(){
         cancelPendingOrders();
         CTrade trade;
         int i=PositionsTotal()-1;
         while (i>=0)
           {
            if (trade.PositionClose(PositionGetSymbol(i))) i--;
           }
         return true;   
     }
     
     void cancelPendingOrders() {
         for(int i = OrdersTotal() - 1; i >= 0; i--) {
             if(OrderGetTicket(i) > 0
             && OrderGetString(ORDER_SYMBOL) == _Symbol) {
                    ulong ticket=OrderGetTicket(i);
                    CTrade *trade=new CTrade();
                    trade.OrderDelete(ticket);
                    delete trade;
             }
         }
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
