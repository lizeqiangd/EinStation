package com.lizeqiangd.zweisystem.applications.SystemOperation.WelcomeBoard.actives
{
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.lizeqiangd.zweisystem.abstract.active.*
	import com.lizeqiangd.zweisystem.system.config.SystemConfig;
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import com.lizeqiangd.zweisystem.net.AMFPHP;
	import flash.events.MouseEvent;
	
	public class ConfigActive extends BaseActive implements iActive
	{
		private var ssn:SystemStatusNotification;
		private var cacheText:String = "";
		
		public function ConfigActive()
		{
			super("ConfigActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			ssn = new SystemStatusNotification;
			ssn.init(480, 100);
			addChild(ssn);
			
			states = "服务器连接状态：" + AMFPHP.status;
		}
		
		private function set states(s:String)
		{
			this.tx_state.text = s;
		
		}
		
		private function onComfirm(e:MouseEvent )
		{
			if (!LoginManager.isAdministrator)
			{
				tx_input.text = "您所在的用户组没有该权限。";
				return;
			}
			ssn.anime("state.ssn_sending");
			if (tx_input.text == "")
			{
				tx_input.text = "(无内文)";
			}
			SystemConfig.setSystemConfig("WelcomeInformation",tx_input.text,onOK)
		}
		
		public function activeMessage(msg:Object)
		{
			cacheText = String(msg.content)
		}
		
		private function onOK(e:*)
		{
			states = "服务器连接状态：" + AMFPHP.status;
			ssn.clean();
			host.applicationMessage("informationsMode");
			//AM.moveout("ConfigActive","right");
		}
		
		private function onChangerUser()
		{
			states = "服务器连接状态：" + AMFPHP.status;	
			this.tx_loginer.text = "用户:" + LoginManager.getUsername		
			if (!LoginManager.isAdministrator)
			{
			tx_loginer.text = "无权限修改";
			}
		}
		
		private function set loginer(s:String)
		{
			states = "服务器连接状态：" + AMFPHP.status;
		}
		
		private function onAddToHost(e:ActiveEvent)
		{
			tx_input.text = cacheText;
			addUiListener();
		}
		
		private function onRemoveToHost(e:ActiveEvent)
		{
			cacheText = tx_input.text;
			removeUiListener();
		}
		
		private function addUiListener()
		{
			LoginManager.addLoginFunction(onChangerUser)		
			btn_confirm.addEventListener(MouseEvent.CLICK, onComfirm);
		}
		
		private function removeUiListener()
		{
			btn_confirm.removeEventListener(MouseEvent.CLICK, onComfirm);
			LoginManager.removeLoginFunction(onChangerUser)
		
		}
				
		public function dispose()
		{
			removeChild(ssn);
			removeUiListener()
			this.removeEventListener(ActiveEvent.IN, onAddToHost)
			this.removeEventListener(ActiveEvent.OUT, onRemoveToHost)
		
		}
	}

}