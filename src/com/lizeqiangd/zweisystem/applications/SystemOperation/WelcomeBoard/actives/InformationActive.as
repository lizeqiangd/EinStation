package com.lizeqiangd.zweisystem.applications.SystemOperation.WelcomeBoard.actives
{
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.lizeqiangd.zweisystem.abstract.active.*
	import com.lizeqiangd.zweisystem.system.config.SystemConfig;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	import com.lizeqiangd.zweisystem.modules.imagedisplay.ImageDisplay;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	
	public class InformationActive extends BaseActive implements iActive
	{
		private var ssn:SystemStatusNotification;
		private var image_icon:ImageDisplay;
		private var nowLoaded:int = 0
		private var totalLoaded:int = 3
		
		public function InformationActive()
		{
			super("InformationActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			ssn = new SystemStatusNotification();
			ssn.init(480, 100);
			image_icon = new ImageDisplay;
			addChild(ssn);
			addChildAt(image_icon, 0);
		
		}
		
		private function onAddToHost(e:ActiveEvent)
		{
			nowLoaded = 0
			SystemConfig.getSystemConfig("AdministratorIcon", onResult)
			SystemConfig.getSystemConfig("WelcomeInformation", onResult)
			SystemConfig.getSystemConfig("AdministratorName", onResult)
			ssn.anime("state.ssn_loading");
			addUiListener()
		}
		
		private function onResult(e:*)
		{
			switch (e.name)
			{
				case "AdministratorIcon": 
					image_icon.configProportionalOutside(80, 100, true);
					image_icon.load(e.value);
					nowLoaded++
					break;
				case "WelcomeInformation": 
					tx_introduction.text = e.value;
					this.getActive("ConfigActive").activeMessage({content: tx_introduction.text})
					TextAnimation.Typing(tx_introduction)
					nowLoaded++
					break;
				case "AdministratorName": 
					tx_administrator.text = e.value;
					nowLoaded++
					break;
			
			}
			if (nowLoaded == totalLoaded)
			{
				ssn.clean();
			}
		
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
			ssn.dispose()
			removeChild(ssn);
			image_icon.dispose();
			this.removeEventListener(ActiveEvent.IN, onAddToHost)
			this.removeEventListener(ActiveEvent.OUT, onRemoveToHost)
		
		}
	}

}