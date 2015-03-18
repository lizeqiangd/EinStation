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
	
	public class BackgroundActive extends BaseActive implements iActive
	{
		public function BackgroundActive()
		{
			super("BackgroundActive")
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
			btn_submit.addEventListener(UnitEvent.CLICK, onClick)
		}
		
		private function removeUiListener()
		{
			btn_submit.removeEventListener(UnitEvent.CLICK, onClick)
		}
		
		private function onClick(e:UnitEvent):void
		{
			var o:Object = {url: tx_url.text, author: tx_author.text, description: tx_description.text}
			ZweiteHorizont.FMSProxys.dispatch("EinStationEditBackgroundImage", o)
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