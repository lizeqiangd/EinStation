package com.lizeqiangd.zweisystem.applications.SystemOperation.EinStationHeadQuarters.active
{
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.junkbyte.console.Cc;
	import com.lizeqiangd.zweisystem.abstract.active.*
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	
	public class FunctionActive extends BaseActive implements iActive
	{
		public function FunctionActive()
		{
			super("FunctionActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
		
		}
		
		private function onAddToHost(e:ActiveEvent)
		{
			
			addUiListener()
		}
		
		private function onRemoveToHost(e:ActiveEvent)
		{
			isUserActiveMoveIn = false
			removeUiListener()
		}
		
		private function addUiListener()
		{
			btn_boardcast.addEventListener(UnitEvent.CLICK, onMouseClick)
			btn_alpha.addEventListener(UnitEvent.CLICK, onMouseClick)
			btn_title.addEventListener(UnitEvent.CLICK, onMouseClick)
			btn_background.addEventListener(UnitEvent.CLICK, onMouseClick)
			btn_system_setting.addEventListener(UnitEvent.CLICK, onMouseClick)
			btn_user_setting.addEventListener(UnitEvent.CLICK, onMouseClick)
			btn_system_control.addEventListener(UnitEvent.CLICK, onMouseClick)
			btn_system_config.addEventListener(UnitEvent.CLICK, onMouseClick)
			btn_console.addEventListener(UnitEvent.CLICK, onMouseClick)
		}
		private var isUserActiveMoveIn:Boolean = false
		
		private function onMouseClick(e:UnitEvent):void
		{
			isUserActiveMoveIn ? null : getAcitveManager.movein("UserActive", "p2", "down")
			isUserActiveMoveIn = true
			switch (e.target)
			{
				case btn_boardcast: 
					getAcitveManager.moveOutActiveByPoint("p1", "right")
					getAcitveManager.movein("BoardcastActive", "p1", "right")
					break;
				case btn_alpha: 
					getAcitveManager.moveOutActiveByPoint("p1", "right")
					getAcitveManager.movein("AlphaActive", "p1", "right")
					break;
				case btn_title: 
					getAcitveManager.moveOutActiveByPoint("p1", "right")
					getAcitveManager.movein("TitleActive", "p1", "right")
					break;
				case btn_background: 
					getAcitveManager.moveOutActiveByPoint("p1", "right")
					getAcitveManager.movein("BackgroundActive", "p1", "right")
					break;
				case btn_system_setting: 
					getAcitveManager.moveOutActiveByPoint("p1", "right")
					getAcitveManager.moveOutActiveByPoint("p2", "down")
					isUserActiveMoveIn = false
					getAcitveManager.movein("SystemSettingActive", "p1", "right")
					break;
				case btn_user_setting: 
					getAcitveManager.moveOutActiveByPoint("p1", "right")
					getAcitveManager.movein("UserSettingActive", "p1", "right")
					break
				case btn_system_control: 
					getAcitveManager.moveOutActiveByPoint("p1", "right")
					getAcitveManager.movein("SystemControlActive", "p1", "right")
					break
				case btn_system_config: 
					getAcitveManager.moveOutActiveByPoint("p1", "right")
					getAcitveManager.moveOutActiveByPoint("p2", "down")
					isUserActiveMoveIn = false
					getAcitveManager.movein("SystemConfigActive", "p1", "right")
					break
				case btn_console: 
					isUserActiveMoveIn = false
					Cc.visible = !Cc.visible
				default: 
			}
		
		}
		
		private function removeUiListener()
		{
			btn_system_setting.removeEventListener(UnitEvent.CLICK, onMouseClick)
			btn_user_setting.removeEventListener(UnitEvent.CLICK, onMouseClick)
			btn_boardcast.removeEventListener(UnitEvent.CLICK, onMouseClick)
			btn_alpha.removeEventListener(UnitEvent.CLICK, onMouseClick)
			btn_title.removeEventListener(UnitEvent.CLICK, onMouseClick)
			btn_background.removeEventListener(UnitEvent.CLICK, onMouseClick)
			btn_system_control.removeEventListener(UnitEvent.CLICK, onMouseClick)
			btn_console.removeEventListener(UnitEvent.CLICK, onMouseClick)
			
			btn_system_config.removeEventListener(UnitEvent.CLICK, onMouseClick)
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