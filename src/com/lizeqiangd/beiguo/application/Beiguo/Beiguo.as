package com.lizeqiangd.beiguo.application.Beiguo
{
	import com.adobe.images.PNGEncoder;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.UserEvent;
	import com.as3nui.nativeExtensions.air.kinect.Kinect;
	import com.as3nui.nativeExtensions.air.kinect.KinectSettings
	import com.greensock.easing.Circ;
	import com.greensock.TweenLite;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * @author Lizeqiangd
	 * @email $(DefaultEmail)
	 * @website $(DefaultSite)
	 */
	public class Beiguo extends TitleWindows implements iApplication
	{
		public function Beiguo()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - Beiguo -";
			this.setApplicationName = "Beiguo";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
		}
		
		public function init(e:ApplicationEvent)
		{
			StartKinect()
			btn_start.addEventListener(UnitEvent.CLICK, StartGuoGame)
			
			//StartGuoGame()
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		private var depthBitmap:Bitmap;
		private var rgbBitmap:Bitmap;
		private var userBitmap:Bitmap
		private var device:Kinect;
		
		public function StartKinect()
		{
			if (Kinect.isSupported())
			{
				device = Kinect.getDevice();
				depthBitmap = new Bitmap();
				rgbBitmap = new Bitmap();
				userBitmap = new Bitmap();
				//userSprite = new Sprite()
				//	userSprite.width = 800
				//	userSprite.height = 600
				//userSprite.addChild(userBitmap)
				//addChild(depthBitmap);
				//addChild(rgbBitmap);
				//addChild(userSprite)
				addChild(userBitmap)
				device.addEventListener(CameraImageEvent.DEPTH_IMAGE_UPDATE, depthImageUpdateHandler);
				device.addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, rgbImageUpdateHandler)
				device.addEventListener(UserEvent.USERS_MASK_IMAGE_UPDATE, UserMaskImageUpdateHandler)
				var settings:KinectSettings = new KinectSettings();
				settings.depthResolution = new Point(640, 480)
				settings.userMaskResolution = new Point(640, 480)
				settings.rgbEnabled = true
				settings.userMaskEnabled = true
				settings.depthEnabled = true;
				device.start(settings);
				userBitmap.y = 200
					//userBitmap.width = 800
					//userBitmap.height = 600
				
					//	userSprite.y = 20
					//rgbBitmap.x = 640
					//rgbBitmap.y = depthBitmap.y = userBitmap.y = 20
			}
		
		}
		private var guo:Guo
		private var fallTime:Number = 2.2
		private var gameTime:uint = 20
		private var diffcult:Array = [5, 7, 9, 12, 15, 20]
		private var gameLevel:int = 0
		private var gameStartTime:int = 0
		private var guoFallTimeArray:Array = []
		private var lastguo:Boolean = false
		
		private function StartGuoGame(e:UnitEvent):void
		{
			TweenLite.to(btn_start, 1, {y: btn_start.y - 200, alpha: 0, onComplete: onGameStart})
		}
		
		private function onGameStart():void
		{
			guoHitArray = []
			guoArray = []
			removeChild(btn_start)
			guoFallTimeArray = new Array
			gameLevel = 1
			gameStartTime = getTimer()
			StageProxy.addEnterFrameFunction(gameEnterFrame)
			guoFallTimeArray = [1000, 3520, 5421, 8545, 12354]
		}
		private var guoArray:Array = []
		
		private function gameEnterFrame():void
		{
			if ((getTimer() - gameStartTime) > guoFallTimeArray[0] && !lastguo)
			{
				guoFallTimeArray.shift()
				guo = new Guo()
				guo.x = (800 - guo.width) * Math.random()
				guo.y = 20
				addChild(guo)
				TweenLite.to(guo, fallTime, {y: 600, ease: Circ.easeIn, onComplete: removeGuo, onCompleteParams: [guo]});
				
				if (guoFallTimeArray.length == 0)
				{
					lastguo = true
				}
				guoArray.push(guo)
			}
			for (var i:int = 0; i < guoArray.length; i++)
			{
				if (pixelLevelHitTestNoAlpha(userBitmap, guoArray[i]) && !guo.isGet)
				{
					guo.isGet = true
					var hitguo:Guo = new Guo
					addChild(hitguo)
					guoHitArray.push(hitguo)
					TweenLite.to(guo, 0.5, {alpha: 0, ease: Circ.easeIn, onComplete: removeGuo, onCompleteParams: [guo]});
				}
			}
			for (i = 0; i < guoHitArray.length; i++)
			{
				guoHitArray[i].x = device.users[0].head.position.rgb.x*800/640 + 10 * (Math.random() - 0.5) - guo.width / 2
				guoHitArray[i].y = device.users[0].head.position.rgb.y*600/480 +200+ 10 * (Math.random() - 0.5) - guo.height / 2
			}
		}
		
		private var guoHitArray:Array = []
		
		private function removeGuo(e:Guo):void
		{
			guoArray.shift()
			try
			{
				removeChild(e)
			}
			catch (e:*)
			{
			}
			if (lastguo)
			{
				gameoverhandle()
			}
		}
		
		private function gameoverhandle():void
		{
			StageProxy.removeEnterFrameFunction(gameEnterFrame)
			addChild(btn_start)
			TweenLite.to(btn_start, 1, {y: btn_start.y + 200, alpha: 1})
			
			for (var i:int = 0; i < guoHitArray.length; i++)
			{
				TweenLite.to(guoHitArray[i], 1, {x: 20 + (20 + 150) * i, y: 30, delay: i})
				
			}
		
		}
		private var userSprite:Sprite
		
		private function UserMaskImageUpdateHandler(e:UserEvent):void
		{ //trace("123")
			//var png:PNGEncoder=new PNGEncoder
			
			//var f:FileReference = new FileReference
			//f.save(PNGEncoder.encode( e.users[0].userMaskData))
			
			userBitmap.bitmapData = e.users[0].userMaskData
			userBitmap.width = 800
			userBitmap.height = 600
			//trace(userBitmap.width)
			//trace(userBitmap.height)
			//userBitmap
			//temp.graphics.clear()
			//temp.graphics.lineStyle(1, 0)
			//temp.graphics.drawRect(.x,userBitmap.getRect(.y,userBitmap.getRect().width,userBitmap.getRect().height)
		}
		
		public function pixelLevelHitTestNoAlpha(source1:Bitmap, source2:DisplayObject):Boolean
		{
			if (source1.width == 0)
			{
				return false
			}
			var source1BitmapData:BitmapData = new BitmapData(source1.width, source1.height, true, 0x00000000);
			//	var source1BitmapData:BitmapData = source1
			var source2BitmapData:BitmapData = new BitmapData(source2.width, source2.height, true, 0x00000000);
			
			var colorTransform:ColorTransform = new ColorTransform();
			colorTransform.color = 0xff0000;
			source1BitmapData.draw(source1, null, colorTransform);
			colorTransform.color = 0x00ff00;
			source2BitmapData.draw(source2, null, colorTransform);
			
			var temp1:int = source1.x + source1.width;
			var temp2:int = source2.x + source2.width;
			var width:int = temp1 > temp2 ? temp1 : temp2;
			temp1 = source1.y + source1.height;
			temp1 = source2.y + source2.height;
			var height:int = temp1 > temp2 ? temp1 : temp2;
			
			var hitTestBitmapData:BitmapData = new BitmapData(width, height, true, 0xff000000);
			hitTestBitmapData.copyChannel(source1BitmapData, source1BitmapData.rect, new Point(source1.x, source1.y), BitmapDataChannel.RED, BitmapDataChannel.RED);
			hitTestBitmapData.copyChannel(source2BitmapData, source2BitmapData.rect, new Point(source2.x, source2.y), BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
			
			var resultRect:Rectangle = hitTestBitmapData.getColorBoundsRect(0xffffff00, 0xffffff00);
			if (resultRect.width > 0 || resultRect.height > 0)
				return true;
			return false;
		}
		
		private function rgbImageUpdateHandler(e:CameraImageEvent):void
		{
		
			//rgbBitmap.bitmapData = e.imageData;
		}
		
		protected function depthImageUpdateHandler(event:CameraImageEvent):void
		{
			//depthBitmap.bitmapData = event.imageData;
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