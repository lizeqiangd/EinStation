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
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweitehorizont.ZweiteHorizont;
	import flash.events.Event;
	
	public class AlphaActive extends BaseActive implements iActive
	{
		public function AlphaActive()
		{
			super("AlphaActive")
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
		{ //volumebar.addEventListener(UnitEvent.CHANGE, onVolumeChange)
			btn_submit.addEventListener(UnitEvent.CLICK, onClick)
		}
		
		//private var volume:Number
		
		private function onVolumeChange(e:UnitEvent):void
		{
			//volume = e.data / 100
		}
		
		private function removeUiListener()
		{
			//volumebar.removeEventListener(UnitEvent.CHANGE, onVolumeChange)
			btn_submit.removeEventListener(UnitEvent.CLICK, onClick)
		}
		
		private function onClick(e:UnitEvent):void
		{
			
			ZweiteHorizont.FMSProxys.dispatch("EinStationEditApplicationBackground", {alpha: (sl_general.getNowPosition / 100)})
			//trace("alpha.before trans",volumebar.now / 100)
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