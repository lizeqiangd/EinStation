package com.lizeqiangd.zweisystem.applications.SinaWeibo.FullScreenDisplay
{

	import com.zweisystem.events.UnitEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;

	public class FullScreenDisplayControlPanel extends Sprite 
	{

		private var fsd:FullScreenDisplay;
		public function init()
		{

			btn1.title = "显示";
			btn1.enable = false;
			btn2.title = "刷新";
			btn3.title = "";
			btn3.enable = false;
			btn4.title = "";
			btn4.enable = false;
			addUiListener();
		}
		private function addUiListener()
		{
			btn1.addEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn2.addEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn3.addEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn4.addEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn_close.addEventListener(MouseEvent.CLICK,onCloseHandle);
			SinaMicroBlogManager.addEventListener ("FriendsTimeline",onUpdateSuccess)
		}
		private function removeUiListener()
		{
			btn1.removeEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn2.removeEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn3.removeEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn4.removeEventListener(UnitEvent.CLICK,onMouseClickHandle);
			btn_close.removeEventListener(MouseEvent.CLICK,onCloseHandle);
			SinaMicroBlogManager.removeEventListener ("FriendsTimeline",onUpdateSuccess)
		}
		private function onUpdateSuccess(e:*){
			btn1.enable = true;
		}
		private function onMouseClickHandle(e:UnitEvent )
		{
			switch (e.target.name)
			{
				case "btn1" :
					fsd.showStatus();
					break;
				case "btn2" :
					btn1.enable = false;
					SinaMicroBlogManager.ApiFriendsTimeline(95);					
					break;
				case "btn3" :

					break;
				case "btn4" :
					break;
			}
		}
		private function onCloseHandle(e:MouseEvent )
		{
			removeUiListener();
			dispatchEvent(new UnitEvent (UnitEvent.UNIT_CLOSE));
		}
		public function set fullScreenDisplay(e:FullScreenDisplay)
		{
			this.fsd = e;
			init();
		}
	}

}