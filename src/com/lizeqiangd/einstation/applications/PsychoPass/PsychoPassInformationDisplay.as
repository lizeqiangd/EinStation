package com.lizeqiangd.zweisystem.applications.PsychoPass
{
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.sina.microblog.events.MicroBlogEvent;
	import com.zweisystem.abstracts.active.ActiveManager;
	import com.zweisystem.animations.texteffect.TextAnimation;
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;
	import com.zweisystem.components.banword.SensitiveWordFilter;
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.AnimationManager;
	import com.zweisystem.managers.URLNavigateManager;
	import com.zweisystem.system.proxy.StageProxy;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import com.adobe.images.JPGEncoder;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.abstracts.windows.TitleWindows;
	import com.zweisystem.system.applications.message.Message;
	import com.zweisystem.net.AMFPHP;
	
	public class PsychoPassInformationDisplay extends TitleWindows implements iApplication
	{
		private var am:ActiveManager;
		
		public function PsychoPassInformationDisplay()
		{			
			this.setDisplayLayer = "applicationLayer";
			this.setOpeningAnimationType = "popup";
			this.setApplicationVersion="1.0.2"
			this.setApplicationTitle = "PSYCHO-PASS";
			this.setApplicationName = "PsychoPassInformationDisplay";
			btn_submit.title = "发送至微博";
			btn_submit.visible = false;
			am = new ActiveManager(this);
			am.registerPointByActive(active_selfinformation, "p1");
			am.registerPointByActive(active_mentalcolor, "p2");
			am.registerPointByActive(active_psychopass, "p3");
			am.registerPointByActive(active_psychocolor, "p4");
			tx_output.text = "";
			this.addEventListener(ApplicationEvent.INIT, init);
		}
		
		public function init(e:ApplicationEvent)
		{
			addUiListener()
			am.movein("SelfInformationActive", "p1", "right");
			SensitiveWordFilter.regSensitiveWords(SensitiveWordFilter.googleBanList + SensitiveWordFilter.mark + SensitiveWordFilter.negativeList);
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		}
		
		private function addUiListener()
		{
			btn_submit.addEventListener(UnitEvent.CLICK, onSubmit);
			this.addEventListener(ApplicationEvent.CLOSE, applicationClose);
			SinaMicroBlogManager.addEventListener("UploadStatus", onPublished);
		}
		
		private function removeUiListener()
		{
			btn_submit.removeEventListener(UnitEvent.CLICK, onSubmit);
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, applicationClose);
			SinaMicroBlogManager.removeEventListener("UploadStatus", onPublished);
		}
		
		private function applicationClose(e:ApplicationEvent)
		{
			removeUiListener();
		}
		
		private function onPublished(e:*):void
		{
			btn_submit.enable = false;
			tx_output.text = "成功发送至新浪微博";
			TextAnimation.Typing(tx_output);
		}
		
		private function PsychoPassJudgeText():String
		{
			if (PsychoPass > 200)
			{
				return "相当糟糕，建议立刻接受治疗。";
			}
			if (PsychoPass > 150)
			{
				return "比较糟糕，建议您多接受正能量。";
			}
			if (PsychoPass > 110)
			{
				return "不太妙。请不要往更糟糕的方向发展";
			}
			if (PsychoPass > 50)
			{
				return "比较健康，请继续保持。";
			}
			if (PsychoPass > 20)
			{
				return "相当健康。请继续保持。";
			}
			if (PsychoPass > 1)
			{
				return "异常干净。";
			}
			return "无法计算出您的PsychoPass";
		}
		private var PsychoPass:int = 0;
		private var PsychoPassArrayString:String = "";
		private var MentalColor:uint = 0;
		
		public function applicationMessage(e:Object)
		{
			switch (e.type)
			{
				case "MentalColor": 
					MentalColor = e.data;
					break;
				case "PsychoPass": 
					PsychoPass = e.data
					PsychoPassArrayString = e.array.join("-");
					break;
				case "CalculationComplete": 
					AnimationManager.fade_in(btn_submit);
					tx_output.text = "测试结果表明：您的心理状况" + PsychoPassJudgeText()
					if (PsychoPass == 0)
					{
						Message.PsychoPassError(onRetry)
						tx_output.text = "Sibly System Error \n计算过程中出现了问题。";
						TextAnimation.Typing(tx_output);
					}
					else
					{
						Message.PsychoPassOk(PsychoPassJudgeText())
					}
					sendToDatabase();
				default: 
					break;
			}
		}
		
		private function onSubmit(e:UnitEvent)
		{
			mc_title.y = 40;
			tx_title.y = 40;
			mc_title.visible = false;
			tx_title.visible = false;
			btn_submit.visible = false;
			btn_close.visible = false;
			this.mc_frame.visible = false;
			var bitmapData:BitmapData = new BitmapData(650, 460, true, 0);
			bitmapData.draw(this);
			var _encoder:JPGEncoder = new JPGEncoder(96);
			var ba:ByteArray = _encoder.encode(bitmapData);
			var s:String = "通过 SibylSystem 测得 @" + SinaMicroBlogManager.cacheUserData.screen_name + " 的PsychoPass为" + PsychoPass + ".结果为：" + PsychoPassJudgeText() + "   测试地址：http://einstation.sinaapp.com/?app=PSYCHO-PASS @EinStation";
			if (PsychoPass == 0)
			{
				s = "似乎无法通过 SibylSystem 测得 @" + SinaMicroBlogManager.cacheUserData.screen_name + " 的PsychoPass    测试地址：http://einstation.sinaapp.com/?app=PSYCHO-PASS @EinStation";
			}
			SinaMicroBlogManager.ApiUploadStatus(s, ba);
			mc_title.y = 5;
			tx_title.y = 5;
			mc_title.visible = true;
			tx_title.visible = true;
			btn_submit.visible = true;
			btn_close.visible = true;
			this.mc_frame.visible = true;
		}
		
		private function sendToDatabase():void
		{
			var o:Array = [];
			o.push(SinaMicroBlogManager.cacheUserData.screen_name);
			o.push(SinaMicroBlogManager.cacheUserData.id);
			o.push(SinaMicroBlogManager.cacheUserData.profile_image_url);
			o.push(MentalColor);
			o.push(PsychoPass);
			o.push(PsychoPassArrayString);
			if (PsychoPass > 0)
			{
				AMFPHP.callResult("PsychoPassWeiboApplication.createNewResult", onOK, o);
			}
		}
		
		public function dispose()
		{
		}
		
		private function onOK(e:Object):void
		{
			if (e)
			{
				//outputText = "发送成功";
			}
			else
			{
				//outputText = "发送失败";
			}
		}
		
		private function onRetry():void
		{
			URLNavigateManager.open("http://einstation.sinaapp.com/?app=PSYCHO-PASS", true, "_self");
		}
	}

}