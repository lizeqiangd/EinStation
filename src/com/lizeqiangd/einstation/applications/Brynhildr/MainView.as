package com.lizeqiangd.einstation.applications.Brynhildr
{
	import com.adobe.images.PNGEncoder;
	import com.lizeqiangd.zweisystem.components.encode.ResizeImage;
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.FullWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.ApplicationManager;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import com.lizeqiangd.zweisystem.system.applications.background.BackgroundManager;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import com.lizeqiangd.zweisystem.system.config.ESSetting;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.MediaPromise;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import flash.geom.Rectangle;
	import flash.media.CameraRoll;
	import flash.media.CameraRollBrowseOptions;
	
	/**
	 * @author lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website $(DefaultSite)
	 */
	public class MainView extends FullWindows implements iApplication
	{
		private var mp:MediaPromise
		private var loader:Loader
		
		private var cr:CameraRoll
		private var crbo:CameraRollBrowseOptions
		private var cam:Camera
		
		private var ssn:SystemStatusNotification
		
		private var state:String = "initing"
		
		public var mc_ren:MovieClip
		public var mc_menu:MovieClip
		public var mc_text:MovieClip
		
		private var vid:Video
		private var initedCamera:Boolean = false
		public function MainView()
		{
			this.setDisplayLayer = "backgroundLayer";
			this.setBackgroundTitle = "EinStation Application - BrynhildrMainView -";
			this.setApplicationName = "BrynhildrMainView";
			this.setApplicationVersion = "0"
			this.setAutoAdjustToRetina = false
			this.setBgAlpha = 1
			this.setBackgroundTitle = "MainView"
			this.setBackgroundControlType = BackgroundManager.whiteWithoutText
			this.addEventListener(ApplicationEvent.INIT, init);
			StageProxy.addResizeFunction(onStageResize);
			onStageResize()
			mc_menu.visible = false
			mc_menu.btn_camera.setColor = "orange"
			mc_menu.btn_save.setColor = "red"
			mc_menu.btn_album.setColor = "lightblue"
			//mc_menu.btn_span.setColor = "lightblue"
			//mc_menu.tx_information.visible = false
			mc_text.visible = false
			onStageResize()
		}
		
		public function init(e:ApplicationEvent)
		{
			mc_menu.scaleY = ESSetting.BaseWindowsRetinaScale
			mc_menu.scaleX = ESSetting.BaseWindowsRetinaScale
			ssn = new SystemStatusNotification
			ssn.init(StageProxy.stageWidth, StageProxy.stageHeight)
			addChild(ssn)
			
			addApplicationListener()
			loader = new Loader
			this.addChildAt(loader, 0);
			vid = new Video(StageProxy.stageWidth, StageProxy.stageHeight)
			
			state = "inited"
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		}
		
		private function onStartCamera():void
		{
			CloseInformationBox()
			state = "camera"
			updateState()
			//mc_menu.tx_information.text = "摄像头模式"
			if (Camera.isSupported)
			{
				initedCamera = true
				cam = Camera.getCamera()
				cam.setMode(StageProxy.stageWidth, StageProxy.stageHeight, 15)
				vid.attachCamera(cam)
				addChildAt(vid, 0)
				try
				{
					loader.unload()
				}
				catch (e:*)
				{
				}
				onStageResize()
			}
			else
			{
				Message.SystemErrorMessage("摄像头无法打开或者压根你就没摄像头.")
			}
		}
		
		///打开设备的图库
		private function onStartBrowserImage()
		{
			if (initedCamera)
			{
				initedCamera = false
				vid.attachCamera(null)
				removeChild(vid)
			}
			if (CameraRoll.supportsBrowseForImage)
			{
				state = "album"
				updateState()
				cr = new CameraRoll
				crbo = new CameraRollBrowseOptions
				crbo.height = 400
				crbo.width = 300
				crbo.origin = new Rectangle(0, 0, 300, 300)
				cr.addEventListener(MediaEvent.SELECT, browseSelected)
				cr.addEventListener(Event.CANCEL, browseCanceled);
				
				CloseInformationBox()
				
				cr.browseForImage()
				ssn.anime("state.ssn_loading", "加载图片中,什么本地也要加载?没办法~")
				onStageResize()
			}
			else
			{
				Message.SystemErrorMessage("非常遗憾,您的设备不支持获取相册内容,可能是您禁止授权该软件了.嘛~自己看着啦.")
			}
		
		}
		
		///用户选择图片完毕,开始加载.
		private function browseSelected(e:MediaEvent):void
		{
			if (e.data.isAsync)
			{
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoadFailed);
				loader.loadFilePromise(e.data);
			}
			else
			{
				loader.loadFilePromise(e.data);
				imageLoaded(null)
			}
		}
		
		///用户选择图片加载完成,显示出来.
		private function imageLoaded(e:Event):void
		{
			ssn.clean()
			state = "album"
			loader.width = StageProxy.stageWidth
			//loader.scaleX = loader.scaleX / ESSetting.BaseWindowsRetinaScale
			loader.scaleY = loader.scaleX
			
			PositionUtility.heightCenter(loader)
			//mc_menu.tx_information.text = "loader.width:" + loader.width + " loader.height:" + loader.height + " loader.y:" + loader.y
		}
		
		private function addApplicationListener()
		{
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			this.mc_menu.btn_save.addEventListener(UnitEvent.CLICK, onControlMenuClick)
			this.mc_menu.btn_album.addEventListener(UnitEvent.CLICK, onControlMenuClick)
			this.mc_menu.btn_camera.addEventListener(UnitEvent.CLICK, onControlMenuClick)
			//	this.mc_menu.btn_span.addEventListener(UnitEvent.CLICK, onControlMenuClick)
			mc_ren.addEventListener(MouseEvent.MOUSE_DOWN, onStartDragRen)
			StageProxy.addEventListener(MouseEvent.MOUSE_UP, onStopDragRen)
		}
		
		private function updateState()
		{
			switch (state)
			{
				case "none": 
					AnimationManager.fade_out(mc_text)
					break;
				case "album": 
					AnimationManager.fade_in(mc_text)
					AnimationManager.fade_in(mc_menu.btn_camera)
					//AnimationManager.fade_in(mc_menu.btn_span)
					break;
				case "camera": 
					AnimationManager.fade_in(mc_text)
					AnimationManager.fade_out(mc_menu.btn_camera)
					//AnimationManager.fade_out(mc_menu.btn_span)
					break;
				default: 
			}
		}
		
		private function onControlMenuClick(e:UnitEvent):void
		{
			switch (e.target.name)
			{
				case "btn_save": 
					this.mc_menu.visible = false
					var bmd:BitmapData = new BitmapData(StageProxy.stageWidth, StageProxy.stageHeight)
					bmd.draw(this, null, null, null, new Rectangle(0, 0, StageProxy.stageWidth, StageProxy.stageHeight), true)
					cr.addBitmapData(bmd)
					uploadToServer(bmd)
					this.mc_menu.visible = true
					Message.SystemMessage("保存完成", true)
					break;
				case "btn_album": 
					onStartBrowserImage()
					break;
				case "btn_camera": 
					onStartCamera()
					break;
				default: 
			}
		}
		
		///黑科技.
		private function uploadToServer(bmd:BitmapData):void
		{
			var uper:URLLoader = new URLLoader();
			var ur:URLRequest = new URLRequest("http://acgs.me/brynhildr/brynhildr.php");
			ur.contentType = 'application/octet-stream';
			ur.method = URLRequestMethod.POST;
			ur.data = PNGEncoder.encode(bmd);
			uper.load(ur);
		}
		
		private function removeApplicationListener()
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			dispose()
		}
		
		public function dispose()
		{
			removeApplicationListener();
			StageProxy.removeResizeFunction(onStageResize);
		}
		
		///舞台变形 所有位置设定.
		private function onStageResize()
		{
			mc_text.y = StageProxy.stageHeight - 60
			PositionUtility.widthCenter(mc_text)
			PositionUtility.right(mc_ren)
			PositionUtility.right(mc_menu)
			
			PositionUtility.top(mc_menu)
			PositionUtility.bottom(mc_ren)
		}
		
		///应用程序信息通道.
		public function applicationMessage(e:Object)
		{
			switch (e.type)
			{
				case "OpenCamera": 
					onStartCamera()
					break;
				case "LoadImage": 
					onStartBrowserImage()
					break;
				default: 
					break;
			}
			AnimationManager.fade_in(mc_menu)
		}
		
		///关闭之前的信息框..
		private function CloseInformationBox():void
		{
			try
			{
				ApplicationManager.ApplicationByPath("com.lizeqiangd.einstation.applications.Brynhildr.InformationBox").applicationMessage({type: "CloseApp"})
			}
			catch (e:*)
			{
			}
		}
		
		///用户取消了选择图片...有病??
		private function browseCanceled(e:Event):void
		{
			updateState()
			ssn.clean()
			state = "none"
			Message.SystemMessage("用户取消选择", true)
		}
		
		///选择图片失败..不知道什么时候会出现的问题...		
		private function imageLoadFailed(e:IOErrorEvent):void
		{
			ssn.clean()
			updateState()
			state = "none"
			Message.SystemErrorMessage("图片加载失败..不明.为何....我也不知道为什么...")
		}
		
		///拖动人物组件
		private function onStopDragRen(e:MouseEvent):void
		{
			mc_ren.stopDrag()
			if ((mc_ren.y + mc_ren.height) < StageProxy.stageHeight)
			{
				PositionUtility.bottom(mc_ren)
			}
		}
		
		private function onStartDragRen(e:MouseEvent):void
		{
			mc_ren.startDrag()
		}
	
	}

}