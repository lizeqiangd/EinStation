package com.lizeqiangd.zweisystem.applications.SinaWeibo.Publisher
{
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.abstracts.windows.TitleWindows;
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.ApplicationManager;
	import com.sina.microblog.MicroBlog;
	import com.zweisystem.modules.notification.SystemStatusNotification;
	import com.zweisystem.system.applications.message.Message;
	import flash.events.TextEvent;
	import flash.events.KeyboardEvent;
	import flash.net.FileReference;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.net.FileFilter;
	
	public class DefaultPublisher extends TitleWindows implements iApplication
	{
		private var _mb:MicroBlog;
		private var ssn:SystemStatusNotification;
		private var cheakStatus:String;
		private var file:FileReference;
		private var ba:ByteArray;
		
		public function DefaultPublisher()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "微博发布器";
			this.setApplicationName = "WeiboPublisher";
			this.setMutiExistEnable = false;
			file = new FileReference();
			tx_input.text = "";
			info = "";
			getTextLength();
			addUiListener();
		}
		
		public function init(e:ApplicationEvent)
		{
			btn_submit.title = "发送微博";
			btn_upload.title = "上传图片";
			//btn_upload.enable = false;
			info = "测试用微博发布器";
			
			cheakStatus = "empty";
			ssn = new SystemStatusNotification;
			ssn.init(0, 20, 400, 130);
			addChild(ssn);
			findHostApplication();		
		
			dispatchEvent (new ApplicationEvent (ApplicationEvent.INITED))}
		
		public function addUiListener()
		{
			file.addEventListener(Event.SELECT, onImageSelect);
			file.addEventListener(Event.COMPLETE, onImageComplete);
			btn_submit.addEventListener(UnitEvent.CLICK, onSubmit);
			btn_upload.addEventListener(UnitEvent.CLICK, onUpload);
			tx_input.addEventListener(KeyboardEvent.KEY_DOWN, onTypingHandle);
			tx_input.addEventListener(KeyboardEvent.KEY_UP, onTypingHandle);
			addEventListener(ApplicationEvent.INIT, init);
			addEventListener(ApplicationEvent.CLOSE, applicationClose);
		}
		
		public function removeUiListener()
		{
			file.removeEventListener(Event.SELECT, onImageSelect);
			file.removeEventListener(Event.COMPLETE, onImageComplete);
			btn_submit.removeEventListener(UnitEvent.CLICK, onSubmit);
			btn_upload.removeEventListener(UnitEvent.CLICK, onUpload);
			tx_input.removeEventListener(KeyboardEvent.KEY_DOWN, onTypingHandle);
			tx_input.removeEventListener(KeyboardEvent.KEY_UP, onTypingHandle);
			removeEventListener(ApplicationEvent.INITED, init);
			removeEventListener(ApplicationEvent.CLOSE, applicationClose);
		}
		
		private function applicationClose(e:ApplicationEvent)
		{
			ssn.clean();
			removeUiListener();
		}
		
		public function dispose()
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE))
		}
		
		public function applicationMessage(e:Object)
		{
			switch (e)
			{
				case "complete": 
					cheakStatus = "sent";
					info = "发送成功";
					ssn.clean();
					ba = null;
					break;
				case "app_close": 
					dispose()
				default: 
					break;
			}
		}
		
		private function findHostApplication()
		{
			if (SinaMicroBlogManager.isLogined)
			{
				ssn.clean();
			}
			else
			{
				ssn.anime("warning.Error_hostNotFound");
			}
		}
		
		private function set info(t:String)
		{
			this.tx_info.text = t;
		}
		
		private function onTypingHandle(e:*)
		{
			getTextLength();
		}
		
		private function getTextLength()
		{
			if (tx_input.text.length < 1)
			{
				cheakStatus = "empty";
			}
			if (tx_input.text.length < 141)
			{
				tx_number.text = tx_input.text.length.toString() + "字";
				cheakStatus = "ok";
			}
			else
			{
				tx_number.text = "超出：" + (tx_input.text.length - 140).toString();
				cheakStatus = "tolong";
			}
		}
		
		private function onUpload(e:UnitEvent)
		{
			file.browse([DefaultPublisher.imageFilter]);
		}
		
		private function onImageSelect(e:Event)
		{
			file.load();
		}
		
		private function onImageComplete(e:Event)
		{
			ba = file.data
		}
		
		private function onSubmit(e:UnitEvent)
		{
			switch (cheakStatus)
			{
				case "ok": 
					ssn.anime("state.SendingData");
					info = "发送中。。请稍候";
					break;
				case "empty": 
					info = "写点东西吧。";
					onFaultResult();
					return;
				case "tolong": 
					info = "太长了，请言简意赅";
					onFaultResult();
					return;
				case "sent": 
					info = "请不要重复发送";
					onFaultResult();
					return;
				default: 
					return;
			}
			if (ba)
			{
				ApplicationManager.Application("SinaWeiboMainController").applicationMessage({"message": "您的微博带图发送请求已经发出", "type": "message", "messageType": 0});
				SinaMicroBlogManager.ApiUploadStatus(tx_input.text, ba, 0, 0);
				
			}
			else
			{
				ApplicationManager.Application("SinaWeiboMainController").applicationMessage({"message": "您的微博发送请求已经发出", "type": "message", "messageType": 0});
				SinaMicroBlogManager.ApiUpdateStatus(tx_input.text, 0, 0);
			}
		}
		
		private function onFaultResult(value:Boolean = true)
		{
			if (value)
			{
				Message.SinaWeiboPublishError("微博发送失败，请查看总管理器的问题详细。");
			}
			else
			{
				Message.SinaWeiboPublishError("程序打开失败，请检查微博主程序是否打开并启用。")
			}
		}
		
		public static function get imageFilter():FileFilter
		{
			var imagesFilter:FileFilter = new FileFilter("Images(微博只能发图片哦)", "*.jpg;*.gif;*.png");
			return imagesFilter;
		}
	
	}
}