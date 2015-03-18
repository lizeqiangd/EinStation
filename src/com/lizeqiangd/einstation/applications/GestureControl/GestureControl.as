package com.lizeqiangd.zweisystem.applications.GestureControl
{
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.abstracts.windows.TitleWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.events.UnitEvent;
	import com.nuigesture.NuiGesture;
	import com.nuigesture.event.GestureEvent;
	import com.nuigesture.action.GestureAction;
	import com.zweisystem.managers.AnimationManager;
	import com.as3nui.nativeExtensions.air.kinect.events.UserEvent;
	import com.as3nui.nativeExtensions.air.kinect.events.CameraImageEvent;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	
	public class GestureControl extends TitleWindows implements iApplication
	{
		private var caremaImage:Bitmap;
		
		public function GestureControl()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - GestureControl -";
			this.setApplicationName = "GestureControl";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
		}
		
		public function init(e:ApplicationEvent)
		{
			btn_dispose.title = "卸载";
			btn_start.title = "NuiGesture";
			mc_rect.visible = false;
			btn_dispose.enable = false;
			btn_start.enable = true;
			AnimationManager.fade_out(mc_waiting);
			this.tx_output.text = "";
			caremaImage = new Bitmap(new BitmapData(320, 240));
			caremaImage.visible = false;
			
			this.addChildAt(caremaImage, 0);
			caremaImage.width = 300;
			caremaImage.height = 300;
			caremaImage.x = 0;
			caremaImage.y = 20;
			
			output = "GestureControl初始化完成";
			
			this.setChildIndex(caremaImage,this.numChildren-1)
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function addApplicationListener()
		{
			btn_novideo.addEventListener(UnitEvent.CLICK, onVideoDisplay);
			btn_dispose.addEventListener(UnitEvent.CLICK, onDisposeHandle);
			btn_start.addEventListener(UnitEvent.CLICK, onStartHandle);
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function removeApplicationListener()
		{
			btn_novideo.removeEventListener(UnitEvent.CLICK, onVideoDisplay);
			btn_dispose.removeEventListener(UnitEvent.CLICK, onDisposeHandle);
			btn_start.removeEventListener(UnitEvent.CLICK, onStartHandle);
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			removeApplicationListener();
		
		}
		
		private function onGestureHandle(e:GestureEvent)
		{
			//return 
			var s:String = "";
			s += "[" + e.data.from + "]";
			s += "s:" + e.data.speed;
			s += " d:" + e.data.direction;
			s += " t:" + e.data.type;
			output = s;
			switch (e.data.direction)
			{
				case "right": 
					if (e.data.type == 1)
					{
						mc_rect.visible = true;
						mc_rect.alpha = 0.5;
						mc_rect.width = 50;
						mc_rect.height = 100;
						mc_rect.y = 120;
						mc_rect.x = 250;
						AnimationManager.fade_out(mc_rect);
						return;
					}
					//SoundManager.test();
					mc_rect.visible = true;
					mc_rect.alpha = 0.5;
					mc_rect.width = 50;
					mc_rect.height = 100;
					mc_rect.y = 120;
					mc_rect.x = 200;
					AnimationManager.fade_out(mc_rect);
					break;
				case "left": 
					if (e.data.type == 1)
					{
						mc_rect.visible = true;
						mc_rect.alpha = 0.5;
						mc_rect.width = 50;
						mc_rect.height = 100;
						mc_rect.y = 120;
						mc_rect.x = 0;
						AnimationManager.fade_out(mc_rect);
						return;
					}
					//SoundManager.test2();
					mc_rect.visible = true;
					mc_rect.alpha = 0.5;
					mc_rect.width = 50;
					mc_rect.height = 100;
					mc_rect.y = 120;
					mc_rect.x = 050;
					AnimationManager.fade_out(mc_rect);
					break;
				case "up": 
					if (e.data.type == 1)
					{
						mc_rect.visible = true;
						mc_rect.alpha = 0.5;
						mc_rect.width = 100;
						mc_rect.height = 50;
						mc_rect.y = 20;
						mc_rect.x = 100;
						AnimationManager.fade_out(mc_rect);
						return;
					}
					//SoundManager.volume +=  0.5;
					mc_rect.visible = true;
					mc_rect.alpha = 0.5;
					mc_rect.width = 100;
					mc_rect.height = 50;
					mc_rect.y = 70;
					mc_rect.x = 100;
					AnimationManager.fade_out(mc_rect);
					break;
				case "down": 
					if (e.data.type == 1)
					{
						mc_rect.visible = true;
						mc_rect.alpha = 0.5;
						mc_rect.width = 100;
						mc_rect.height = 50;
						mc_rect.y = 270;
						mc_rect.x = 100;
						AnimationManager.fade_out(mc_rect);
						return;
					}
					//SoundManager.volume -=  0.5;
					mc_rect.visible = true;
					mc_rect.alpha = 0.5;
					mc_rect.width = 100;
					mc_rect.height = 50;
					mc_rect.y = 220;
					mc_rect.x = 100;
					AnimationManager.fade_out(mc_rect);
					break;
				case "in": 
						mc_rect.visible = true;
						mc_rect.alpha = 0.5;
						mc_rect.width = 100;
						mc_rect.height = 100;
						mc_rect.y = 120;
						mc_rect.x = 100;
						AnimationManager.fade_out(mc_rect);
					break;
			
			}
		}
		
		private function set output(s:String)
		{
			this.tx_output.text = s + "\n" + tx_output.text;
		}
		
		private function onStartHandle(e:UnitEvent)
		{
			NuiGesture.NuiAutoStart();
			btn_dispose.enable = true;
			btn_start.enable = false;
			NuiGesture.addEventListener(GestureEvent.GESTURE, onGestureHandle);
			NuiGesture.getKinects(0).addEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, showImage);
			NuiGesture.getKinects(0).addEventListener(UserEvent.USERS_ADDED, onFindUser);
			NuiGesture.getKinects(0).addEventListener(UserEvent.USERS_REMOVED, onFindUser);
			output = "NuiGesture开始,识别用户中。。。";
			caremaImage.visible = true;
			AnimationManager.fade_in(mc_waiting);
		}
		
		private function onFindUser(e:UserEvent)
		{
			if (NuiGesture.getKinects(0).users.length)
			{
				AnimationManager.fade_out(mc_waiting);
				output = "识别到用户";
				mc_rect.visible = true;
				mc_rect.alpha = 0.5;
				mc_rect.width = 100;
				mc_rect.height = 100;
				mc_rect.y = 120;
				mc_rect.x = 100;
				AnimationManager.fade_out(mc_rect);
			}
			else
			{
				output = "用户丢失";
				AnimationManager.fade_in(mc_waiting);
			}
		}
		
		private function showImage(evt:CameraImageEvent):void
		{
			caremaImage.bitmapData = evt.imageData;
		}
		private function onVideoDisplay(evt:UnitEvent ){
			caremaImage.visible =!caremaImage.visible
		}
		private function onDisposeHandle(e:UnitEvent)
		{
			NuiGesture.removeEventListener(GestureEvent.GESTURE, onGestureHandle);
			NuiGesture.getKinects(0).removeEventListener(CameraImageEvent.RGB_IMAGE_UPDATE, showImage);
			NuiGesture.getKinects(0).removeEventListener(UserEvent.USERS_ADDED, onFindUser);
			NuiGesture.getKinects(0).removeEventListener(UserEvent.USERS_REMOVED, onFindUser);
			NuiGesture.dispose();
			AnimationManager.fade_out(mc_rect);
			btn_dispose.enable = false;
			btn_start.enable = true;
			output = "NuiGesture终止，并释放内存解除侦听";
		}
		
		public function dispose()
		{
			onDisposeHandle(null)
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