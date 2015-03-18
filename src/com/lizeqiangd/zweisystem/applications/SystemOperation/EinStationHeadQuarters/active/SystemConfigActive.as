package com.lizeqiangd.zweisystem.applications.SystemOperation.EinStationHeadQuarters.active
{
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.lizeqiangd.zweisystem.abstract.active.*
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.data.config.EinStationConfigCache;
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweisystem.modules.datagird.DataGird;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import com.lizeqiangd.zweisystem.net.AMFPHP;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import flash.events.MouseEvent;
	
	public class SystemConfigActive extends BaseActive implements iActive
	{
		private var ssn:SystemStatusNotification
		private var dg:DataGird
		
		public function SystemConfigActive()
		{
			super("SystemConfigActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			rows_users.titleMode()
			rows_users.tx_id.text = "id"
			rows_users.tx_name.text = "设定名称"
			rows_users.tx_description.text = "备注"
			dg = new DataGird
			dg.config(this, "com.lizeqiangd.zweisystem.applications.SystemOperation.EinStationHeadQuarters.datagird.rows_amfphp", 9)
			addChild(dg)
			dg.y = 40
			ssn = new SystemStatusNotification
			ssn.init(340, 200)
			ssn.y=20
			addChild(ssn)
			tx_id.text = ""
			tx_value.text = ""
			tx_description.text = ""
			tx_name.text = ""
			tx_value.text = ""
			tx_update_time.text = ""
		}
		
		private function onAddToHost(e:ActiveEvent)
		{
			onRefrushAMFPHPConfig()
			addUiListener()
		}
		
		private function onRemoveToHost(e:ActiveEvent)
		{
			
			removeUiListener()
		}
		
		private function addUiListener()
		{
			tx_id.addEventListener(MouseEvent.CLICK, onCreateAMFPHPConfig)
			btn_scroll.addEventListener(UnitEvent.CHANGE, onScrollChange)
			btn_update.addEventListener(UnitEvent.CLICK, onUpdateAMFPHPConfig)
			btn_refrush.addEventListener(MouseEvent.CLICK, onRefrushAMFPHPConfig)
			dg.addRowsListener(UnitEvent.CLICK, onRowsClick)
		}
		
		private function removeUiListener()
		{
			tx_id.removeEventListener(MouseEvent.CLICK, onCreateAMFPHPConfig)
			btn_scroll.removeEventListener(UnitEvent.CHANGE, onScrollChange)
			btn_update.removeEventListener(UnitEvent.CLICK, onUpdateAMFPHPConfig)
			btn_refrush.removeEventListener(MouseEvent.CLICK, onRefrushAMFPHPConfig)
			dg.removeRowsListener(UnitEvent.CLICK, onRowsClick)
		}
		
		private function onUpdateAMFPHPConfig(e:UnitEvent):void
		{
			var o:Array = []
			o.password = LoginManager.getPassword
			o.username = LoginManager.getUsername
			o.name = tx_name.text
			o.value = tx_value.text
			o.id = tx_id.text
			o.description = tx_description.text
			AMFPHP.callResult("EinStationServices/setEinStationConfig", onUpdateConfigComplete, o)
			
			btn_update.enable = false
		}
		
		private function onCreateAMFPHPConfig(e:MouseEvent):void
		{
			tx_id.text = "new"
		}
		
		private function onUpdateConfigComplete(e:Object)
		{
			if (e.state == "failed")
			{
				Message.AMFPHPMessage("更新或创建失败，原因：" + e.message)
			}
			if (e.state == "success")
			{
				//Message.AMFPHPMessage("success:" + e.message)
				onRefrushAMFPHPConfig()
			}
			btn_update.enable = true
		}
		
		private function onRefrushAMFPHPConfig(e:MouseEvent = null):void
		{
			ssn.anime("state.ssn_loading", "读取设定资料中")
			var o:Array = []
			o.password = LoginManager.getPassword
			o.username = LoginManager.getUsername
			AMFPHP.callResult("EinStationServices/getEinStationConfig", onRefrushResult, o)
		}
		
		private function onScrollChange(e:UnitEvent):void
		{
			dg.init(EinStationConfigCache.configs.slice(e.data, e.data + 9)) //
			dg.animation()
		}
		
		private function onRefrushResult(e:Object):void
		{
			ssn.clean()
			EinStationConfigCache.cache(e)
			btn_scroll.init(9, EinStationConfigCache.configs.length)
			dg.init(EinStationConfigCache.configs)
			dg.animation()
		}
		
		private function onRowsClick(e:UnitEvent):void
		{
			for (var i:int = 0; i < EinStationConfigCache.configs.length; i++)
			{
				if (e.data == EinStationConfigCache.configs[i].id)
				{
					tx_id.text = EinStationConfigCache.configs[i].id
					tx_value.text = EinStationConfigCache.configs[i].value
					tx_description.text = EinStationConfigCache.configs[i].description
					tx_name.text = EinStationConfigCache.configs[i].name
					tx_value.text = EinStationConfigCache.configs[i].value
					tx_update_time.text = EinStationConfigCache.configs[i].update_time
					TextAnimation.Typing(tx_name.tf)
					TextAnimation.Typing(tx_update_time)
					TextAnimation.Typing(tx_description.tf)
				}
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