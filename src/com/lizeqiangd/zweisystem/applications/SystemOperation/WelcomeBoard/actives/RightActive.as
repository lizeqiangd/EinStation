package com.lizeqiangd.zweisystem.applications.SystemOperation.WelcomeBoard.actives{
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.lizeqiangd.zweisystem.abstract.active.*
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	public class RightActive extends BaseActive implements iActive 
	{
		public function RightActive()
		{	super("RightActive")
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
		
		}
		
		private function removeUiListener()
		{
		
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