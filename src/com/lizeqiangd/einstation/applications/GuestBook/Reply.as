package com.lizeqiangd.einstation.applications.GuestBook
{
	
	import com.lizeqiangd.zweisystem.abstract.active.*
	import com.lizeqiangd.zweisystem.components.gravatar.GravatarImage;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweisystem.modules.imagedisplay.ImageDisplay;
	
	/**
	 * Active  信息获得渠道是EinStation类本身
	 * @author lizeqiangd
	 * @email $(DefaultEmail)
	 * @website $(DefaultSite)
	 */
	
	public class Reply extends BaseActive implements iActive
	{
		private var im:ImageDisplay = new ImageDisplay
		
		public function Reply()
		{
			super("Reply")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			im.configProportionalOutside(80, 100, true)
			im.y = 20
			addChildAt(im, 0)
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
		
		public function activeMessage(msg:Object)
		{
			tx_content.text = String(msg)
			TextAnimation.Typing(tx_content)
			im.load(GravatarImage.getImage(EinStation._CreatorEmail))
			tx_name.text = EinStation._Creator
		}
		
		public function dispose()
		{
			removeUiListener()
			this.removeEventListener(ActiveEvent.IN, onAddToHost)
			this.removeEventListener(ActiveEvent.OUT, onRemoveToHost)
		
		}
	}

}