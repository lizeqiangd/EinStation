package com.lizeqiangd.zweisystem.applications.GraduationHelper.actives
{
	
	/**
	 * @author lizeqiangd
	 * @email $(DefaultEmail)
	 * @website $(DefaultSite)
	 */
	import com.zweisystem.abstracts.active.*
	import com.zweisystem.events.ActiveEvent;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.URLNavigateManager;
	
	public class InformationActive extends BaseActive implements iActive
	{
		public function InformationActive()
		{
			super("InformationActive")
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
			btn_navi.addEventListener(UnitEvent.CLICK, onNaviClick)
		
		}
		
		private function onNaviClick(e:UnitEvent):void
		{
			URLNavigateManager.open("http://192.168.2.138/Amain.asp", true)
		}
		
		private function removeUiListener()
		{
			btn_navi.removeEventListener(UnitEvent.CLICK, onNaviClick)
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