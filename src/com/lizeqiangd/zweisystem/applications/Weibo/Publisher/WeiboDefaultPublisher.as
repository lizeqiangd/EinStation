package com.lizeqiangd.zweisystem.applications.Weibo.Publisher
{
	
	import com.lizeqiangd.zweisystem.applications.Weibo.WeiboManager;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.interfaces.button.btn_general_s;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import com.lizeqiangd.zweisystem.system.config.ESFilter;
	import com.sina.microblog.events.MicroBlogEvent;
	import flash.events.Event;
	
	import flash.events.TextEvent;
	import flash.events.KeyboardEvent;
	import flash.net.FileReference;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.FileFilter;
	
	/**
	 * @author lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * 2014.06.30 标准的发布器制作完成.
	 */
	
	public class WeiboDefaultPublisher extends TitleWindows implements iApplication
	{
		public var btn_image:btn_general_s
		public var btn_publish:btn_general_s
		
		private var ssn:SystemStatusNotification
		
		private var file:FileReference;
		private var ba:ByteArray;
		
		public function WeiboDefaultPublisher()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - WeiboDefaultPublisher -";
			this.setApplicationName = "WeiboDefaultPublisher";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
			tx_state.text = ""
			tx_input.text = ""
			tx_count.text = ""
		
		}
		
		public function init(e:ApplicationEvent)
		{
			file = new FileReference();
			ssn = new SystemStatusNotification
			ssn.init(400, 120, this)
			ssn.y = 20
			if (!WeiboManager.getIsLogined)
			{
				ssn.anime("notification.app_unauthorize", "没有得到授权")
			}
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			tx_state.text="普通发送微博模式."
			addApplicationListener()
		}
		
		private function addApplicationListener()
		{
			WeiboManager.addEventListener(MicroBlogEvent.LOGIN_SUCCESS, onLoginSuccess)
			btn_image.addEventListener(UnitEvent.CLICK, onImageClick)
			WeiboManager.addEventListener("UploadStatus", onSendComplete)
			WeiboManager.addEventListener("UpdateStatus", onSendComplete)
			file.addEventListener(Event.SELECT, onImageSelect);
			file.addEventListener(Event.COMPLETE, onImageComplete);
			tx_input.addEventListener(KeyboardEvent.KEY_DOWN, onTypingHandle);
			tx_input.addEventListener(KeyboardEvent.KEY_UP, onTypingHandle);
			btn_publish.addEventListener(UnitEvent.CLICK, onPublishClick)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onSendComplete(e:Event):void
		{
			Message.SinaWeiboPublishOk()
		}
		
		private function onTypingHandle(e:*)
		{
			TextAnimation.NumberCount(tx_count, tx_input.text.length, true)
		}
		
		private function onImageSelect(e:Event)
		{
			file.load();
		}
		
		private function onImageComplete(e:Event)
		{
			ba = file.data
		}
		
		private function onLoginSuccess(e:MicroBlogEvent):void
		{
			ssn.clean()
		}
		
		private function onPublishClick(e:Event):void
		{
			ssn.anime("state.ssn_sending", "发送中,请稍后")
			if (ba)
			{
				WeiboManager.ApiUploadStatus(tx_input.text, ba, 0, 0);
			}
			else
			{
				WeiboManager.ApiUpdateStatus(tx_input.text, 0, 0);
			}
		}
		
		private function onImageClick(e:Event):void
		{
			file.browse([ESFilter.ImageFileFilter]);
		}
		
		private function removeApplicationListener()
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			removeApplicationListener();
		
		}
		
		public function dispose()
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE))
		}
		
		public function applicationMessage(e:Object)
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