package com.lizeqiangd.einstation.applications.BilibiliNetTest
{
	import com.junkbyte.console.Cc;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.manager.HostManager;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * @author Lizeqiangd
	 * EinStation Special Edition for bilibili video test
	 * 20141027:ver 1 complete
	 */
	
	public class BilibiliNetTest extends TitleWindows implements iApplication
	{
		public function BilibiliNetTest()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - BilibiliNetTest -";
			this.setApplicationName = "BilibiliNetTest";
			this.setApplicationVersion = "0"
			this.addEventListener(ApplicationEvent.INIT, init);
			//this.setDragEnable = false
			setBgAlpha = 0.8
			clearOutput()
		}
		
		private function clearOutput():void
		{
			tx_ip.text = ""
			tx_carrier.text = ""
			tx_geolocation.text = ""
			tx_nodename.text = ""
			tx_videotype.text = ""
			tx_nodeaddress.text = "无法获取"
			tx_loadtime.text = ""
			tx_loadspeed.text = ""
			tx_seekspeed.text = ""
			tx_avid.text = ""
		}
		private var urlloader:URLLoader = new URLLoader
		private var cdn_image_loader:Loader = new Loader
		private var ns:NetStream
		private var nc:NetConnection
		private var video:Video
		private var userIp:URLLoader = new URLLoader
		private var videoinfo:URLLoader = new URLLoader
		private var video2info:URLLoader = new URLLoader
		
		public function init(e:ApplicationEvent)
		{
			
			video = new Video(210, 118.1)
			video.x = 30
			video.y = 275.5
			this.addChild(video)
			
			nc = new NetConnection()
			nc.connect(null)
			ns = new NetStream(nc)
			video.attachNetStream(ns)
			ns.bufferTimeMax = 5
			//NetStream.inBufferSeek =true
			Cc.fatal(lastinfo)
			
			ti_av.text = ""
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		public function onSubmit(e:Event)
		{
			
		}
		
		private function videoinfoComplete(e:Event):void
		{
			//var xml:XML = e.target.data
			//xml.
			//trace(e.target.data)
			
		}
		
		private function videoinfo2Complete(e:Event):void
		{
			var xml:XML = new XML(e.target.data)
			tx_videotype.text = "" + xml.format
			var temp:String = xml.durl.url
			//var temp:String = "http://cn-sx1-dx.acgvideo.com/3/16/2524064-1.flv?expires=1414423500&ssig=eu1SegvyOIS8C-PPGUS3HQ&o=1961346161&rate=64000"
			state = "load"
			seekTimes = 0
			startLoadTimer = getTimer()
			ns.play(temp)
			ns.client = {onMetaData: function(e:*)
				{
					
					if (state == "load")
					{
						lastinfo.push(ns.info)
						Cc.log(lastinfo[lastinfo.length - 1])
						finishLoadTimer = getTimer()
						tx_loadtime.text = String(finishLoadTimer - startLoadTimer) + "ms"
						speedTimer.start()
						tx_seekspeed.text = "等待10秒速度测试完成"
					}
					if (state == "seek")
					{
						finishLoadTimer = getTimer()
						tx_seekspeed.appendText(String(finishLoadTimer - startLoadTimer) + "ms  ")
						timeoutFunc = setTimeout(autoSeek, 2000)
					}
				}}
		}
		
		private function autoSeek():void
		{
			trace("autoSeek kick")
			tx_seekspeed.text = ""
			seekTimes++
			state = "seek"
			ns.seek(60 * seekTimes)
			
			startLoadTimer = getTimer()
			if (seekTimes > 3)
			{
				clearTimeout(timeoutFunc)
			}
		}
		private var state:String = "load"
		private var startLoadTimer:uint = 0
		private var finishLoadTimer:uint = 0
		private var seekTimes:uint = 0
		private var timeoutFunc:uint = 0
		
		private function userIpConplete(e:Event):void
		{
			tx_ip.text = String(e.target.data + "")
			TextAnimation.Typing(tx_ip)
		}
		
		private function onCDNImageComplete(e:Event):void
		{
			cdn_image_loader.x = 100
			cdn_image_loader.y = 205
			addChild(cdn_image_loader)
		}
		
		private var lastinfo:Array = []
		
		private function onTraceInfo(e:SecurityErrorEvent):void
		{
			lastinfo.push(e)
			Cc.visible = true
			Cc.error(e)
			Message.SystemErrorMessage("无法读取信息,请检查输入的视频地址是否复制完全,或者该av号是否存在")
		}
		
		private function onUserInformationComplete(e:Event)
		{
			var o:Object = JSON.parse(urlloader.data)
			tx_carrier.text = o.isp
			tx_geolocation.text = o.country + o.province + o.district
			TextAnimation.Changing(tx_geolocation, TextAnimation.CHINESE)
			TextAnimation.Changing(tx_carrier, TextAnimation.CHINESE)
		
		}
		
		private function addApplicationListener()
		{
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			btn_submit.addEventListener(UnitEvent.CLICK, onSubmit)
			ti_av.addEventListener(UnitEvent.SUBMIT, onSubmit)
			
			video2info.addEventListener(Event.COMPLETE, videoinfo2Complete)
			video2info.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onTraceInfo)
			videoinfo.addEventListener(Event.COMPLETE, videoinfoComplete)
			videoinfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onTraceInfo)
			urlloader.addEventListener(Event.COMPLETE, onUserInformationComplete)
			urlloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onTraceInfo)
			userIp.addEventListener(Event.COMPLETE, userIpConplete)
			userIp.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onTraceInfo)
			cdn_image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCDNImageComplete)
			cdn_image_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onTraceInfo)
			
			ns.addEventListener(NetStatusEvent.NET_STATUS, function(e:NetStatusEvent)
				{
					lastinfo.push(e)
					//Cc.visible = true
					Cc.error(lastinfo[lastinfo.length - 1].info.code)
				
				})
	
		}
		private var speedArr:Array = []
		private var speedTimer:Timer = new Timer(200, 50)
		
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