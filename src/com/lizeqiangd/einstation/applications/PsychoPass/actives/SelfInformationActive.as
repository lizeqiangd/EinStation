package com.zweisystem.applications.PsychoPass.actives
{
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.zweisystem.abstracts.active.*
	import com.zweisystem.animations.texteffect.TextAnimation;
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;
	import com.zweisystem.events.ActiveEvent;
	import com.zweisystem.managers.AnimationManager;
	import com.zweisystem.modules.imagedisplay.ImageDisplay;
	import flash.events.Event;
	
	public class SelfInformationActive extends BaseActive implements iActive
	{
		private var id:ImageDisplay
		
		public function SelfInformationActive()
		{
			super("SelfInformationActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			lb_name.title = "NAME"
			lb_id.title = "ID"
			tx_name.text = " "
			tx_id.text = " "
			id = new ImageDisplay()
			id.config(180, 180)
			addChildAt(id, 0)
		}
		
		public function init()
		{
			tx_name.text = "loading"
			tx_id.text = "loading"
			id.load(SinaMicroBlogManager.cacheUserData.avatar_large)
			TextAnimation.Changing(tx_name, TextAnimation.ALPHABET, 1, true)
			TextAnimation.Changing(tx_id, TextAnimation.NUMBER, 1, true)
		}
		
		private function onImageLoadComplete(e:Event):void
		{
			tx_name.text = SinaMicroBlogManager.cacheUserData.screen_name
			tx_id.text = SinaMicroBlogManager.cacheUserData.id
			AnimationManager.fade_in(id)
			TextAnimation.Changing(tx_name, tx_name.text, 1, true)
			TextAnimation.Changing(tx_id, TextAnimation.NUMBER, 1, true)
			this.getAcitveManager.movein("MentalColorActive", "p2", "right")
			this.getActive("MentalColorActive").activeMessage(id)
		}
		
		private function addUiListener()
		{
			id.addEventListener(Event.COMPLETE, onImageLoadComplete)
		}
		
		private function removeUiListener()
		{
			id.removeEventListener(Event.COMPLETE, onImageLoadComplete)
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
		
		private function onAddToHost(e:ActiveEvent)
		{
			init()
			addUiListener()
		}
		
		private function onRemoveToHost(e:ActiveEvent)
		{
			removeUiListener()
		}
		
		public function dispose()
		{
			this.removeEventListener(ActiveEvent.IN, onAddToHost)
			this.removeEventListener(ActiveEvent.OUT, onRemoveToHost)
		
		}
	}

}