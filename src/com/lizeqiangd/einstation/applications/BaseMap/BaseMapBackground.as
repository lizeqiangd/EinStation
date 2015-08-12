package com.lizeqiangd.einstation.applications.BaseMap
{
	
	import com.lizeqiangd.basemap.BaseMap;
	import com.lizeqiangd.basemap.config.MapSetting;
	import com.lizeqiangd.zweisystem.abstract.windows.BaseWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import flash.utils.setTimeout;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 */
	
	public class BaseMapBackground extends BaseWindows implements iApplication
	{
		
		private var ssn:SystemStatusNotification
		
		public function BaseMapBackground()
		{
			this.setDisplayLayer = "backgroundLayer";
			//this.setApplicationTitle = "EinStation Application - BaseMapBackground -";
			this.setApplicationName = "BaseMapBackground";
			this.configWindows(600, 500)
			ssn = new SystemStatusNotification()
			ssn.y = 20
			ssn.config(this.getUiWidth, getUiHeight - 20)
			//addChild(ssn)
			this.addEventListener(ApplicationEvent.INIT, init);
			this.removeChildren();
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INIT))
		
		}
		
		private var bm:BaseMap
		
		public function init(e:ApplicationEvent):void
		{
			
			MapSetting.getInstance.basemap_type = 'mapbox'
			MapSetting.getInstance.mapbox_token = 'pk.eyJ1IjoibGl6ZXFpYW5nZCIsImEiOiJKSHZ6RHNZIn0.9BZ9QpTL3MmJXeR9biD9Sw'
			MapSetting.getInstance.mapbox_style = 'lizeqiangd.09aab23b'
			//MapSetting.getInstance.mapbox_style = 'mapbox.streets'
			MapSetting.getInstance.tile_outsize_count = 2
			
			MapSetting.getInstance.Tile_Information_enable = false
			MapSetting.getInstance.Tile_ProgressBar_enable = true
			MapSetting.getInstance.Tile_Anime_enable = true
			MapSetting.getInstance.Tile_Debug_enable = false
			
			bm = BaseMap.getInstance
			bm.init();
			addChild(bm)
			//China Guangdong Shenzhen University
			bm.center(113.932663669586175, 22.534340149642382, 15);
			setTimeout(function():void
			{
				onStageResize()
			}, 500)
			//addChild(center_mark)
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		
		}
		
		private function onStageResize():void
		{
			//for test mask.
			//bm.x = bm.y = 30
			bm.setMapSize(stage.stageWidth, stage.stageHeight)
			//center_mark.x = stage.stageWidth / 2
			//center_mark.y = stage.stageHeight / 2
		}
		
		private function addApplicationListener():void
		{
			StageProxy.addResizeFunction(onStageResize)
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