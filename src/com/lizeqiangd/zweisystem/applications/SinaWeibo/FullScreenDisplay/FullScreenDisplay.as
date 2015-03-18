package com.lizeqiangd.zweisystem.applications.SinaWeibo.FullScreenDisplay
{
	import com.zweisystem.abstracts.windows.FullWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.PositionManager;
	import com.zweisystem.system.applications.background.BackgroundManager;
	import com.zweisystem.system.proxy.StageProxy;
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;
	import com.zweisystem.managers.AnimationManager;
	import com.zweisystem.events.AnimationEvent;
	import flash.utils.setTimeout
	import flash.display.Sprite;
	
	public class FullScreenDisplay extends FullWindows implements iApplication
	{
		public var mc_cp:FullScreenDisplayControlPanel;
		private var mc_status:StatusDisplayer;
		private var mc_repost:RepostDisplayer;
		private var mc_statusDisplay:Sprite;
		private var arr_status:Array;
		private var nowCount:int = 0;
		private var totalDisplayCount:int = 0;
		private var totalStatusCount:int = 0;
		private var sh:int = 120;
		private var rh:int = 220;
		private var w:int = 400;
		private var distant:int = 10;
		
		public function FullScreenDisplay()
		{
			mc_cp.x = StageProxy.stageWidth;
			mc_cp.y = StageProxy.stageHeight;
			this.setBackgroundTitle = "SinaWeiboDisplay 新浪微博展示系统";
			this.setApplicationName = "SinaWeiboFullScreenDisplay";
			this.setBackgroundControlType=BackgroundManager.blackWithoutText
			addUiListener();
		}
		
		public function init(e:ApplicationEvent)
		{
			mc_cp.fullScreenDisplay = this;
			mc_statusDisplay = new Sprite;
			mc_statusDisplay.y = 20 + distant;
			this.addChild(mc_statusDisplay);
			arr_status = new Array;
			onStageResize();
			StageProxy.addResizeFunction(onStageResize);
			dispatchEvent(new ApplicationEvent (ApplicationEvent.INITED))
		}
		
		private function addUiListener()
		{
			mc_cp.addEventListener(UnitEvent.UNIT_CLOSE, applicationClose);
			addEventListener(ApplicationEvent.INIT, init);
			addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function removeUiListener()
		{
			mc_cp.removeEventListener(UnitEvent.UNIT_CLOSE, applicationClose);
			removeEventListener(ApplicationEvent.INIT, init);
			removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			removeChildren()
			mc_status = null
			mc_statusDisplay = null
			mc_repost = null
			removeUiListener();
			mc_statusDisplay.removeChildren();
			arr_status = [];
		}
		
		private function applicationClose(e:UnitEvent)
		{dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE))
		}
		
		//外部调用开始;
		public function showStatus()
		{
			nowCount = 0;
			totalDisplayCount = 0;
			totalStatusCount = 0;
			arr_status = null;
			arr_status = new Array;
			totalStatusCount = SinaMicroBlogManager.cacheFriendsTimeline.length;
			cleanStatus(onStatusDisplayFadeout);
		} //清理屏幕
		
		private function cleanStatus(func:Function)
		{
			mc_statusDisplay.addEventListener(AnimationEvent.COMPLETE, cleaned);
			AnimationManager.fade_out(mc_statusDisplay);
			function cleaned(e:AnimationEvent)
			{
				mc_statusDisplay.visible = true;
				mc_statusDisplay.alpha = 1;
				mc_statusDisplay.removeEventListener(AnimationEvent.COMPLETE, cleaned);
				mc_statusDisplay.removeChildren();
				//trace("消失动画完成");
				func();
			}
		} //清理屏幕结束，还是导入数据
		
		private function onStatusDisplayFadeout()
		{
			//trace("onStatusDisplayFadeout");
			for (var i:int = 0; i < totalStatusCount; i++)
			{
				if (SinaMicroBlogManager.cacheFriendsTimeline[i].retweeted_status)
				{
					//trace("增加新微博：",i,"retweeted");
					mc_repost = new RepostDisplayer;
					mc_repost.dataProvider = SinaMicroBlogManager.cacheFriendsTimeline[i];
					arr_status.push(mc_repost);
				}
				else
				{
					//trace("增加新微博：",i,"status");
					mc_status = new StatusDisplayer;
					mc_status.dataProvider = SinaMicroBlogManager.cacheFriendsTimeline[i];
					arr_status.push(mc_status);
				}
			}
			//导入结束，开始排列数据
			//trace("导入结束，开始排列数据");
			onSafeTimerHandle();
		}
		
		private function startDisplayingStatus()
		{
			//trace("开始排列数据");
			var nowRow:int = 0;
			var nowH:int = 0;
			var limitRow:int = Math.floor(StageProxy.stageWidth / w);
			var distant_width:int = (StageProxy.stageWidth - limitRow * w) / (limitRow - 1) - 1;
			totalDisplayCount = 0;
			for (var i:int = 0; i < arr_status.length; i++)
			{
				if (arr_status[i] is StatusDisplayer)
				{
					if ((nowH + sh) > (StageProxy.stageHeight - 30))
					{
						nowRow++;
						nowH = 0;
					}
					if (nowRow + 1 > limitRow)
					{
						break;
					}
					arr_status[i].x = nowRow * (w + distant_width);
					arr_status[i].y = nowH;
					nowH += sh + distant;
					totalDisplayCount++;
				}
				if (arr_status[i] is RepostDisplayer)
				{
					if ((nowH + rh) > (StageProxy.stageHeight - 30))
					{
						nowRow++;
						nowH = 0;
					}
					if (nowRow + 1 > limitRow)
					{
						
						break;
					}
					arr_status[i].x = nowRow * (w + distant_width);
					arr_status[i].y = nowH;
					nowH += rh + distant;
					totalDisplayCount++;
				}
					//trace("arr_status.length:"+arr_status.length+" i:"+i+" nowRow:"+nowRow+" nowRowStart:"+nowRow * (w + distant_width) +" nowH:"+nowH+" limitRow:"+limitRow+" distant_width:"+distant_width);
			}
			//trace("到达排列极限");
			StageProxy.addEnterFrameFunction(onEnterFrameFunction);
		}
		
		private function onEnterFrameFunction()
		{
			
			if (totalDisplayCount == 0)
			{
				//trace("没有要显示的");
				StageProxy.removeEnterFrameFunction(onEnterFrameFunction);
				return;
			}
			//trace("显示新微博："+nowCount);
			mc_statusDisplay.addChild(arr_status[nowCount]);
			AnimationManager.fade_in(arr_status[nowCount]);
			arr_status[nowCount].init();
			nowCount++;
			if (nowCount > (totalDisplayCount - 1))
			{
				//trace("显示完成："+nowCount);
				nowCount = 0;
				StageProxy.removeEnterFrameFunction(onEnterFrameFunction);
			}
		}
		
		private function onStageResize()
		{
			mc_cp.x = StageProxy.stageWidth;
			mc_cp.y = StageProxy.stageHeight;
			setTimeout(onSafeTimerHandle, 200)
		}
		
		private function onSafeTimerHandle()
		{ //开始排列数据			
			cleanStatus(startDisplayingStatus);
		}
		
		public function dispose()
		{
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