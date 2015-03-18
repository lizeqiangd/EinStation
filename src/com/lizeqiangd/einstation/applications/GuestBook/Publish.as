package com.lizeqiangd.einstation.applications.GuestBook
{
	
	import com.lizeqiangd.zweisystem.abstract.active.*
	import com.lizeqiangd.zweisystem.components.gravatar.GravatarImage;
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.interfaces.textinput.ti_general;
	import com.lizeqiangd.zweisystem.manager.LoginManager;
	import com.lizeqiangd.zweisystem.modules.imagedisplay.ImageDisplay;
	import com.lizeqiangd.zweisystem.net.AMFPHP;
	import com.lizeqiangd.zweisystem.system.config.ESAmfphp;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	/**
	 * Active
	 * @author lizeqiangd
	 * @email $(DefaultEmail)
	 * @website $(DefaultSite)
	 */
	
	public class Publish extends BaseActive implements iActive
	{
		public var im:ImageDisplay = new ImageDisplay;
		public var ti_name:ti_general;
		private var email:String = ""
		
		public function Publish()
		{
			super("Publish");
			this.addEventListener(ActiveEvent.IN, onAddToHost);
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost);
			im = new ImageDisplay;
			im.y = 75;
			im.configProportionalOutside(80, 100, true);
			addChildAt(im, 0);
			setChildIndex(mc_bg, 0);
			tx_content.text = "";
		}
		
		private function onAddToHost(e:ActiveEvent)
		{
			addUiListener()
			btn_publish.title = "发布"
			btn_publish.enable = true
			if (LoginManager.isAdministrator)
			{
				ti_email.text = LoginManager.getEmail
				ti_name.text = LoginManager.getUsername
				StageProxy.focus = tx_content
			}
			else
			{
				StageProxy.focus = ti_name.tx_title
				StageProxy.nextTabForce(ti_email.tx_title)
				StageProxy.nextTabForce(tx_content)
			}
		
		}
		
		private function onPublishClick(e:UnitEvent):void
		{
			btn_publish.enable = false
			btn_publish.title = "发布中"
			var o:Array = new Array;
			o.name = ti_name.text;
			o.email = ti_email.text;
			o.content = tx_content.text;
			o.private = cb_private.selected ? "1" : "0";
			AMFPHP.callResult(ESAmfphp.Guestbook_publishComment, onPublished, o)
		}
		
		private function onPublished(e:Object):void
		{
			btn_publish.title = "发布完成"
			getAcitveManager.moveout("Publish", "down")
		}
		
		private function onEmailInputed(e:FocusEvent)
		{
			if (email == ti_email.text)
			{
				return
			}
			email = ti_email.text
			im.load(GravatarImage.getImage(email))
		}
		
		private function onRemoveToHost(e:ActiveEvent)
		{
			host.applicationMessage({type: "closePublish"})
			removeUiListener()
		}
		
		private function addUiListener()
		{
			btn_close.addEventListener(MouseEvent.CLICK, onCloseClick)
			btn_publish.addEventListener(UnitEvent.CLICK, onPublishClick)
			tx_content.addEventListener(FocusEvent.FOCUS_IN, onEmailInputed)
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			getAcitveManager.moveout("Publish", "down")
		}
		
		private function removeUiListener()
		{
			btn_publish.removeEventListener(UnitEvent.CLICK, onPublishClick)
			btn_close.removeEventListener(MouseEvent.CLICK, onCloseClick)
			tx_content.removeEventListener(FocusEvent.FOCUS_IN, onEmailInputed)
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