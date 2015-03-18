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
	import com.lizeqiangd.zweitehorizont.ZweiteHorizont;
	
	public class SystemConrtolActive extends BaseActive implements iActive
	{
		public function SystemConrtolActive()
		{
			super("SystemControlActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			btn_lock.setColor = "red"
			btn_unlock.setColor = "red"
			btn_lock.title = "\n\n锁定"
			btn_unlock.title = "\n\n解锁"
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
			btn_lock.addEventListener(UnitEvent.CLICK, onClick)
			btn_unlock.addEventListener(UnitEvent.CLICK, onClick)
		}
		
		private function removeUiListener()
		{
			btn_lock.removeEventListener(UnitEvent.CLICK, onClick)
			btn_unlock.removeEventListener(UnitEvent.CLICK, onClick)
		}
		
		private function onClick(e:UnitEvent):void
		{
			switch (e.target)
			{
				case btn_lock: 
					ZweiteHorizont.FMSProxys.dispatch("EinStationShutdownSystem", {message: tx_content.text})
					break
				case btn_unlock: 
					ZweiteHorizont.FMSProxys.dispatch("EinStationRecoverSystem", {message: tx_content.text})
					break
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