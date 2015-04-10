package com.lizeqiangd.einstation.applications.WorkAssistant
{
	import com.lizeqiangd.zweisystem.abstract.active.BaseActive;
	import com.lizeqiangd.zweisystem.abstract.active.iActive;
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	/**
	 *
	 * @author Lizeqiangd
	 */
	public class WorkList extends BaseActive implements iActive
	{
		
		public function WorkList()
		{
			super('work_list')
			this.setActiveTitle = '工作序列'
			this.config(300, 200)
			this.createFrame()
			//this.createBackground(0.5)
			addActiveListener()
		}
		
		private function addActiveListener():void
		{
			this.addEventListener(ActiveEvent.IN, onActiveIn)
			this.addEventListener(ActiveEvent.OUT, onActiveOut)
		}
		
		private function onActiveIn(e:ActiveEvent):void
		{
		
		}
		
		private function onActiveOut(e:ActiveEvent):void
		{
		
		}
		
		public function dispose():void
		{
		
		}
		
		public function activeMessage(msg:Object):void
		{
		
		}
	}
}