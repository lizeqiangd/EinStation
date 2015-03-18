package com.lizeqiangd.zweisystem.applications.ZweiteHorizont
{
	
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map;
	import com.google.maps.MapEvent;
	import com.google.maps.MapMoveEvent;
	import com.google.maps.MapType;
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.abstracts.windows.FullWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.PositionManager;
	import com.zweisystem.system.proxy.StageProxy;
	import com.zweisystem.system.applications.background.BackgroundManager;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class ZweiteHorizontFullDisplay extends FullWindows implements iApplication
	{
		private var map:Map
		
		public function ZweiteHorizontFullDisplay()
		{
			this.setDisplayLayer = "backgroundLayer";
			this.setBackgroundTitle = "EinStation Application - ZweiteHorizontFullDisplay -";
			this.setApplicationName = "ZweiteHorizontFullDisplay";
			this.setApplicationVersion = "0"
			this.setBgAlpha = 1
			this.setBackgroundTitle = "ZweiteHorizontFullDisplay"
			this.setBackgroundControlType = BackgroundManager.whiteWithoutText
			this.addEventListener(ApplicationEvent.INIT, init);
			map = new Map
			StageProxy.addResizeFunction(onStageResize);
		}
		
		public function init(e:ApplicationEvent)
		{
			addApplicationListener()
			map.language = "zh-cn";
			map.key = "ABQIAAAA2gJaCKInKm_SV7V3-9dPVhQ9SYWVfZa2swC8tgFoTJB0Dk7orxSyftOsxLRo2MBH6SNK92JazWt4Sg";
			map.url = "http://www.lizeqiangd.com"
			map.sensor = "false";
			map.x = 0;
			addChildAt(map, 0)
			addMapListener()
			onStageResize()
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		}
		
		private function addApplicationListener()
		{
			btn_test1.addEventListener(UnitEvent.CLICK, onTestClick)
			btn_test2.addEventListener(UnitEvent.CLICK, onTestClick)
			btn_test3.addEventListener(UnitEvent.CLICK, onTestClick)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function addMapListener()
		{
			map.addEventListener(MapEvent.COMPONENT_INITIALIZED, onMapEventTrace);
			
			map.addEventListener(MapEvent.CONTROL_ADDED, onMapEventTrace);
			map.addEventListener(MapEvent.CONTROL_REMOVED, onMapEventTrace);
			map.addEventListener(MapEvent.COPYRIGHTS_UPDATED, onMapEventTrace);
			
			map.addEventListener(MapEvent.DISPLAY_MESSAGE, onMapEventTrace);
			
			map.addEventListener(MapEvent.FLY_TO_CANCELED, onMapEventTrace);
			map.addEventListener(MapEvent.FLY_TO_DONE, onMapEventTrace);
			
			map.addEventListener(MapEvent.INFOWINDOW_CLOSED, onMapEventTrace);
			map.addEventListener(MapEvent.INFOWINDOW_CLOSING, onMapEventTrace);
			map.addEventListener(MapEvent.INFOWINDOW_OPENED, onMapEventTrace);
			
			map.addEventListener(MapEvent.MAP_PREINITIALIZE, onMapEventTrace);
			
			map.addEventListener(MapEvent.MAP_READY, onMapInited);
			map.addEventListener(MapEvent.MAP_READY, onMapEventTrace);
			
			map.addEventListener(MapEvent.MAP_INITIALIZE_FAILED, onMapEventTrace);
			map.addEventListener(MapEvent.MAP_READY_INTERNAL, onMapEventTrace);
			
			map.addEventListener(MapEvent.MAPTYPE_ADDED, onMapEventTrace);
			map.addEventListener(MapEvent.MAPTYPE_CHANGED, onMapEventTrace);
			map.addEventListener(MapEvent.MAPTYPE_STYLE_CHANGED, onMapEventTrace);
			map.addEventListener(MapEvent.MAPTYPE_REMOVED, onMapEventTrace);
			
			map.addEventListener(MapEvent.VIEW_CHANGED, onMapEventTrace);
			map.addEventListener(MapEvent.VISIBILITY_CHANGED, onMapEventTrace);
			map.addEventListener(MapEvent.SIZE_CHANGED, onMapEventTrace);
			
			map.addEventListener(MapMoveEvent.MOVE_END, onMapMoveEventTrace);
			map.addEventListener(MapMoveEvent.MOVE_START, onMapMoveEventTrace);
			map.addEventListener(MapMoveEvent.MOVE_STEP, onMapMove);
		}
		
		private function onMapMoveEventTrace(e:MapMoveEvent)
		{
			trace("e.type: " + e.type);
			var llb:LatLngBounds = map.getLatLngBounds()
			tx_top.text = "lng:" + llb.getNorth()
			tx_bottom.text = "lng:" + llb.getSouth()
			tx_left.text = "lat:" + llb.getWest()
			tx_right.text = "lat:" + llb.getEast()
			tx_centre.text = "lat:" + map.getCenter().lat() + " lng:" + map.getCenter().lng()
		
		}
		
		private function onMapEventTrace(e:MapEvent)
		{
			trace("e.type: " + e.type);
		if (e.type == "mapevent_mapready") {
		onStageResize()	}
		}
		
		private function onMapMove(e:MapMoveEvent)
		{
			//			topleftText = map.getLatLngBounds().getNorthWest();
			//	bottomrightText = map.getLatLngBounds().getSouthEast();
			//statusText = e.latLng;
		
		}
		
		private function onMapInited(e:MapEvent)
		{
			map.setCenter(new LatLng(22.5347105248345, 113.9317345238031), 15, MapType.SATELLITE_MAP_TYPE);
			map.enableContinuousZoom();
			map.enableScrollWheelZoom();
			//		ssn.clean();
			status = "如果地图无法显示，请使用lizeqiangd.com来访问本网站。";
//			MapControlActive(AM.Active("MapControlActive")).init();
		}
		
		private function set statusText(s:LatLng)
		{
			var str:String = "Lat:" + s.lat() + "  Lng:" + s.lng();
			status = str;
		}
		
		private function set status(s:String)
		{
			tx_output.text = s + "";
		}
		
		private function onTestClick(e:UnitEvent):void
		{
			switch (e.target)
			{
				case btn_test1:
					
					map.setCenter(new LatLng(22.5347105248345, 113.9317345238031), 15, MapType.SATELLITE_MAP_TYPE);
					break;
				case btn_test2: 
					map.setCenter(new LatLng(22.5347105248345, 113.9317345238031), 15, MapType.NORMAL_MAP_TYPE);
					break;
				case btn_test3: 
					map.setCenter(new LatLng(22.5347105248345, 113.9317345238031), 15, MapType.HYBRID_MAP_TYPE);
					break;
				default: 
			}
		}
		
		private function removeApplicationListener()
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			dispose()
		}
		
		public function dispose()
		{
			removeApplicationListener();
			StageProxy.removeResizeFunction(onStageResize);
		}
		
		private function onStageResize()
		{
			if (map.isLoaded())
			{
				map.width = StageProxy.stageWidth;
				map.height = StageProxy.stageHeight;
			}
			PositionManager.center(tx_centre)
			tx_centre.y-=30
			PositionManager.center(mc_centre_mark)
			PositionManager.left(tx_left)
			PositionManager.right(tx_right)
			PositionManager.bottom(tx_bottom)
			PositionManager.top(tx_top)
			
		}
		
		public function applicationMessage(e:Object)
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