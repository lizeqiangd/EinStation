package com.lizeqiangd.nuigesture.core
{
	import com.lizeqiangd.nuigesture.manager.ZoneManager;
	import com.lizeqiangd.nuigesture.data.action.GestureAction;
	import com.lizeqiangd.nuigesture.NuiGesture;
	import com.lizeqiangd.nuigesture.NuiSettings;
	
	/*
	 * NuiGesture主分析类.用于将得到计算数据归类然后交给事件调度者发布
	 */
	public class ActionAnalysis
	{
		private var NED:NuiEventDispatcher
		private var ZM:ZoneManager
		private var detalTime:uint
		private var judgeSpeed:Number
		private var tapSpeed:Number
		private var wrongCode:int = 0
		private var inited:Boolean = false
		
		/*
		 * 初始化ActionAnalysis,需要主类提供NuiEventDispatcher
		 */
		public function init(ned:NuiEventDispatcher, zm:ZoneManager)
		{
			if (inited)
			{
				inited = true
				NED = ned
				ZM = zm
				detalTime = NuiSettings.ActionAnalysisDetalTime;
				judgeSpeed = NuiSettings.GestureSpeedByRgb;
				tapSpeed = NuiSettings.ControlTapSpeed
			}
			else
			{
				trace("NuiGesture.ActionAnalysis:already inited.")
				return
			}
		}
		
		/*
		 * 主要动作,分析动作.
		 * e:ActionArray 需要提交ActionArray
		 * 目前原理是通过计算第三个动作和第一个动作之间的位移差得出用户的动作.非常简单.
		 * 同时分析用户手所在的区域得出用户具体在进行什么动作.
		 */
		public function analysis(e:ActionArray)
		{
			//detalTime = NuiSettings.ActionCatchTime * NuiSettings.ActionAnalysisDetalTime
			//Special
			if (true)
			{
			}
			
			//trace("["+e._ActionArrayNodeName+"]["+ZoneManager.searchInZone(e.z)+"]:"+e.z);
			switch (ZoneManager.searchInZone(e.z))
			{
				case ZM.ignoreZone: 
					trace("NuiGesture.ActionAnalysis:ignoreZone[not handle]");
					break;
				case ZM.gestureZone: 
					//var dx:Number =(e.getActionPoint (3).worldX - e.getActionPoint (1).worldX) / detalTime//
					//var dy:Number =(e.getActionPoint (3).worldY - e.getActionPoint (1).worldY) / detalTime//
					var dx:Number = (e.getActionPoint(3).rgbX - e.getActionPoint(1).rgbX) / detalTime; //
					var dy:Number = -(e.getActionPoint(3).rgbY - e.getActionPoint(1).rgbY) / detalTime; //
					var daz:Number = -(e.getActionPoint(3).az - e.getActionPoint(1).az) / detalTime; //
					var ga:GestureAction;
					
					/*
					   dx=+NuiSettings.ReviseSpeed;
					   dy=+NuiSettings.ReviseSpeed;
					   if (dx<0)
					   {
					   dx-=NuiSettings.ReviseSpeed;
					   }
					   if (dy<0)
					   {
					   dy -=  NuiSettings.ReviseSpeed;
					   }
					 */
					
					if (dx > judgeSpeed)
					{
						if (dx > (judgeSpeed * 2))
						{
							//	trace("dx:" + dx.toFixed(3) + " dy:" + dy.toFixed(3) + " daz:" + daz.toFixed(3))
							//	trace("***:      " + (++wrongCode))
							ga = new GestureAction(e._ActionArrayNodeName, dx, "right", 1);
							dispatchGuestureEvent(ga)
							return
						}
						//trace("dx:" + dx.toFixed(3) + " dy:" + dy.toFixed(3) + " daz:" + daz.toFixed(3))
						//trace("***:      " + (++wrongCode))
						ga = new GestureAction(e._ActionArrayNodeName, dx, "right", 0);
						dispatchGuestureEvent(ga)
						return
					}
					if (dx < (-judgeSpeed))
					{
						if (dx < (-judgeSpeed * 2))
						{
							//	trace("dx:" + dx.toFixed(3) + " dy:" + dy.toFixed(3) + " daz:" + daz.toFixed(3))
							//	trace("***:      " + (++wrongCode))
							ga = new GestureAction(e._ActionArrayNodeName, -dx, "left", 1);
							dispatchGuestureEvent(ga)
							return
						}
						//trace("dx:" + dx.toFixed(3) + " dy:" + dy.toFixed(3) + " daz:" + daz.toFixed(3))
						//	trace("***:      " + (++wrongCode))
						ga = new GestureAction(e._ActionArrayNodeName, -dx, "left", 0);
						dispatchGuestureEvent(ga)
						return
						
					}
					if (dy > judgeSpeed)
					{
						if (dy > (judgeSpeed * 2))
						{
							//	trace("dx:" + dx.toFixed(3) + " dy:" + dy.toFixed(3) + " daz:" + daz.toFixed(3))
							//	trace("***:      " + (++wrongCode))
							ga = new GestureAction(e._ActionArrayNodeName, dy, "up", 1);
							dispatchGuestureEvent(ga)
							return
						}
						//	trace("dx:" + dx.toFixed(3) + " dy:" + dy.toFixed(3) + " daz:" + daz.toFixed(3))
						//	trace("***:      " + (++wrongCode))
						ga = new GestureAction(e._ActionArrayNodeName, dy, "up", 0);
						dispatchGuestureEvent(ga)
						return
					}
					if (dy < (-judgeSpeed))
					{
						if (dy < (-judgeSpeed * 2))
						{
							//	trace("dx:" + dx.toFixed(3) + " dy:" + dy.toFixed(3) + " daz:" + daz.toFixed(3))
							//	trace("***:      " + (++wrongCode))
							ga = new GestureAction(e._ActionArrayNodeName, -dy, "down", 1);
							dispatchGuestureEvent(ga)
							return
						}
						//	trace("dx:" + dx.toFixed(3) + " dy:" + dy.toFixed(3) + " daz:" + daz.toFixed(3))
						//trace("***:      " + (++wrongCode))
						ga = new GestureAction(e._ActionArrayNodeName, -dy, "down", 0);
						dispatchGuestureEvent(ga)
						return
						
					}
					if (daz < -tapSpeed)
					{
						//	trace("dx:" + dx.toFixed(3) + " dy:" + dy.toFixed(3) + " daz:" + daz.toFixed(3))
						//	trace("***:      " + (++wrongCode))
						ga = new GestureAction(e._ActionArrayNodeName, daz, "in", 0);
						dispatchGuestureEvent(ga)
						return
					}
					
					break;
				case ZM.controlZone: 
					/*var daz:Number =(e.getActionPoint (2).worldZ- e.getActionPoint (1).worldZ)-(e.getActionPoint (3).worldZ- e.getActionPoint (2).worldZ);
					   var reviseDaz:Number =daz/detalTime
					   trace(reviseDaz);
					   if(reviseDaz >tapSpeed){
					   trace("点击了");
					 }*/
					break;
				case ZM.selectionZone: 
					break;
				default: 
					break;
			}
		}
		
		/*
		 *调度手势动作
		 */
		private function dispatchGuestureEvent(ga:GestureAction)
		{
			NED.dispatchGuestEvent(ga);
		}
		
		/*
		 * 销毁本类
		 */
		public function dispose()
		{
			inited = false
		}
	}
}