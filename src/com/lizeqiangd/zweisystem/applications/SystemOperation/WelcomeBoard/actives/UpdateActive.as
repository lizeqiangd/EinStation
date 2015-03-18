package com.lizeqiangd.zweisystem.applications.SystemOperation.WelcomeBoard.actives{
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.lizeqiangd.zweisystem.abstract.active.*
	import com.lizeqiangd.zweisystem.abstract.windows.BaseWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import flash.events.MouseEvent;
	public class UpdateActive extends BaseActive implements iActive ,iApplication 
	{
		private var ivm:ViewManager  ;
		public function UpdateActive()
		{	super("UpdateActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			ivm = new ViewManager(this, 0, 0, 0, 0);	
			ivm.y=20
			ivm.mask =mc_mask
		}
		public function init(e:ApplicationEvent   ){};
		private function onAddToHost(e:ActiveEvent)
		{
			ivm.moveview("HelpActive", "left");
			
			addUiListener()
		}
		private function onClick(e:MouseEvent )
		{
			switch (e.target.name)
			{
				case "btn_label1" :
					ivm.moveview("HelpActive", "down");
					break;
				case "btn_label2" :
					ivm.moveview("AboutActive", "down");
					break;
				case "btn_label3" :
					ivm.moveview("RightActive", "down");
					break;
				default :
					break;
			}
		}
		private function onRemoveToHost(e:ActiveEvent)
		{
			
			
			removeUiListener()
		}
		private function addUiListener()
		{
		
			btn_label1.addEventListener(MouseEvent.CLICK, onClick);
			btn_label2.addEventListener(MouseEvent.CLICK, onClick);
			btn_label3.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function removeUiListener()
		{
		
			btn_label1.removeEventListener(MouseEvent.CLICK, onClick);
			btn_label2.removeEventListener(MouseEvent.CLICK, onClick);
			btn_label3.removeEventListener(MouseEvent.CLICK, onClick);
		}
		public function applicationMessage(e:Object ){}
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