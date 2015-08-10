package com.lizeqiangd.einstation.applications.Heimdallr
{
	
	import com.lizeqiangd.zweisystem.abstract.windows.DragWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.modules.imagedisplay.ImageDisplay;
	import com.lizeqiangd.zweisystem.modules.imagedisplay.MutilImageDisplay;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import flash.display.Shape;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 */
	
	public class Heimdallr extends DragWindows implements iApplication
	{
		
		private var ssn:SystemStatusNotification
		private var id:MutilImageDisplay
		
		public function Heimdallr()
		{
			this.setBackGroundColor = 0
			this.setBgAlpha=0.1
			this.setDisplayLayer = "applicationLayer";
			//this.setApplicationTitle = "EinStation Application - Heimdallr -";
			this.setApplicationName = "Heimdallr";
			this.configWindows(900, 600)
			ssn = new SystemStatusNotification()
			ssn.y = 20
			ssn.config(this.getUiWidth, getUiHeight - 20)
			addChild(ssn)
			id = new MutilImageDisplay()
			this.addEventListener(ApplicationEvent.INIT, init);
		}
		private var arr_char:Array = ['http://utils.lizeqiangd.com/EinStation/Heimdallr/character_6_1.png', 'http://utils.lizeqiangd.com/EinStation/Heimdallr/character_6_2.png']
		private var arr_char_index:uint = 0
		private var mask_char:Shape
		
		public function init(e:ApplicationEvent):void
		{
			
			mask_char = new Shape
			mask_char.graphics.beginFill(0, 0)
			mask_char.graphics.drawRect(0, 0, getUiWidth, getUiHeight)
			addChild(mask_char)
			mask_char.visible = false
			id.mask = mask_char;
			id.y = getUiHeight - 500;
			setInterval(function():void
			{
				id.load(arr_char[arr_char_index % 2]);
				arr_char_index++
			}, 10000)
			addChild(id)
			
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function addApplicationListener():void
		{
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function removeApplicationListener():void
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent):void
		{
			removeApplicationListener();
		
		}
		
		public function dispose():void
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE))
		}
		
		public function applicationMessage(e:Object):void
		{
			switch (e)
			{
			case "": 
				break;
			default: 
				break;
			}
		}
	}

}