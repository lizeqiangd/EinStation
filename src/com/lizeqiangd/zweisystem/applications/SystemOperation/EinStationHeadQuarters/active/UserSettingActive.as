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
	import com.lizeqiangd.zweisystem.system.applications.zweitehorizontwidget.ZweiteHorizontService;
	
	public class UserSettingActive extends BaseActive implements iActive
	{
		public function UserSettingActive()
		{
			super("UserSettingActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)					
		}
		
		private function onAddToHost(e:ActiveEvent)
		{
				if (LoginManager.isAdministrator)
			{la_usertype.text="您当前的身份是:administrator"
				ZweiteHorizontService.ZweiteHorizontWidgets.setUser_type = "administrator"
			}
			else
			{la_usertype.text="您当前的身份是:guest"
				ZweiteHorizontService.ZweiteHorizontWidgets.setUser_type = "guest"
			}
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
			if (LoginManager.isAdministrator)
			{la_usertype.text="您当前的身份是:administrator"
				ZweiteHorizontService.ZweiteHorizontWidgets.setUser_type = "administrator"
			}
			else
			{la_usertype.text="您当前的身份是:guest"
				ZweiteHorizontService.ZweiteHorizontWidgets.setUser_type = "guest"
			}
			ZweiteHorizontService.ZweiteHorizontWidgets.setUid = 0
			ZweiteHorizontService.ZweiteHorizontWidgets.setDisplay_name = tx_display_name.text
			ZweiteHorizontService.ZweiteHorizontWidgets.setDescription = tx_description.text
			ZweiteHorizontService.ZweiteHorizontWidgets.updateUserInformation()
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