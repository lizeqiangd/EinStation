package com.lizeqiangd.nuigesture.core
{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import com.lizeqiangd.nuigesture.data.action.GestureAction;
	import com.lizeqiangd.nuigesture.event.GestureEvent;
	
	/*
	 * NuiGesture的事件主调度者.同时也是全NuiGesture的EventDispatch拥有者
	 * update@20140309  将所有内容从静态删除
	 */
	public class NuiEventDispatcher
	{
		
		private var EventIntervalTimer:Timer;
		private var CoolDown:Boolean = false;
		private var eventDispatch:EventDispatcher
		private var inited:Boolean = false
		
		/*
		 * 初始化事件主调度的初始化
		 * 进入事件CD
		 * 建立EventDispatcher
		 * 建立CD的timer侦听器
		 */
		public function NuiEventDispatcher() {
			eventDispatch = new EventDispatcher
		}
		public function init()
		{
			if (inited)
			{inited=true 
				CoolDown = true;
		
				//eventDispatch = NuiGesture.eventDispatch;
				EventIntervalTimer = new Timer(NuiSettings.ActionInterval, 1);
				EventIntervalTimer.addEventListener(TimerEvent.TIMER_COMPLETE, TimerHandle);
			}
			else
			{
				trace("Nuigesture.NuiEventDispatcher:already inited.")
			}
		}
		
		/*
		 * 让主调度者进入冷却
		 */
		public function CoolingDown()
		{
			EventIntervalTimer.start();
			CoolDown = false;
		}
		
		
		 /*
		 *发布一个手势动作.如果进入CD则反馈事件
		 * e:GestureAction 手势动作
		 */
		public function dispatchGuestEvent(e:GestureAction)
		{
			//eventDispatch.dispatchEvent(new GestureEvent (GestureEvent.GESTURE,e));
			if (CoolDown)
			{
				CoolDown = false;
				eventDispatch.dispatchEvent(new GestureEvent(GestureEvent.GESTURE, e));
				EventIntervalTimer.start();
					//trace("NuiEventHandle:EventDispatched,coolingdown");
			}
		}
		/*
		 *  发布一个控制动作.
		 * (完全没有开发)
		 */
		public function dispatchControlEvent()
		{
			return
			if (CoolDown)
			{
				//eventDispatch.dispatchEvent();
				CoolDown = false;
				EventIntervalTimer.start();
			}
		}
		/*
		 * 销毁本类并清除本类侦听器,并让cd进入没CD状态,同时刷新初始化状态
		 */
		public function dispose()
		{
			EventIntervalTimer.stop();
			EventIntervalTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, TimerHandle);
			CoolDown = false;
			inited=false
		}
		/*
		 * 获取侦听器
		 */
		public  function get eventDispatcher():EventDispatcher
		{
			return  this.eventDispatch
		}
	
	}

}