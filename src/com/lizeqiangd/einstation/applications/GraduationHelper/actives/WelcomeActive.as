package com.zweisystem.applications.GraduationHelper.actives{
	
	/**
	 * @author lizeqiangd
	 * @email $(DefaultEmail)
	 * @website $(DefaultSite)
	 */
	import com.zweisystem.abstracts.active.*
	import com.zweisystem.events.ActiveEvent;
	import flash.events.MouseEvent;
	public class WelcomeActive extends BaseActive implements iActive 
	{
		public function WelcomeActive()
		{	super("WelcomeActive")
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
		btn_enter.addEventListener (MouseEvent.CLICK,onClick)
		}
		
		private function onClick(e:MouseEvent):void 
		{
			this.getAcitveManager.moveOutActiveByPoint("p1")
			this.getAcitveManager.movein("ControlActive","p1","left")
			this.getAcitveManager.movein("InformationActive","p2","right")
		}
		
		private function removeUiListener()
		{btn_enter.removeEventListener (MouseEvent.CLICK,onClick)
		
		}
		public function activeMessage(msg:Object){
			switch (msg){
			case "":
				break;
			default:
				break;
			}
			
		}
		public function dispose()
		{	removeUiListener()
			this.removeEventListener(ActiveEvent.IN, onAddToHost)
			this.removeEventListener(ActiveEvent.OUT, onRemoveToHost)
		
		}
	}
	
}