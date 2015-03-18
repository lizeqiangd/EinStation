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
	import com.lizeqiangd.zweisystem.interfaces.numericstepper.ns_general;
	import com.lizeqiangd.zweisystem.modules.datagird.DataGird;
	import com.lizeqiangd.zweitehorizont.events.UserEvent;
	import com.lizeqiangd.zweitehorizont.system.ZweiteHorizontConfig;
	import com.lizeqiangd.zweitehorizont.ZweiteHorizont;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class UserActive extends BaseActive implements iActive
	{
		private var dg:DataGird = new DataGird
		public var ns:ns_general
		public function UserActive()
		{
			super("UserActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			
			dg.config(this, "com.lizeqiangd.zweisystem.applications.SystemOperation.EinStationHeadQuarters.datagird.rows_users", 6)
			dg.y = 40
			rows_title.titleMode()
			rows_title.tx_cid.text = "cid"
			rows_title.tx_uid.text = "uid"
			rows_title.tx_sid.text = "sid"
			rows_title.tx_display_name.text = "显示名"
			rows_title.tx_user_type.text = "用户级别"
		}
		
		private function onAddToHost(e:ActiveEvent)
		{
			onUserUpdate(null)
			addUiListener()
		}
		
		private function onRemoveToHost(e:ActiveEvent)
		{
			
			removeUiListener()
		}
		
		private function addUiListener()
		{
			ns.addEventListener(UnitEvent.CHANGE, onScrollChange)
			ZweiteHorizont.UserManagers.addUserEventListener(UserEvent.USER_EVENT, onUserUpdate)
			btn_refrush.addEventListener(MouseEvent.CLICK, onRefrush)
		}
		
		private function removeUiListener()
		{
			ZweiteHorizont.UserManagers.removeUserEventListener(UserEvent.USER_EVENT, onUserUpdate)
			btn_refrush.removeEventListener(MouseEvent.CLICK, onRefrush)
			ns.removeEventListener(UnitEvent.CHANGE, onScrollChange)
		}
		
		private function onRefrush(e:MouseEvent):void
		{
			ZweiteHorizont.FMSProxys.dispatch(ZweiteHorizontConfig.UserManagerGetOnlineUser)
		}
		
		private function onScrollChange(e:UnitEvent):void
		{
			updateDataGrid()
		}
		
		private function onUserUpdate(e:UserEvent):void
		{
			tx_title.text = "当前用户在线数:" + ZweiteHorizont.UserManagers.UserList.length;
			ns.setStepAndTotal(6, ZweiteHorizont.UserManagers.UserList.length)
			updateDataGrid()
		}
		
		private function updateDataGrid()
		{
			var datas:Array = new Array
			for (var i:int = ns.getNow; i < ZweiteHorizont.UserManagers.UserList.length; i++)
			{
				datas.push({cid: ZweiteHorizont.UserManagers.UserList[i].cid, sid: ZweiteHorizont.UserManagers.UserList[i].sid, display_name: ZweiteHorizont.UserManagers.UserList[i].display_name, user_type: ZweiteHorizont.UserManagers.UserList[i].user_type, description: ZweiteHorizont.UserManagers.UserList[i].description, uid: ZweiteHorizont.UserManagers.UserList[i].uid})
			}
			dg.init(datas)
			dg.animation()
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