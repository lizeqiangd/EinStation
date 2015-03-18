package com.lizeqiangd.nuigesture
{

	public class NuiSettings
	{//speed
		public static const GestureSpeedByWorld:Number = 1.2;
		public static const GestureSpeedByWorldUp:Number = 1.2;
		public static const GestureSpeedByWorldDown:Number = 1.2;
		public static const GestureSpeedByWorldLeft:Number = 1.2;
		public static const GestureSpeedByWorldRight:Number = 1.2;
		public static const GestureSpeedByRgb:Number = 0.28;
		public static const ControlTapSpeed:Number = 0.55;
		public static const ReviseSpeed:Number = 0.2;
		//length
		public static const ActionArrayLength:uint = 3;
		//timer
		public static const ActionCatchTime:uint = 150;
		public static const ActionInterval:uint = 800;
		public static const ActionAnalysisDetalTime:uint = 300;
		//zone
		public static const ZoneOutOfRange:int=-600
		public static const ZoneIgnoreLimit:int = 100;
		public static const ZoneGestureLimit:int = 802;
		public static const ZoneControlLimit:int = 803;
		public static const ZoneSelectionLimit:int = 804;
		//public static var ControlSpeed:Number = 30;
		//public static var StopSpeed:Number = 30;

	}

}