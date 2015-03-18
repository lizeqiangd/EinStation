package com.lizeqiangd.zweisystem.applications.Hellomet
{
	
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.abstracts.windows.FullWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.managers.PositionManager;
	import com.zweisystem.system.proxy.StageProxy;
	import com.zweisystem.system.applications.background.BackgroundManager;
	import flash.media.Camera;
	import flash.media.Video;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class MainView extends FullWindows implements iApplication
	{
		private var camera:Camera
		private var video:Video
		
		public function MainView()
		{
			this.setDisplayLayer = "backgroundLayer";
			this.setBackgroundTitle = "EinStation Application - MainView -";
			this.setApplicationName = "MainView";
			this.setApplicationVersion = "0"
			this.setBgAlpha = 1
			this.setBackgroundTitle = "Hellomet主视线测试应用"
			//this.setBackgroundTitle = "AConnect单片机通讯程序"
			this.setBackgroundControlType = BackgroundManager.whiteWithoutText
			this.addEventListener(ApplicationEvent.INIT, init);
			StageProxy.addResizeFunction(onStageResize);
			onStageResize()
			btn_close.alpha=0.2
		}
		
		public function init(e:ApplicationEvent)
		{
			addApplicationListener()
			camera = Camera.getCamera()
			
			//camera.setMode(800, 600, 60)
			
			camera.setMode(800, 600, 60)
			video = new Video(1136, 852)
			video.attachCamera(camera)
			//video.rotation = 90
			//video.x = 640
			//video.y = 0
		
			this.addChild(video)
			//stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
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
			dispose()
		}
		
		public function dispose()
		{
			removeApplicationListener();
			StageProxy.removeResizeFunction(onStageResize);
		}
		
		private function onStageResize()
		{
			PositionManager.setDisplayPosition(btn_close, "↙")
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