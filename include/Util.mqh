//+------------------------------------------------------------------+
//|                                                         Util.mqh |
//|                                  Copyright 2021, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"

datetime newCandleTime = TimeCurrent();

class Util
{
private:

public:
      Util();
     ~Util();
     
    bool newBar(){
      if(newCandleTime == iTime(Symbol(), 0, 0))
         return false;
      else
        {
         newCandleTime = iTime(Symbol(), 0, 0);
         return true;
        }
    }
    
    bool arrowedLineDelete(const long   chart_ID=0,         
                             const string name="ArrowedLine"){
            ResetLastError();
            if(!ObjectDelete(chart_ID,name))
              {
               Print(__FUNCTION__,
                     ": error! code = ",GetLastError());
               return(false);
              }
            return(true);
    }
    
    bool arrowedLineCreate(const long            chart_ID=0,           
                             const string          name="ArrowedLine",
                             const int             sub_window=0,       
                             datetime              time1=0,            
                             double                price1=0,           
                             datetime              time2=0,            
                             double                price2=0,           
                             const color           clr=clrRed,         
                             const ENUM_LINE_STYLE style=STYLE_SOLID,  
                             const int             width=1,           
                             const bool            back=false,         
                             const bool            selection=true,     
                             const bool            hidden=true,        
                             const long            z_order=0)         
        {
         arrowedLineDelete(chart_ID,name);
         ResetLastError();
         if(!ObjectCreate(chart_ID,name,OBJ_ARROWED_LINE,sub_window,time1,price1,time2,price2))
           {
            Print(__FUNCTION__,
                  ": error! code = ",GetLastError());
            return(false);
           }
         ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
         ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
         ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
         ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
         ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
         ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
         ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
         ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
         
         return(true);
        }
       
       void changeTextEmptyPoint(datetime &time,double &price){ 
            //--- if the point's time is not set, it will be on the current bar 
            if(!time) 
               time=TimeCurrent(); 
            //--- if the point's price is not set, it will have Bid value 
            if(!price) 
               price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
      } 
        
       bool textCreate(const long              chart_ID=0,               // chart's ID 
                      const string            name="Text",              // object name 
                      const int               sub_window=0,             // subwindow index 
                      datetime                time=0,                   // anchor point time 
                      double                  price=0,                  // anchor point price 
                      const string            text="Text",              // the text itself 
                      const string            font="Arial",             // font 
                      const int               font_size=10,             // font size 
                      const color             clr=clrRed,               // color 
                      const double            angle=0.0,                // text slope 
                      const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type 
                      const bool              back=false,               // in the background 
                      const bool              selection=false,          // highlight to move 
                      const bool              hidden=true,              // hidden in the object list 
                      const long              z_order=0)                // priority for mouse click 
        { 
               //--- set anchor point coordinates if they are not set 
                  changeTextEmptyPoint(time,price); 
               //--- reset the error value 
                  ResetLastError(); 
               //--- create Text object 
                  if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price)) 
                    { 
                     Print(__FUNCTION__, 
                           ": failed to create \"Text\" object! Error code = ",GetLastError()); 
                     return(false); 
                    } 
               //--- set the text 
                  ObjectSetString(chart_ID,name,OBJPROP_TEXT,text); 
               //--- set text font 
                  ObjectSetString(chart_ID,name,OBJPROP_FONT,font); 
               //--- set font size 
                  ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size); 
               //--- set the slope angle of the text 
                  ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle); 
               //--- set anchor type 
                  ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor); 
               //--- set color 
                  ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr); 
               //--- display in the foreground (false) or background (true) 
                  ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back); 
               //--- enable (true) or disable (false) the mode of moving the object by mouse 
                  ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection); 
                  ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection); 
               //--- hide (true) or display (false) graphical object name in the object list 
                  ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden); 
               //--- set the priority for receiving the event of a mouse click in the chart 
                  ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order); 
               //--- successful execution 
                  return(true); 
      }  
      
      void drawHorizontalLine(string name,datetime dt,double price,color cor=clrBlueViolet){
         ObjectDelete(0,name);
         ObjectCreate(0,name,OBJ_HLINE,0,dt,price);
         ObjectSetInteger(0,name,OBJPROP_COLOR,cor);
      }
      
      double getCandleBodySize(MqlRates &candles[],int i_candle){
         double bodySize = (candles[i_candle].close - candles[i_candle].open);
         return (bodySize < 0 ? (bodySize*-1) : bodySize);
      }
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Util::Util()
{
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Util::~Util()
{
}
//+------------------------------------------------------------------+
