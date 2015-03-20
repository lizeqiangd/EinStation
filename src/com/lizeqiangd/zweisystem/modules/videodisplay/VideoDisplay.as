package com.lizeqiangd.zweisystem.modules.videodisplay
{
	import com.lizeqiangd.zweisystem.events.VideoEvent;
	import com.lizeqiangd.zweisystem.system.config.ESSetting;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.events.NetDataEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	/**
	 * 一个快捷的视频流播放的实例.
	 * @author lizeqiangd
	 * 2014.06.07 基本功能完成,可以播放网络视频了.但是一堆问题需要处理
	 * 首先是跳转播放等功能需要完善,音量控制,fms流似视频需要控制.这是一个非常复杂的大类了.
	 */
	public class VideoDisplay extends Sprite
	{
		public static const CameraMode:String = "local_camera"
		public static const StreamMode:String = "live_stream"
		public static const VideoMode:String = "live_camera"
		
		private var _video:Video
		
		private var _nc:NetConnection
		private var _ns:NetStream
		
		private var mode:String = "not init"
		private var isAutoResize:Boolean = false
		private var nsc:Object
		
		public function init(width:Number = 320, height:Number = 240, autoResize:Boolean = false):void
		{
			nsc = new Object
			nsc.onXMPData = onXMPData
			nsc.onTextData = onTextData
			nsc.onPlayStatus = onPlayStatus
			nsc.onMetaData = onMetaData
			nsc.onImageData = onImageData
			nsc.onCuePoint = onCuePoint
			
			isAutoResize = autoResize
			_video = new Video(width, height)
			_video.smoothing = true
			_video.width = width
			_video.height = height
			addChild(_video)
		}
		
		public function loadCamera(cam:Camera = null):void
		{
			mode = "camera"
			_video.attachCamera(cam ? cam : Camera.getCamera())
		}
		
		public function loadStream():void
		{
			_nc = new NetConnection()
			_ns = new NetStream(_nc)
		}
		
		public function loadVideo(url:String):void
		{
			_nc = new NetConnection()
			_nc.connect(null)
			_ns = new NetStream(_nc)
			_ns.bufferTime = ESSetting.VideoDisplayDefaultBufferTime
			_ns.client = nsc
			mode = "stream"
			addNSListener()
			_video.attachNetStream(_ns)
			_ns.play(url)
		}
		
		public function stopStream():void
		{
			if (mode == "camera")
			{
				_video.attachCamera(null)
				mode = "no stream"
			}
			if (mode == "stream")
			{
				_video.attachNetStream(null);
				mode = "no stream"
			}
		}
		
		private function addNSListener():void
		{
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent)
			_ns.addEventListener(IOErrorEvent.IO_ERROR, onNSIOError)
			_ns.addEventListener(NetDataEvent.MEDIA_TYPE_DATA, onMediaTypeData)
		}
		
		private function onNetStatusEvent(e:NetStatusEvent):void
		{
			switch (e.info.code)
			{
				case "NetStream.Buffer.Empty": 
					//trace("VideoDisplay.onNetStatusEvent:NetStream.Buffer.Empty")
					break;
				case "NetStream.Buffer.Flush": 
					//trace("VideoDisplay.onNetStatusEvent:NetStream.Buffer.Flush")
					break;
				case "NetStream.Buffer.Full": 
					//	trace("VideoDisplay.onNetStatusEvent:NetStream.Buffer.Full")
					break;
				case "NetStream.Connect.Closed": 
					trace("VideoDisplay.onNetStatusEvent:NetStream.Connect.Closed")
					break;
				case "NetStream.Connect.Success": 
					trace("VideoDisplay.onNetStatusEvent:NetStream.Connect.Success")
					break;
				case "NetStream.Pause.Notify": 
					trace("VideoDisplay.onNetStatusEvent:NetStream.Pause.Notify")
					break;
				case "NetStream.Play.Start": 
					this.dispatchEvent(new VideoEvent(VideoEvent.PLAY_START))
					//trace("VideoDisplay.onNetStatusEvent:NetStream.Play.Start")
					break;
				case "NetStream.Play.Stop": 
					this.dispatchEvent(new VideoEvent(VideoEvent.PLAY_COMPLETE))
					//trace("VideoDisplay.onNetStatusEvent:NetStream.Play.Stop")
					break;
				case "NetStream.Play.Transition": 
					trace("VideoDisplay.onNetStatusEvent:NetStream.Play.Transition")
					break;
				case "NetStream.Publish.Start": 
					trace("VideoDisplay.onNetStatusEvent:NetStream.Publish.Start")
					break;
				case "NetStream.Record.Start": 
					trace("VideoDisplay.onNetStatusEvent:NetStream.Record.Start")
					break;
				case "NetStream.Record.Stop": 
					trace("VideoDisplay.onNetStatusEvent:NetStream.Record.Stop")
					break;
				default: 
					trace("VideoDisplay.onNetStatusEvent:" + e)
			}
			if (e.info.level == "error")
			{
				trace("VideoDisplay:" + e.info.error)
			}
		
		}
		
		private function onNSIOError(e:IOErrorEvent):void
		{
			dispatchEvent(e)
			//trace("VideoDisplay:IOError")
		}
		
		private function onMediaTypeData(e:NetDataEvent):void
		{
			//trace("VideoDisplay:NetDataEvent")
		}
		
		private function removeNSListener():void
		{
			_ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatusEvent)
			_ns.removeEventListener(IOErrorEvent.IO_ERROR, onNSIOError)
			_ns.removeEventListener(NetDataEvent.MEDIA_TYPE_DATA, onMediaTypeData)
		}
		
		public function dispose():void
		{
			if (state == "init")
			{
			}
			removeNSListener()
			removeChild(_video)
			_ns.close()
			_ns.dispose()
			_nc.close()
			Video(_ns).attachNetStream(null)
		}
		
		public function get state():String
		{
			return mode
		}
		
		public function getNetStream():NetStream
		{
			return _ns
		}
		
		public function getNetConnection():NetConnection
		{
			return _nc
		}
		
		public function onXMPData(o:Object):void
		{
		
			//trace("onXMPData")
		}
		
		public function onTextData(o:Object):void
		{
			//trace("onTextData")
		}
		
		public function onPlayStatus(o:Object):void
		{
			//trace("onPlayStatus")
		}
		
		public function onMetaData(o:Object):void
		{
			if (isAutoResize)
			{
				_video.width = o.width
				_video.height = o.height
			}
			StageProxy.updateStageSize()
		}
		
		public function onImageData(o:Object):void
		{
			//trace("onImageData")
		}
		
		public function onCuePoint(o:Object):void
		{
			trace("onCuePoint")
		}
	
	}

}