//+------------------------------------------------------------------+
//|                                                  ATR_Channel.mq4 |
//|                                  Copyright 2024, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2024, Weyinmi"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window

//
//Indicator properties
//
#property indicator_buffers 3

// Main line properties
#property indicator_color1 clrGreen
#property indicator_label1 "Main"
#property indicator_style1 STYLE_SOLID
#property indicator_type1 DRAW_LINE
#property indicator_width1 3 // wider for the video

// Upper line Properties
#property indicator_color1 clrWhite
#property indicator_label1 "Upper"
#property indicator_style1 STYLE_DOT
#property indicator_type1 DRAW_LINE
#property indicator_width1 1 // 

// Lower line Properties
#property indicator_color1 clrYellow
#property indicator_label1 "Lower"
#property indicator_style1 STYLE_DOT
#property indicator_type1 DRAW_LINE
#property indicator_width1 1 // 

//
// Inputs
//
//Moving Average
input int InpMABars = 10;                                 //Moving average bars
input ENUM_MA_METHOD InpMAMethod = MODE_SMA;              //Moving average method
input ENUM_APPLIED_PRICE InpMAAppliedPrice = PRICE_CLOSE; // Moving average applied price

//ATR 
input int InpATRBars = 10; // ATR Bars
input double InpATRFactor = 3.0; // ATR channel factor

//
// Indicator data buffers
//
double BufferMain[];
double BufferUpper[];
double BufferLower[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
      SetIndexBuffer(MODE_MAIN, BufferMain);
      SetIndexBuffer(MODE_UPPER, BufferUpper);
      SetIndexBuffer(MODE_LOWER, BufferLower);
      return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
      // How many bars to calculate
      int count = rates_total - prev_calculated; // no of bars - no already calculated
      if ( prev_calculated > 0 ) count++;
      
      // count down = from left to right, not essential for this
      // but for some indicators each value depends on values before
      for( int i = count - 1; i >= 0; i-- )
      {
         BufferMain[i] = iMA( Symbol(), Period(), InpMABars, 0, InpMAMethod, InpMAAppliedPrice, i);
         double channelWidth = InpATRFactor * iATR(Symbol(), Period(), InpATRBars, i);
         BufferUpper[i] = BufferMain[i] + channelWidth;
         BufferLower[i] = BufferMain[i] - channelWidth;
      
      }
      
      
      return(rates_total);
  }
//+------------------------------------------------------------------+
