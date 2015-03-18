package com.lizeqiangd.zweisystem.applications.SinaWeibo.FullScreenGesture
{
	import com.zweisystem.abstracts.windows.FullWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.PositionManager;
	import com.zweisystem.system.applications.background.BackgroundManager;
	import com.zweisystem.system.proxy.StageProxy;
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;
	import flash.display.Sprite;
	import com.zweisystem.managers.AnimationManager;
	import com.zweisystem.events.AnimationEvent;
	import com.zweisystem.applications.SinaWeibo.FullScreenGesture.GestureDisplayStateControlPanel;
	import com.greensock.TweenLite;
	import flash.events.Event;
	public class FullScreenGesture extends FullWindows implements iApplication
	{
		
		public var mc_cp:GestureDisplayStateControlPanel;
		public var mc_statusNameDisplay:StatusUserNameDisplay;
		public var mc_statusContent:StatusContentDisplay;
		public var mc_repostContent:StatusContentDisplay;
		public var mc_repostNameDisplay:RepostUserNameDisplay;
		public var mc_imageDisplay:ImageWeiboDisplay;
		public var mc_repostMark:Sprite;
		private var _dataProvider:Object;
		private var _mode:int = 0;
		private var _isMoving:Boolean = false;
		private var moveAnimeTime:Number = 1.4
		private var moveImageAnimeTime:Number =1.6
		public function FullScreenGesture()
		{
			mc_cp.x = StageProxy.stageWidth;
			mc_cp.y = StageProxy.stageHeight;
			this.setBackgroundControlType=BackgroundManager.blackWithoutText
			this.setBackgroundTitle = "SinaWeiboGestureDisplay 新浪微博手势展示系统(Beta)";
			this.setApplicationName = "SinaWeiboGestureDisplay";
			addUiListener();
		}
		
		public function init(e:ApplicationEvent)
		{
			StageProxy.addResizeFunction(onStageResize);
			mc_cp.init(this);
			_dataProvider = new Object;
			TweenLite.to(mc_statusNameDisplay, moveAnimeTime, {alpha: 0, x: mc_statusNameDisplay.x - 200});
			TweenLite.to(mc_statusContent, moveAnimeTime, {alpha: 0, x: mc_statusContent.x - 200});
			TweenLite.to(mc_repostContent, moveAnimeTime, {alpha: 0, x: mc_repostContent.x - 200});
			TweenLite.to(mc_repostNameDisplay, moveAnimeTime, {alpha: 0, x: mc_repostNameDisplay.x - 200});
			TweenLite.to(mc_repostMark, moveAnimeTime, {alpha: 0, x: mc_repostNameDisplay.x + 200});
			TweenLite.to(mc_imageDisplay, moveAnimeTime, {alpha: 0, x: mc_imageDisplay.x - 200});
			onStageResize();
			dispatchEvent (new ApplicationEvent (ApplicationEvent.INITED))
		}
		
		private function addUiListener()
		{
			mc_imageDisplay.addEventListener(Event.COMPLETE, onImageLoadComplete);
			addEventListener(ApplicationEvent.INIT, init);
			addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			mc_cp.addEventListener(UnitEvent.UNIT_CLOSE, applicationClose);
		}
		
		private function removeUiListener()
		{
			mc_imageDisplay.removeEventListener(Event.COMPLETE, onImageLoadComplete);
			removeEventListener(ApplicationEvent.INIT, init);
			removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			mc_cp.removeEventListener(UnitEvent.UNIT_CLOSE, applicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			removeUiListener();
			removeChild(mc_cp)
			removeChild(mc_statusNameDisplay)
			removeChild(mc_statusContent)
			removeChild(mc_repostContent)
			removeChild(mc_repostNameDisplay)
			removeChild(mc_imageDisplay)
			removeChild(mc_repostMark)
			mc_statusNameDisplay.dispose()
			mc_statusContent.dispose()
			mc_repostContent.dispose()
			mc_repostNameDisplay.dispose()
			mc_imageDisplay.dispose()		
			trace("onApplicationClose")
		}
		
		private function applicationClose(e:UnitEvent)
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE));
		
		}
		
		public function moveRight(e:Object)
		{
			dataProvider = e;
			moveOutRight();
		}
		
		public function moveLeft(e:Object)
		{
			dataProvider = e;
			moveOutLeft();
		}
		
		private function moveOutRight()
		{
			TweenLite.to(mc_statusNameDisplay, moveAnimeTime, {alpha: 0, x: mc_statusNameDisplay.x + 200, onComplete: moveInRight});
			TweenLite.to(mc_statusContent, moveAnimeTime, {alpha: 0, x: mc_statusContent.x + 200});
			TweenLite.to(mc_repostContent, moveAnimeTime, {alpha: 0, x: mc_repostContent.x + 200});
			TweenLite.to(mc_repostNameDisplay, moveAnimeTime, {alpha: 0, x: mc_repostNameDisplay.x + 200});
			TweenLite.to(mc_repostMark, moveAnimeTime, {alpha: 0, x: mc_repostNameDisplay.x + 200});
			TweenLite.to(mc_imageDisplay, moveAnimeTime, {alpha: 0, x: mc_imageDisplay.x + 200});
			_isMoving = true;
		}
		
		private function moveOutLeft()
		{
			TweenLite.to(mc_statusNameDisplay, moveAnimeTime, {alpha: 0, x: mc_statusNameDisplay.x - 200, onComplete: moveInLeft});
			TweenLite.to(mc_statusContent, moveAnimeTime, {alpha: 0, x: mc_statusContent.x - 200});
			TweenLite.to(mc_repostContent, moveAnimeTime, {alpha: 0, x: mc_repostContent.x - 200});
			TweenLite.to(mc_repostNameDisplay, moveAnimeTime, {alpha: 0, x: mc_repostNameDisplay.x - 200});
			TweenLite.to(mc_repostMark, moveAnimeTime, {alpha: 0, x: mc_repostNameDisplay.x + 200});
			TweenLite.to(mc_imageDisplay, moveAnimeTime, {alpha: 0, x: mc_imageDisplay.x - 200});
			_isMoving = true;
		}
		
		private function moveInRight()
		{
			_isMoving = false;
			newPosition();
			_isMoving = true;
			switch (_mode)
			{
				case 1: 
					mc_statusNameDisplay.alpha = 1;
					mc_statusContent.alpha = 1;
					//mc_imageDisplay.alpha = 1;
					mc_statusNameDisplay.dataProvider = _dataProvider;
					mc_statusContent.dataProvider = _dataProvider;
					mc_imageDisplay.dataProvider = _dataProvider;
					TweenLite.from(mc_statusNameDisplay, moveAnimeTime, {alpha: 0, x: mc_statusNameDisplay.x - 200});
					TweenLite.from(mc_statusContent, moveAnimeTime, {alpha: 0, x: mc_statusContent.x - 200, onComplete: endMoving});
					//TweenLite.from( mc_imageDisplay,moveAnimeTime,{alpha:0 ,x:mc_imageDisplay.x-200});
					break;
				case 2: 
					mc_statusNameDisplay.alpha = 1;
					mc_repostContent.alpha = 1;
					mc_repostNameDisplay.alpha = 1;
					mc_statusContent.alpha = 1;
					//mc_imageDisplay.alpha = 1;
					mc_repostMark.alpha = 1;
					mc_statusNameDisplay.dataProvider = _dataProvider;
					mc_statusContent.dataProvider = _dataProvider;
					mc_repostContent.dataProvider = _dataProvider.retweeted_status;
					mc_repostNameDisplay.dataProvider = _dataProvider.retweeted_status;
					mc_imageDisplay.dataProvider = _dataProvider.retweeted_status;
					TweenLite.from(mc_repostMark, moveAnimeTime, {alpha: 0, x: mc_repostMark.x - 200});
					TweenLite.from(mc_statusNameDisplay, moveAnimeTime, {alpha: 0, x: mc_statusNameDisplay.x - 200});
					TweenLite.from(mc_statusContent, moveAnimeTime, {alpha: 0, x: mc_statusContent.x - 200});
					//TweenLite.from( mc_imageDisplay,moveAnimeTime,{alpha:0 ,x:mc_imageDisplay.x-200});
					TweenLite.from(mc_repostContent, moveAnimeTime, {alpha: 0, x: mc_repostContent.x - 200});
					TweenLite.from(mc_repostNameDisplay, moveAnimeTime, {alpha: 0, x: mc_repostNameDisplay.x - 200, onComplete: endMoving});
					break;
				case 3: 
					mc_statusNameDisplay.alpha = 1;
					mc_statusContent.alpha = 1;
					mc_repostContent.alpha = 1;
					mc_repostNameDisplay.alpha = 1;
					mc_repostMark.alpha = 1;
					mc_statusNameDisplay.dataProvider = _dataProvider;
					mc_statusContent.dataProvider = _dataProvider;
					mc_repostContent.dataProvider = _dataProvider.retweeted_status;
					mc_repostNameDisplay.dataProvider = _dataProvider.retweeted_status;
					TweenLite.from(mc_repostMark, moveAnimeTime, {alpha: 0, x: mc_repostMark.x - 200});
					TweenLite.from(mc_statusNameDisplay, moveAnimeTime, {alpha: 0, x: mc_statusNameDisplay.x - 200});
					TweenLite.from(mc_statusContent, moveAnimeTime, {alpha: 0, x: mc_statusContent.x - 200});
					TweenLite.from(mc_repostContent, moveAnimeTime, {alpha: 0, x: mc_repostContent.x - 200});
					TweenLite.from(mc_repostNameDisplay, moveAnimeTime, {alpha: 0, x: mc_repostNameDisplay.x - 200, onComplete: endMoving});
					break;
				case 4: 
					mc_statusNameDisplay.alpha = 1;
					mc_statusContent.alpha = 1;
					mc_statusNameDisplay.dataProvider = _dataProvider;
					mc_statusContent.dataProvider = _dataProvider;
					TweenLite.from(mc_statusNameDisplay, moveAnimeTime, {alpha: 0, x: mc_statusNameDisplay.x - 200});
					TweenLite.from(mc_statusContent, moveAnimeTime, {alpha: 0, x: mc_statusContent.x - 200, onComplete: endMoving});
					break;
				default: 
					break;
			}
		}
		
		private function moveInLeft()
		{
			_isMoving = false;
			newPosition();
			_isMoving = true;
			switch (_mode)
			{
				case 1: 
					mc_statusNameDisplay.alpha = 1;
					mc_statusContent.alpha = 1;
					//mc_imageDisplay.alpha = 1;
					mc_statusNameDisplay.dataProvider = _dataProvider;
					mc_statusContent.dataProvider = _dataProvider;
					mc_imageDisplay.dataProvider = _dataProvider;
					TweenLite.from(mc_statusNameDisplay, moveAnimeTime, {alpha: 0, x: mc_statusNameDisplay.x + 200});
					TweenLite.from(mc_statusContent, moveAnimeTime, {alpha: 0, x: mc_statusContent.x + 200, onComplete: endMoving});
					//TweenLite.from( mc_imageDisplay,moveAnimeTime,{alpha:0 ,x:mc_imageDisplay.x+200});
					break;
				case 2: 
					mc_statusNameDisplay.alpha = 1;
					mc_repostContent.alpha = 1;
					mc_repostNameDisplay.alpha = 1;
					mc_statusContent.alpha = 1;
					//mc_imageDisplay.alpha = 1;
					mc_repostMark.alpha = 1;
					mc_statusNameDisplay.dataProvider = _dataProvider;
					mc_statusContent.dataProvider = _dataProvider;
					mc_repostContent.dataProvider = _dataProvider.retweeted_status;
					mc_repostNameDisplay.dataProvider = _dataProvider.retweeted_status;
					mc_imageDisplay.dataProvider = _dataProvider.retweeted_status;
					TweenLite.from(mc_repostMark, moveAnimeTime, {alpha: 0, x: mc_repostMark.x - 200});
					TweenLite.from(mc_statusNameDisplay, moveAnimeTime, {alpha: 0, x: mc_statusNameDisplay.x + 200});
					TweenLite.from(mc_statusContent, moveAnimeTime, {alpha: 0, x: mc_statusContent.x + 200});
					//TweenLite.from( mc_imageDisplay,moveAnimeTime,{alpha:0 ,x:mc_imageDisplay.x+200});
					TweenLite.from(mc_repostContent, moveAnimeTime, {alpha: 0, x: mc_repostContent.x + 200});
					TweenLite.from(mc_repostNameDisplay, moveAnimeTime, {alpha: 0, x: mc_repostNameDisplay.x + 200, onComplete: endMoving});
					break;
				case 3: 
					mc_statusNameDisplay.alpha = 1;
					mc_statusContent.alpha = 1;
					mc_repostContent.alpha = 1;
					mc_repostNameDisplay.alpha = 1;
					mc_repostMark.alpha = 1;
					mc_statusNameDisplay.dataProvider = _dataProvider;
					mc_statusContent.dataProvider = _dataProvider;
					mc_repostContent.dataProvider = _dataProvider.retweeted_status;
					mc_repostNameDisplay.dataProvider = _dataProvider.retweeted_status;
					TweenLite.from(mc_repostMark, moveAnimeTime, {alpha: 0, x: mc_repostMark.x - 200});
					TweenLite.from(mc_statusNameDisplay, moveAnimeTime, {alpha: 0, x: mc_statusNameDisplay.x + 200});
					TweenLite.from(mc_statusContent, moveAnimeTime, {alpha: 0, x: mc_statusContent.x + 200});
					TweenLite.from(mc_repostContent, moveAnimeTime, {alpha: 0, x: mc_repostContent.x + 200});
					TweenLite.from(mc_repostNameDisplay, moveAnimeTime, {alpha: 0, x: mc_repostNameDisplay.x + 200, onComplete: endMoving});
					break;
				case 4: 
					mc_statusNameDisplay.alpha = 1;
					mc_statusContent.alpha = 1;
					mc_statusNameDisplay.dataProvider = _dataProvider;
					mc_statusContent.dataProvider = _dataProvider;
					TweenLite.from(mc_statusNameDisplay, moveAnimeTime, {alpha: 0, x: mc_statusNameDisplay.x + 200});
					TweenLite.from(mc_statusContent, moveAnimeTime, {alpha: 0, x: mc_statusContent.x + 200, onComplete: endMoving});
					break;
				default: 
					break;
			}
		}
		
		private function endMoving()
		{
			newPosition();
			_isMoving = false;
		/*if (mc_imageDisplay.isLoaded)
		   {
		   onImageLoadComplete(null);
		 }*/
		}
		
		private function onImageLoadComplete(e:Event)
		{
			mc_imageDisplay.alpha = 1;
			TweenLite.killTweensOf(mc_imageDisplay);
			switch (_mode)
			{
				case 1: 
					PositionManager.center(mc_imageDisplay);
					mc_imageDisplay.x = (StageProxy.stageWidth - (mc_statusContent.width + mc_imageDisplay.width + 20)) / 2 + mc_statusContent.width + 10;
					TweenLite.from(mc_imageDisplay, moveImageAnimeTime, {alpha: 0, x: mc_imageDisplay.x + 30});
					break;
				case 2: 
					PositionManager.center(mc_imageDisplay);
					mc_imageDisplay.x = mc_repostMark.width + 10 + (StageProxy.stageWidth - (mc_statusContent.width * 2 + mc_repostMark.width + 20 + mc_imageDisplay.width)) / 2 + mc_statusContent.width + 5 + mc_repostContent.width + 10;
					TweenLite.from(mc_imageDisplay, moveImageAnimeTime, {alpha: 0, x: mc_imageDisplay.x + 30});
					break;
				case 3: 
				case 4: 
					mc_imageDisplay.alpha = 0;
					return;
			}
		}
		
		private function newPosition()
		{
			if (!_isMoving)
			{
				var dx:int = 0;
				switch (_mode)
				{
					case 1: //模式一，有图
						PositionManager.center(mc_statusContent);
						PositionManager.center(mc_imageDisplay);
						dx = (StageProxy.stageWidth - (mc_statusContent.width + mc_imageDisplay.width + 20)) / 2;
						mc_statusContent.x = dx;
						mc_imageDisplay.x = mc_statusContent.x + mc_statusContent.width + 10;
						setStatusNameDisplay();
						break;
					case 2: //模式二 有图有转发
						PositionManager.center(mc_statusContent);
						PositionManager.center(mc_repostContent);
						PositionManager.center(mc_imageDisplay);
						PositionManager.center(mc_repostMark);
						dx = (StageProxy.stageWidth - (mc_statusContent.width * 2 + mc_repostMark.width + 20 + mc_imageDisplay.width)) / 2;
						mc_statusContent.x = dx;
						mc_repostMark.x = 10 + mc_statusContent.x + mc_statusContent.width;
						mc_repostContent.x = mc_repostMark.width + mc_repostMark.x + 5;
						mc_imageDisplay.x = mc_repostContent.x + mc_repostContent.width + 10;
						setStatusNameDisplay();
						setRepostNameDisplay();
						break;
					case 3: //模式三 无图有转发
						PositionManager.center(mc_statusContent);
						PositionManager.center(mc_repostContent);
						PositionManager.center(mc_repostMark);
						dx = (StageProxy.stageWidth - (mc_statusContent.width * 2 + mc_repostMark.width)) / 2;
						mc_statusContent.x = dx;
						mc_repostMark.x = 5 + mc_statusContent.x + mc_statusContent.width;
						mc_repostContent.x = mc_repostMark.width + mc_repostMark.x + 5;
						
						setStatusNameDisplay();
						setRepostNameDisplay();
						break;
					case 4: //模式四 无图无转发
						PositionManager.center(mc_statusContent);
						setStatusNameDisplay();
						break;
					default: 
						break;
				}
			}
		}
		
		private function setStatusNameDisplay()
		{
			//mc_statusNameDisplay.x = mc_statusContent.x - 140;
			//mc_statusNameDisplay.y = mc_statusContent.y - 210;
			mc_statusNameDisplay.x = mc_statusContent.x - 0;
			mc_statusNameDisplay.y = mc_statusContent.y - 125;
		
		}
		
		private function setRepostNameDisplay()
		{
			//mc_repostNameDisplay.x = mc_repostContent.x + 80;
			//mc_repostNameDisplay.y = mc_repostContent.y + 230;
			mc_repostNameDisplay.x = mc_repostContent.x + 18;
			mc_repostNameDisplay.y = mc_repostContent.y - 95;
		}
		
		private function set dataProvider(e:Object)
		{
			_dataProvider = null;
			_dataProvider = new Object;
			_dataProvider = e;
			if (e.bmiddle_pic)
			{
				_mode = 1;
				return;
			}
			if (e.retweeted_status)
			{
				if (e.retweeted_status.bmiddle_pic)
				{
					_mode = 2;
					return;
				}
				_mode = 3;
				return;
			}
			_mode = 4;
			return;
		}
		
		public function dispose()
		{
		}
		
		private function onStageResize()
		{
			mc_cp.x = StageProxy.stageWidth;
			mc_cp.y = StageProxy.stageHeight;
			newPosition();
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