package com.zweisystem.applications.SinaWeibo.FullScreenGesture
{

	import flash.display.MovieClip;
	import com.zweisystem.events.UnitEvent;
	import flash.events.MouseEvent;
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;
	import com.zweisystem.managers.ApplicationManager;
	import com.nuigesture.event.GestureEvent;
	import com.sina.microblog.events.MicroBlogEvent;
	import com.nuigesture.NuiGesture;

	public class GestureDisplayStateControlPanel extends MovieClip
	{

		private var mc_fsg:FullScreenGesture;
		private var nowCount:int = -1;

		public function GestureDisplayStateControlPanel()
		{
			addUiListener();
			btn1.title = "刷新微博";
			btn2.title = "←";
			btn2.enable = false;
			btn3.title = "打开手势";
			btn4.title = "↑";
			btn5.title = "开始检测";
			btn6.title = "↓";
			btn7.title = "重置";
			btn8.title = "→";
			btn8.enable = false;
			btn9.title = "";
		}
		public function init(e:FullScreenGesture)
		{
			mc_fsg = e;
		}
		private function addUiListener()
		{
			SinaMicroBlogManager.addEventListener("FriendsTimeline",onUpdateHandle);
			btn1.addEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn2.addEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn3.addEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn4.addEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn5.addEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn6.addEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn7.addEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn8.addEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn9.addEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn_close.addEventListener(MouseEvent.CLICK,onApplicationClose);
		}
		private function removeUiListener()
		{
			SinaMicroBlogManager.removeEventListener("FriendsTimeline",onUpdateHandle);
			btn1.removeEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn2.removeEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn3.removeEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn4.removeEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn5.removeEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn6.removeEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn7.removeEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn8.removeEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn9.removeEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn_close.removeEventListener(MouseEvent.CLICK,onApplicationClose);
		}
		private function onMouseClickHandle(e:UnitEvent )
		{
			switch (e.target.name)
			{
				case "btn1" :
					SinaMicroBlogManager.ApiFriendsTimeline(60);
					nowCount = 0;
					returnNowCount();
					btn2.enable = true;
					btn8.enable = true;
					break;
				case "btn2" :
					mc_fsg.moveLeft(SinaMicroBlogManager.cacheFriendsTimeline[NextStatus]);
					break;
				case "btn3" :
					ApplicationManager.open("GestureControl.GestureControl");
					break;
				case "btn4" :
					break;
				case "btn5" :
					NuiGesture.addEventListener(GestureEvent.GESTURE,onGestureHandle);
					break;
				case "btn6" :
					//trace(e.target.title);
					break;
				case "btn7" :
					nowCount = 0;
					returnNowCount();
					break;
				case "btn8" :
					//trace(e.target.title);
					mc_fsg.moveRight(SinaMicroBlogManager.cacheFriendsTimeline[PrevStatus]);
					break;
				case "btn9" :
					break;
				default :
					break;
			}
		}
		private function onGestureHandle(e:GestureEvent )
		{

			switch (e.data.direction)
			{
				case "right" :
					if (e.data.type == 1)
					{

					}
					mc_fsg.moveRight(SinaMicroBlogManager.cacheFriendsTimeline[PrevStatus]);
					break;
				case "left" :
					if (e.data.type == 1)
					{

					}
					mc_fsg.moveLeft(SinaMicroBlogManager.cacheFriendsTimeline[NextStatus]);
					break;
				case "up" :
					if (e.data.type == 1)
					{

					}
					SinaMicroBlogManager.ApiFriendsTimeline(60);
					nowCount = 0;
					returnNowCount();
					btn2.enable = true;
					btn8.enable = true;
					break;
				case "down" :
					if (e.data.type == 1)
					{
						
					};
					mc_fsg.moveLeft(SinaMicroBlogManager.cacheFriendsTimeline[nowCount = 0]);
					break;
			}
		}
		private function onUpdateHandle(e:MicroBlogEvent)
		{
			mc_fsg.moveRight(SinaMicroBlogManager.cacheFriendsTimeline[0]);
		}
		private function get NextStatus():int
		{
			nowCount == (SinaMicroBlogManager.cacheFriendsTimeline.length-1) ? nowCount=0:nowCount++;
			returnNowCount();
			return nowCount;
		}
		private function returnNowCount()
		{
			btn9.title = "当前：" + nowCount;
			btn9.enable = false;
		}
		private function get PrevStatus():int
		{
			--nowCount < 0 ? nowCount = 0:null;
			returnNowCount();
			return nowCount;

		}
		private function onApplicationClose(e:MouseEvent )
		{
			dispatchEvent(new UnitEvent (UnitEvent.UNIT_CLOSE));
		}
	}

}