package com.zweisystem.applications.PasscardSystem
{
	import flash.display.Sprite;
	import flash.media.Camera;
	import flash.events.ErrorEvent;
	import com.zweisystem.events.UnitEvent;
	import com.transmote.flar.marker.FLARMarkerEvent;
	import com.transmote.flar.FLARManager;
	import com.transmote.utils.time.FramerateDisplay;
	import com.zweisystem.animations.warning.Error_unAuthorize;
	
	public class PasscardAssest extends Sprite
	{
		// implements iApplication
		private var flarManager:FLARManager;
		private var markerOutliner:MarkerOutliner;
		private var loadXmlAddress:String;
		private var _outputInformation:String;
		private var mc_error:Error_unAuthorize;
		private var largeMode:Boolean = false;
		
		public function PasscardAssest()
		{
			loadXmlAddress = "ar/flarConfigDefault.xml";
			//mc_frameLarge.visible = false;
			init()
		}
		
		public function smallMode()
		{
			loadXmlAddress = "ar/flarConfigSmall.xml";
			largeMode = false;
		}
		
		public function lagreMode()
		{
			largeMode = true;
			loadXmlAddress = "ar/flarConfigLarge.xml";
			//this.setApplicationTitle = "EinStation Passcard System - beta -(LargeMode)";
			//mc_frameLarge.scaleX = mc_frameLarge.scaleY = 1;
			//mc_frameLarge.visible = true;
			//mc_mainframe.visible = false;
			//tx_info.y = 480;
			//tx_info.width = 640;
			//tx_title.width = 640;
			//mc_bg.width = 640;
			//mc_bg.height = 480;
			//mc_title.width = 640;
			//btn_close.x = 620;
		}
		
		public function init(islarge:Boolean = true)
		{
			if (islarge)
			{
				lagreMode();
			}
			else
			{
				smallMode();
			}
			if (!Camera.isSupported)
			{
				ouputInformation = "未找到摄像头，请重新加载程序。";
				return;
			}
			ouputInformation = "等待Passcard识别";
			this.flarManager = new FLARManager(loadXmlAddress);
			addUiListener();
			
			// handle any errors generated during FLARManager initialization.
			
			// add FLARManager.flarSource to the display list to display the video capture.;
			this.addChildAt(Sprite(this.flarManager.flarSource), 0);
			//Sprite(this.flarManager.flarSource).y = 20;
			Sprite(this.flarManager.flarSource).mouseEnabled = false;
			// begin listening for FLARMarkerEvents.
			
			// framerate display helps to keep an eye on performance.;
			var framerateDisplay:FramerateDisplay = new FramerateDisplay();
			//this.addChild(framerateDisplay);
			
			// MarkerOutliner is a simple class that draws an outline
			// around the edge of detected markers.
			this.markerOutliner = new MarkerOutliner();
			markerOutliner.y = 20;
			//this.addChild(this.markerOutliner);
			
			// turn off interactivity in markerOutliner
			this.markerOutliner.mouseChildren = false;
			//this.setChildIndex(mc_bg,0);
		}
		
		public function addUiListener()
		{
			this.flarManager.addEventListener(ErrorEvent.ERROR, this.onFlarManagerError);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_ADDED, this.onMarkerAdded);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
			this.flarManager.addEventListener(FLARMarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);
		
		}
		
		public function removeUiListener()
		{
			this.flarManager.removeEventListener(ErrorEvent.ERROR, this.onFlarManagerError);
			this.flarManager.removeEventListener(FLARMarkerEvent.MARKER_ADDED, this.onMarkerAdded);
			this.flarManager.removeEventListener(FLARMarkerEvent.MARKER_UPDATED, this.onMarkerUpdated);
			this.flarManager.removeEventListener(FLARMarkerEvent.MARKER_REMOVED, this.onMarkerRemoved);
		}
		
		public function applicationClose(e:UnitEvent)
		{
			ouputInformation = "程序关闭中";
			this.removeChild(Sprite(this.flarManager.flarSource));
			flarManager.deactivate();
			removeUiListener();
		}
		
		private function onFlarManagerError(evt:ErrorEvent):void
		{
			removeUiListener();
			//this.flarManager.removeEventListener(ErrorEvent.ERROR, this.onFlarManagerError);
			trace(evt.text);
			//ouputInformation = "请确保没有其他程序使用摄像头。";
			
			mc_error = new Error_unAuthorize;
			this.addChild(mc_error);
			mc_error.tx_text.text = "PasswordSystem Error";
			mc_error.x = 320 - mc_error.width / 2;
			mc_error.y = 240 - mc_error.height / 2;
			ouputInformation = "摄像头出错，请重新加载程序。";
		
		/*
		   mc_error.x = (largeMode ? 320:160)-mc_error.width;
		 mc_error.y = (largeMode ? 240:120)-mc_error.height;*/
			 //flarManager.deactivate()
			 //trace("PasscardSystem Stop");
			 // NOTE: developers can include better feedback to the end user here if desired.
		}
		
		private function onMarkerAdded(evt:FLARMarkerEvent):void
		{
			//trace("["+evt.marker.patternId+"] added");
			
			this.addChild(this.markerOutliner);
			ouputInformation = "找到Pd卡，识别中";
			this.markerOutliner.drawOutlines(evt.marker, 10, this.getColorByPatternId(evt.marker.patternId));
		}
		
		private function onMarkerUpdated(evt:FLARMarkerEvent):void
		{
			//trace("["+evt.marker.patternId+"] updated");
			ouputInformation = "Pd：[" + evt.marker.patternId + "]识别成功。";
			if (evt.marker.patternId == 0)
			{
				ouputInformation = "Pd：[Lizeqiangd]识别成功。";
			}
			if (evt.marker.patternId == 1)
			{
				ouputInformation = "Pd：[深圳大学测试卡]识别成功。";
			}
			this.markerOutliner.drawOutlines(evt.marker, 5, this.getColorByPatternId(evt.marker.patternId));
		}
		
		private function onMarkerRemoved(evt:FLARMarkerEvent):void
		{
			//trace("["+evt.marker.patternId+"] removed");
			this.removeChild(this.markerOutliner);
			ouputInformation = "Pd卡被移除。";
			this.markerOutliner.drawOutlines(evt.marker, 12, this.getColorByPatternId(evt.marker.patternId));
		}
		
		private function getColorByPatternId(patternId:int):Number
		{
			switch (patternId)
			{
				case 0: 
					return 0x47b200;
				case 1: 
					return 0x990000;
				case 2: 
					return 0xFF7F00;
				case 3: 
					return 0xF2F2B2;
				case 4: 
					return 0x47b200;
				case 5: 
					return 0x990000;
				case 6: 
					return 0xFF7F00;
				case 7: 
					return 0xF2F2B2;
				default: 
					return 0x666666;
			}
		}
		
		public function set ouputInformation(e:String)
		{
			//trace(e);
			_outputInformation = e;
			
			this.dispatchEvent(new UnitEvent(UnitEvent.CHANGE, outputInformation));
		}
		
		public function get outputInformation():String
		{
			return _outputInformation;
		}
	}

}