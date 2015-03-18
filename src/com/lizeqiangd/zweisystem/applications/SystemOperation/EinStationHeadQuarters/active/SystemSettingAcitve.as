package com.lizeqiangd.zweisystem.applications.SystemOperation.EinStationHeadQuarters.active
{
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.lizeqiangd.zweisystem.abstract.active.*
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	
	public class SystemSettingAcitve extends BaseActive implements iActive
	{
		public function SystemSettingAcitve()
		{
			super("SystemSettingActive")
			
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
		
		}
		
		private function onAddToHost(e:ActiveEvent)
		{
			
			addUiListener()
		}
		
		private function onRemoveToHost(e:ActiveEvent)
		{
			
			removeUiListener()
		}
		
		private function addUiListener()
		{
			btn_fullscreen.addEventListener(UnitEvent.CLICK, onClick)
			btn_nonescreen.addEventListener(UnitEvent.CLICK, onClick)
			btn_resizeStage.addEventListener(UnitEvent.CLICK, onClick)
		}
		
		private function removeUiListener()
		{
			btn_fullscreen.removeEventListener(UnitEvent.CLICK, onClick)
			btn_nonescreen.removeEventListener(UnitEvent.CLICK, onClick)
			btn_resizeStage.removeEventListener(UnitEvent.CLICK, onClick)
		}
		
		private function onClick(e:UnitEvent):void
		{
			switch (e.target)
			{
				case btn_fullscreen: 
					this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE
					break;
				case btn_nonescreen: 
					this.stage.displayState = StageDisplayState.NORMAL
					break;
				case btn_resizeStage:
					StageProxy.updateStageSize()
					break;
				default: 
			}
		}
		
		public function activeMessage(msg:Object)
		{
			switch (msg)
			{
				case "": 
					break;
				default: 
					break;
			}
		
		}
		
		public function dispose()
		{
			removeUiListener()
			this.removeEventListener(ActiveEvent.IN, onAddToHost)
			this.removeEventListener(ActiveEvent.OUT, onRemoveToHost)
		
		}
	}

}