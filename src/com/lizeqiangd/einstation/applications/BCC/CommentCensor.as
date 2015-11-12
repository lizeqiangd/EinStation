package com.lizeqiangd.einstation.applications.BCC
{
	
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.interfaces.label.la_general;
	import com.lizeqiangd.zweisystem.interfaces.label.la_rect;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import com.lizeqiangd.zweisystem.system.config.ESTextFormat;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 */
	
	public class CommentCensor extends TitleWindows implements iApplication
	{
		
		private var ssn:SystemStatusNotification
		
		private var tx_subtitle:TextField
		private var la_username:la_rect
		
		private var la_live_title:la_rect
		private var la_live_cid:la_rect
		
		//private var la_live_title:la_rect
		
		//private var la_live_title:la_general
		//private var la_live_title:la_general
		public function CommentCensor()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - CommentCensor -";
			this.setApplicationName = "CommentCensor";
			this.configWindows(600, 500);
			this.showCloseButton (false);
			ssn = new SystemStatusNotification();
			ssn.y = 20;
			ssn.config(this.getUiWidth, getUiHeight - 20);
			addChild(ssn);
			this.addEventListener(ApplicationEvent.INIT, init);
			tx_subtitle = new TextField;
			var t:TextFormat = ESTextFormat.LightBlueTitleTextFormat;
			t.align = TextFormatAlign.LEFT;
			tx_subtitle.defaultTextFormat = t;
			tx_subtitle.y = 21;
			tx_subtitle.mouseEnabled = false;
			tx_subtitle.text = '信息面板';
			addChild(tx_subtitle);
			
			la_username = new la_rect;
			la_username.title = '审核用户未登录';
			la_username.x = 320
			la_username.y = 25
			addChild(la_username);
			
			la_live_title = new la_rect;
			la_live_title.title = '<滚蛋吧!肿瘤君>线下电影弹幕';
			la_live_title.x = 20
			la_live_title.y = 50
			addChild(la_live_title);
			
			la_live_cid = new la_rect;
			la_live_cid.title = '弹幕场次编号:816';
			la_live_cid.x = 320
			la_live_cid.y = 50
			addChild(la_live_cid);
		
		}
		
		override public function additionFrame(s:Shape):void
		{
			sp_frame.graphics.moveTo(0, 40)
			sp_frame.graphics.lineTo(150, 40)
			sp_frame.graphics.lineTo(150 + 20, 40 - 20)
			sp_frame.graphics.moveTo(0, 80)
			sp_frame.graphics.lineTo(getUiWidth, 80)
			sp_frame.graphics.moveTo(0, getUiHeight-30)
			sp_frame.graphics.lineTo(getUiWidth, getUiHeight-30)
		}
		
		//override public function configWindows(_w:Number, _h:Number):void
		//{
			//super.configWindows(_w, _h)
			////createFrame(true);
			////tx_title.defaultTextFormat = t
			////tx_title.text = "Initializing.";
		//}
		
		public function init(e:ApplicationEvent):void
		{
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function addApplicationListener():void
		{
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function removeApplicationListener():void
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent):void
		{
			removeApplicationListener();
		
		}
		
		public function dispose():void
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE))
		}
		
		public function applicationMessage(e:Object):void
		{
			switch (e)
			{
			case "": 
				break;
			default: 
				break;
			}
		}
	}

}