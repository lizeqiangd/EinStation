package com.zweisystem.applications.PsychoPass.actives
{
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	import com.greensock.TweenLite;
	import com.sina.microblog.events.MicroBlogEvent;
	import com.zweisystem.abstracts.active.*
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;
	import com.zweisystem.components.banword.SensitiveWordFilter;
	import com.zweisystem.events.ActiveEvent;
	import com.zweisystem.managers.AnimationManager;
	import com.zweisystem.system.proxy.StageProxy;
	import com.zweisystem.animations.texteffect.TextAnimation;
	import flash.events.Event;
	import flash.utils.setTimeout
	
	public class PsychoPassActive extends BaseActive implements iActive
	{
		private var weiboResult:Object = {}
		private var totalStatusesCount:int = 99
		private var pp_arr:Array = []
		
		public function PsychoPassActive()
		{
			super("PsychoPassActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
			tx_title.text = "PSYCHO PASS"
			tx_info.text = ""
			tx_pp.text = ""
			mc_white.visible = false
		}
		
		public function init()
		{
			addUiListener()
			tx_info.text = "Calculating"
			TextAnimation.Changing(tx_info, TextAnimation.ALPHABET, 1, true)
			tx_pp.text = ""
			SinaMicroBlogManager.ApiUserTimeline(null, null, totalStatusesCount + 1, "1")
		
		}
		
		private function onTimelineGet(e:MicroBlogEvent):void
		{
			weiboResult = e.result.statuses
			if (e.result.statuses.length < 99)
			{
				animeOK()
				tx_info.text = "Unknown"
				return
			}
			//trace("onTimelineGet")
			StageProxy.addEnterFrameFunction(doAnime);
		}
		
		private function animeOK():void
		{
			tx_info.visible = true
			if (pp == 0)
			{
				tx_pp.text = "?"
			}
			StageProxy.removeEnterFrameFunction(doAnime);
			if (pp > 200)
			{
				tx_info.text = "Over 200"
				TextAnimation.Changing(tx_info, TextAnimation.ALPHABET, 1, true)
			}
			else if (pp > 150)
			{
				tx_info.text = "Over 150"
				TextAnimation.Changing(tx_info, TextAnimation.ALPHABET, 1, true)
			}
			else if (pp > 110)
			{
				tx_info.text = "Over 110"
				TextAnimation.Changing(tx_info, TextAnimation.ALPHABET, 1, true)
			}
			else if (pp > 50)
			{
				tx_info.text = "Over 50"
				TextAnimation.Changing(tx_info, TextAnimation.ALPHABET, 1, true)
			}
			else if (pp > 20)
			{
				tx_info.text = "Over 20"
				TextAnimation.Changing(tx_info, TextAnimation.ALPHABET, 1, true)
			}
			else if (pp > 1)
			{
				tx_info.text = "Below 20"
				TextAnimation.Changing(tx_info, TextAnimation.ALPHABET, 1, true)
			}
			else
			{
				tx_info.text = "测试失败"
				TextAnimation.Changing(tx_info, TextAnimation.ALPHABET, 1, true)
			}
			TextAnimation.Changing(tx_info, TextAnimation.ALPHABET, 1, true)
			this.getAcitveManager.movein("PsychoColorActive", "p4", "right")
			this.getActive("PsychoColorActive").activeMessage({type: "PsychoPassArray", data: pp_arr})
			host.applicationMessage({type: "PsychoPass", data: pp, array: pp_arr})
			//	AnimationManager.fade_out(mc_white)
		}
		private var i:int = 0
		private var pp:int = 0
		private var animeDelay:Boolean = false
		
		private function doAnime():void
		{
			if (animeDelay)
			{
				animeDelay = !animeDelay
				return
			}
			if (i > totalStatusesCount)
			{
				animeOK()
				return
			}
			var s:String = SensitiveWordFilter.findSensitiveWordsIn(weiboResult[i].text)
			var k:int = s.split("@").length - 1
			k > 10 ? k = 10 : null
			pp_arr.push(k)
			pp += k
			tx_pp.text = String(pp)
			i++
		}
		
		private function addUiListener()
		{
			SinaMicroBlogManager.addEventListener("UserTimeline", onTimelineGet)
		}
		
		private function removeUiListener()
		{
			SinaMicroBlogManager.removeEventListener("UserTimeline", onTimelineGet)
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
			removeUiListener()
			this.removeEventListener(ActiveEvent.IN, onAddToHost)
			this.removeEventListener(ActiveEvent.OUT, onRemoveToHost)
		
		}
	}

}