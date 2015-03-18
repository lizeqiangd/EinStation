package com.lizeqiangd.zweisystem.system.applications.assest
{
	
	
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;/*
	import com.zweisystem.managers.ApplicationManager;
	import com.greensock.TweenLite;
	import com.zweisystem.managers.LayerManager
	import com.zweisystem.modules.progress.ProgressBar;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import com.zweisystem.managers.AnimationManager;
	*/
	
	/**
	 * 之后重做.
	 */
	public class AssestApplication extends TitleWindows implements iApplication
	{
		
		/*
		public var content:*;
		public var progressBar:ProgressBar;
		public var assestLoader:Loader;
		public var mc_frame:Sprite;
		public var mc_mask:Sprite;
		public var ft_glow:GlowFilter;
		private var applicationUrl:String = "unknown";
		private var contentWidth:Number = 300;
		private var contentHeight:Number = 300;
		
		public function AssestApplication()
		{
			this.setApplicationTitle = "AssestApplication";
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "AssestApplications";
			this.setMutiExistEnable = true;
			this.mc_frame = new Sprite;
			this.mc_mask = new Sprite;
			this.ft_glow = new GlowFilter(0xFF9900, 1, 5, 5, 1, 1);
			this.mc_bg.visible = false;
			addChild(mc_frame);
			addChild(mc_mask);
			drawRect(300, 20);
			progressBar = LayerManager.createPopUp(ProgressBar);
			progressBar.progressTitle = "初始化完成";
			addUiListener();
		}
		
		public function init(e:ApplicationEvent)
		{
			mc_mask.graphics.beginFill(0, 0);
			mc_mask.graphics.drawRect(0, 0, 10, 10);
			mc_mask.x = 1;
			mc_mask.y = 21;		
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
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
		
		public function load(url:String = "test.swf", appTitle:String = "AssestApplication", appName:String = "")
		{
			assestLoader = new Loader();
			assestLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			assestLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
			assestLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			assestLoader.load(new URLRequest(url));
			progressBar.progressTitle = "加载外部程序[" + appName + "]中：";
			this.setApplicationTitle = appTitle;
			this.setApplicationName = appName == "" ? appTitle : appName;
		
		}
		
		private function onProgress(event:ProgressEvent)
		{
			progressBar.progress = event.bytesLoaded / event.bytesTotal;
			//trace(event.bytesLoaded/event.bytesTotal);
		}
		
		private function onComplete(s:Event)
		{
			progressBar.progress = 1;
			content = assestLoader;
			this.addChild(content);
			content.y = 20;
			mc_mask.visible = true;
			content.mask = mc_mask;
			setApplicationSize(assestLoader.contentLoaderInfo.width, assestLoader.contentLoaderInfo.height);
		}
		
		private function onError(s:IOErrorEvent)
		{
			progressBar.progress = 1;
		}
		
		public function reinit()
		{
		}
		
		public function addUiListener()
		{
			btn_color.addEventListener(MouseEvent.CLICK, onSetStageColor);
			addEventListener(ApplicationEvent.INIT, init);
			addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		private var isSetStageColor:Boolean = false;
		
		private function onSetStageColor(e:MouseEvent)
		{
			isSetStageColor = !isSetStageColor;
			if (isSetStageColor)
			{
				AnimationManager.changeColor(mc_bg, assestLoader.content.stage.color);
				mc_bg.alpha = 1;
			}
			else
			{
				AnimationManager.changeColor(mc_bg, 0);
				mc_bg.alpha = 0.65;
			}
			this.setChildIndex(mc_bg, 0);
		}
		
		private function drawRect(w:Number, h:Number)
		{
			mc_frame.graphics.clear();
			mc_frame.graphics.lineStyle(1, 0xFF9900, 1);
			if (h == 20)
			{
				mc_frame.graphics.drawRect(0, 0, w, h);
				mc_frame.filters = [ft_glow];
				return null;
			}
			mc_frame.graphics.drawRect(0, 0, w, h + 20);
			mc_frame.graphics.moveTo(0, 20);
			mc_frame.graphics.lineTo(w, 20);
			mc_frame.graphics.endFill();
			mc_frame.alpha = 0;
			mc_frame.filters = [ft_glow];
		}
		*/
		
		
		public function setApplicationSize(Width:Number = 300, Height:Number = 300)
		{
			contentWidth = Width;
			contentHeight = Height;
			/*TweenLite
			   this.mc_frame.width = Width;
			   this.mc_frame.height = Height + 20;
			   this.mc_bg.width = Width;
			   this.mc_bg.height = Height;
			   this.mc_bg.y = 20;
			   this.mc_bg.visible = true;
			 this.mc_title.width = Width;*/
			
			drawRect(Width, Height);
			TweenLite.to(mc_frame, 1, {alpha: 1});
			TweenLite.to(mc_bg, 1, {autoAlpha: 0.65, width: Width, height: Height});
			TweenLite.to(mc_title, 1, {width: Width});
			TweenLite.to(mc_mask, 1, {width: Width - 2, height: Height - 2});
			this.tx_title.width = Width;
			this.btn_close.x = Width - 20;
			this.btn_close.y = 0;
			this.btn_color.x = Width - 20 - 20;
			this.btn_color.y = 0;
			this.setChildIndex(tx_title, 3);
			this.setChildIndex(mc_frame, 2);
			this.setChildIndex(mc_title, 1);
			this.setChildIndex(mc_bg, 0);
		}
		
		/*private function onApplicationSizeAnimeComplete()
		   {
		   this.mc_frame.width = contentWidth;
		   this.mc_frame.height = contentHeight + 20;
		   this.mc_bg.width = contentWidth;
		   this.mc_bg.height = contentHeight;
		   this.mc_bg.y = 20;
		   this.mc_title.width = contentWidth;
		   mc_mask.width = contentWidth;
		   mc_mask.height = contentHeight;
		   trace("onApplicationSizeAnimeComplete");
		 }*/
		public function removeUiListener()
		{
			btn_color.removeEventListener(MouseEvent.CLICK, onSetStageColor);
			removeEventListener(ApplicationEvent.INIT, init);
			removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			assestLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			assestLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onProgress);
			assestLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
		}
		
		public function onApplicationClose(e:ApplicationEvent)
		{
			dispose()
		
		}
		
		public function dispose()
		{
			try
			{
				removeUiListener();
				assestLoader.unloadAndStop();
			}
			catch (e:*)
			{
			}
			try
			{
				assestLoader.close();
				assestLoader.unload();
			}
			catch (e:*)
			{
				
			}
			try
			{
				progressBar.progress = 1;
				progressBar.dispose();
			}
			catch (e:*)
			{
				
			}
			removeUiListener()
		
		}
		
		public function set ApplicationUrl(s:String)
		{
			applicationUrl = applicationUrl == "" ? s : applicationUrl;
		}
		
		public function get ApplicationUrl():String
		{
			return applicationUrl;
		}
	
	}
}