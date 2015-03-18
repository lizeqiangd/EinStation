package com.zweisystem.applications.PsychoPass
{
	import com.greensock.TweenLite;
	import com.sina.microblog.events.MicroBlogEvent;
	import com.zweisystem.animations.texteffect.TextAnimation;
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.abstracts.windows.TitleWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.managers.AnimationManager;
	import com.zweisystem.modules.imagedisplay.ImageDisplay;
	import com.zweisystem.modules.notification.SystemStatusNotification;
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	
	public class PsychoPassAnalyse extends TitleWindows implements iApplication
	{
		private var uid:String  = ""
		private var psycho_pass:int = 0
		private var mental_color:uint = 0
		private var profile_image_url:String = ""
		private var arr:Array = []
		private var psychoColor:Sprite
		private var psychoArray:Sprite
		private var ssn:SystemStatusNotification
		
		private var avatarIcon:ImageDisplay
		
		public function PsychoPassAnalyse()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "PsychoPassDetailInformation";
			this.setApplicationName = "PsychoPassAnalyse";
			this.setApplicationVersion = "0"
			this.setMutiExistEnable = true
			this.addEventListener(ApplicationEvent.INIT, init);
			this.setBgAlpha = 0.75
			
			txdp_mental_color.title = "精神颜色"
			txdp_gender.title = "性别"
			txdp_description.title = "详细信息"
			txdp_psychopass.title = "犯罪指数"
			tx_id.text = ""
			tx_psychopass.text = ""
			tx_mental_color.text = ""
			tx_gender.text = ""
			tx_description.text = ""
			tx_name.text = ""
			
			ssn = new SystemStatusNotification
			ssn.init(0, 25, 580, 219)
			addChild(ssn)
		}
		
		public function init(e:ApplicationEvent)
		{
			SinaMicroBlogManager.addEventListener("UserShow", onDataReceive)
			SinaMicroBlogManager.ApiUserShow(uid)
			avatarIcon = new ImageDisplay
			avatarIcon.x = 10
			avatarIcon.y = 35
			addChild(avatarIcon)
			avatarIcon.alpha = 0
			
			txdp_mental_color.mouseEnabled = false
			txdp_gender.mouseEnabled = false
			txdp_description.mouseEnabled = false
			txdp_psychopass.mouseEnabled = false
			tx_id.mouseEnabled = false
			tx_psychopass.mouseEnabled = false
			tx_mental_color.mouseEnabled = false
			tx_gender.mouseEnabled = false
			tx_description.mouseEnabled = false
			tx_name.mouseEnabled = false
			
			ssn.anime("state.Pleasewait", "读取信息中")
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function onDataReceive(e:MicroBlogEvent):void
		{
			ssn.clean()
			
			SinaMicroBlogManager.removeEventListener("UserShow", onDataReceive)
			tx_id.text = "ID:" + e.result.province + "-" + e.result.city + "-" + e.result.id
			tx_psychopass.text = psycho_pass.toString()
			tx_mental_color.text = mental_color.toString()
			tx_gender.text = e.result.gender
			tx_description.text = e.result.description
			tx_name.text = e.result.screen_name
			avatarIcon.load(e.result.avatar_large)
			avatarIcon.addEventListener(Event.COMPLETE, onComplete)
			psychoColor = new Sprite
			psychoArray = new Sprite
			psychoColor.x = 10
			psychoColor.y = 216
			psychoArray.mouseEnabled = false
			psychoColor.mouseEnabled = false
			psychoColor.graphics.beginFill(mental_color)
			
			psychoColor.graphics.drawRect(0, 0, 100, 20)
			for (var i:int; i < arr.length; i++)
			{
				psychoArray.graphics.beginFill(0, arr[i] / 5)
				psychoArray.graphics.drawRect(i, 0, 1, 20)
			}
			psychoColor.graphics.endFill()
			psychoColor.addChild(psychoArray)
			this.addChild(psychoColor)
			psychoColor.alpha = 0
			
			TextAnimation.Typing(tx_id)
			TextAnimation.Typing(tx_psychopass)
			TextAnimation.Typing(tx_mental_color)
			TextAnimation.Typing(tx_gender)
			TextAnimation.Typing(tx_description)
			TextAnimation.Typing(tx_name)
		}
		
		private function onComplete(e:Event):void
		{
			AnimationManager.fade_in(avatarIcon)
			
			psychoColor.alpha = 1
			TweenLite.to(psychoColor, 1, {width: 180, overwrite: 3})
		}
		
		private function addApplicationListener()
		{
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
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
			
			uid = e.uid
			mental_color = e.mental_color
			psycho_pass = e.psycho_pass
			arr = e.psycho_pass_array.split("-")
			profile_image_url = e.profile_image_url
		}
	}

}