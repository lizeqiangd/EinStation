package com.lizeqiangd.zweisystem.system.applications.background
{
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.BaseWindows
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.VideoEvent;
	import com.lizeqiangd.zweisystem.modules.imagedisplay.ImageDisplay;
	import com.lizeqiangd.zweisystem.modules.imagedisplay.MutilImageDisplay
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.events.NetEvent;
	import com.lizeqiangd.zweisystem.data.image.Image;
	import com.lizeqiangd.zweisystem.modules.videodisplay.VideoDisplay;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import com.lizeqiangd.zweisystem.interfaces.label.la_general;
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.display.Shape;
	import com.junkbyte.console.Cc;
	
	/**
	 * 本系统应用为背景图片显示应用.
	 * 2012.12.28 优化了背景图片管理器。配合FullWindows做了修改
	 * 2013.02.08 全面重做
	 * 2013.09.07 服务器控制的单一图片背景
	 * 2014.03.31 全面更新注释文档,删除无用方法,精简处理.
	 * 2014.04.07 debug完成.
	 * 2014.06.07 增加视频背景功能.
	 * 2015.03.19 考虑重构
	 * lizeqiangd
	 */
	public class BackGround extends BaseWindows implements iApplication
	{
		
		///background 的状态识别符
		public var state:String = "init";
		
		private var image:Image
		private var _loader:MutilImageDisplay;
		private var blackScene:Shape;
		private var la_info:la_general;
		
		private var video:VideoDisplay
		
		private var info_lock:Boolean = false
		
		/**
		 * 构造函数,用于基本设置本应用.
		 */
		public function BackGround()
		{
			this.setDisplayLayer = "backgroundLayer";
			this.setApplicationName = "BackgroundImage";
			this.setAutoAdjustToRetina = false
			this.setFocusAble = false
			this.setMutiExistEnable = false
			
			addEventListener(ApplicationEvent.OPENED, init)
		}
		
		/**
		 * 初始化程序,仅仅是初始化完成而已,加载图片需要外部调入.
		 * @param	e ApplicationEvent
		 */
		public function init(e:ApplicationEvent):void
		{
			removeEventListener(ApplicationEvent.OPENED, init)
			Cc.log("BackGround:initing...");
			
			blackScene = new Shape;
			
			blackScene.graphics.beginFill(0x000000, 0.5);
			blackScene.graphics.drawRect(0, 0, 10, 10);
			blackScene.graphics.endFill();
			_loader = new MutilImageDisplay;
			_loader.addEventListener(Event.COMPLETE, onLoadComplete);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.addEventListener(NetEvent.PROGRESSING, onProgress);
			_loader.config(1920, 1080, ImageDisplay.none)
			la_info = new la_general
			video = new VideoDisplay
			video.init(1920, 1080)
			video.addEventListener(VideoEvent.PLAY_COMPLETE, onVideoPlayComplete)
			video.addEventListener(VideoEvent.PLAY_START, onLoadComplete)
			setDescription("初始化完成...")
			
			this.addChild(la_info);
			this.addChildAt(blackScene, 0);
			this.addChildAt(video, 0);
			this.addChildAt(_loader, 0);
			state = "inited";
			StageProxy.addResizeFunction(onStageResize);
			onStageResize();
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		
			//trace("scaleX",this.scaleX)
		}
		
		/**
		 * 当视频播放完成..
		 * @param	e
		 */
		private function onVideoPlayComplete(e:VideoEvent):void
		{
			//	trace("BackGround:VideoPlayComplete")
			dispatchEvent(new VideoEvent(VideoEvent.PLAY_COMPLETE))
		}
		
		/**
		 * Progress Event
		 * @param	e
		 */
		private function onProgress(e:NetEvent):void
		{
			setDescription("Loading Image:" + Math.round(e.data * 100) + "%", false);
		}
		
		/**
		 * Loading Error  修正后重新加载即可.
		 * @param	e
		 */
		private function onIOError(e:IOErrorEvent):void
		{
			state = "error";
			setDescription("背景图片加载失败,不会影响正常使用.")
			Cc.error(("BackGround.onIOError:Image load fault! url:", image.url));
		}
		
		/**
		 * 读取完成时候,由其他地方通知切换出图片.
		 * @param	e
		 */
		private function onLoadComplete(e:*):void
		{
			//dispatchEvent(e)
			applicationMessage({type: "complete"});
			onStageResize();
		}
		
		/**
		 * 设置底部介绍文字的内容.会自动激活动画
		 * e:设置的内容   needAnime:是否激活typing动画效果.
		 */
		private function setDescription(e:String, needAnime:Boolean = true):void
		{
			if (info_lock)
			{
				return
			}
			la_info.title = e
			PositionUtility.setDisplayPosition(la_info, "BR");
			//needAnime ? la_info.startTyping() : null
		}
		
		/**
		 * 开始读取图片.
		 */
		private function loadingImage():void
		{
			_loader.load(image.url)
		}
		
		/**
		 * 开始读取视频
		 */
		private function loadingVideo():void
		{
			video.stopStream()
			video.loadVideo(image.url)
		}
		
		/**
		 * 重新定位各部件应用位置.
		 */
		private function onStageResize():void
		{
			this.x = 0
			this.y = 0
			blackScene.width = StageProxy.stageWidth;
			blackScene.height = StageProxy.stageHeight;
			
			PositionUtility.setDisplayPosition(_loader, "");
			PositionUtility.setDisplayPosition(video, "");
			PositionUtility.setDisplayPosition(la_info, "BR");
			
			this.setChildIndex(_loader, 0);
			this.setChildIndex(video, 1);
			this.setChildIndex(blackScene, 2);
			this.setChildIndex(la_info, 3);
		}
		
		/**
		 * 应用程序消息通道.默认舞台是黑色的.
		 * @param	e
		 */
		public function applicationMessage(e:Object):void
		{
			switch (e.type)
			{
				case "recover": 
				case "complete": 
					if (state == "video")
					{
						setDescription(image.description)
						AnimationManager.fade_out(_loader);
						AnimationManager.fade_out(blackScene);
						AnimationManager.fade_in(la_info);
						AnimationManager.fade_in(video);
					}
					else
					{
						setDescription(image.description)
						AnimationManager.fade_in(_loader);
						AnimationManager.fade_in(la_info);
						AnimationManager.fade_out(blackScene);
						AnimationManager.fade_out(video);
					}
					break;
				case "blackWithoutText": 
					AnimationManager.fade_in(blackScene);
					AnimationManager.fade_out(la_info);
					AnimationManager.fade_out(_loader);
					AnimationManager.fade_out(video);
					break;
				case "black": 
					setDescription("Image Removed");
					AnimationManager.fade_in(la_info);
					AnimationManager.fade_in(blackScene);
					AnimationManager.fade_out(_loader);
					AnimationManager.fade_out(video);
					break;
				case "whiteWithoutText": 
					AnimationManager.fade_out(blackScene);
					AnimationManager.fade_out(la_info);
					AnimationManager.fade_out(_loader);
					AnimationManager.fade_out(video);
					break;
				case "white": 
					setDescription("Image Removed");
					AnimationManager.fade_in(la_info);
					AnimationManager.fade_out(_loader);
					AnimationManager.fade_out(blackScene);
					AnimationManager.fade_out(video);
					break;
				case "remote": 
					this.image = e.image
					state = "loading";
					///视频模式
					if (image.url.match(".mp4"))
					{
						state = "video"
						//setDescription("Loading Video......", false)
						loadingVideo()
					}
					else
					{
						state = "image"
						setDescription("Remoting Image", false)
						loadingImage()
					}
					break;				
				case "infolock": 
					setDescription(e.info)
					info_lock = e.lock
					break
				default: 
					break
			}
		}
		
		/**
		 * 销毁本类,目前来看没有什么机会用到.
		 */
		public function dispose():void
		{
			_loader.removeEventListener(Event.COMPLETE, onLoadComplete);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
			_loader.removeEventListener(NetEvent.PROGRESSING, onProgress);
			
			StageProxy.removeResizeFunction(onStageResize);
			removeChildren()
			_loader.dispose()
		}
	}
}