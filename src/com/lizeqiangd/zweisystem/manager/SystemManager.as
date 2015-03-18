package com.lizeqiangd.zweisystem.manager
{
	//import com.lizeqiangd.zweisystem.components.StageProxy
	import flash.display.LoaderInfo;
	import flash.system.Capabilities;
	
	/**
	 * 用于管理flash接受的参数，和flash所在的运行环境的检测。供其他程序调用.
	 * update
	 * 2014.04.05 更新备注和修正法部分参数.
	 *
	 */
	public class SystemManager
	{
		private static var li:LoaderInfo
		
		/**
		 * 很特殊的方式查看本Swf文件是否是本地的还是网络的.需要输入swf主舞台本身.
		 * @param	loaderInfo
		 */
		public static function init(loaderInfo:LoaderInfo):void
		{
			
			if (loaderInfo)
			{
				li = loaderInfo
				if (loaderInfo.url.substr(0, 4) == "file")
				{
					ConfigManager.setConfig('user_ip', "localhost")
				}
				else
				{
					ConfigManager.setConfig('user_ip', getFlashVar("ip"))
				}
			}
			else
			{
				ConfigManager.setConfig('user_ip', "localhost")
			}
		}
		
		/**
		 * 获取系统支持列表日志.
		 */
		public static function get systemLog():String
		{
			var _systemlog:String = ""
			_systemlog += "当前播放器版本：" + Capabilities.version + "\n";
			_systemlog += "是否允许使用摄像头或麦克风：" + Capabilities.avHardwareDisable + "\n";
			_systemlog += "辅助功能通信：" + Capabilities.hasAccessibility + "\n";
			_systemlog += "音频功能：" + Capabilities.hasAudio + "\n";
			_systemlog += "音频编码器：" + Capabilities.hasAudioEncoder + "\n";
			_systemlog += "视频：" + Capabilities.hasEmbeddedVideo + "\n";
			_systemlog += "输入法编辑器：" + Capabilities.hasIME + "\n";
			_systemlog += "MP3解码器：" + Capabilities.hasMP3 + "\n";
			_systemlog += "支持打印：" + Capabilities.hasPrinting + "\n";
			_systemlog += "是否支持FMS屏幕扩展程序：" + Capabilities.hasScreenBroadcast + "\n";
			_systemlog += "是否支持FMS屏幕扩展程序回放：" + Capabilities.hasScreenPlayback + "\n";
			_systemlog += "是否支持流式音频：" + Capabilities.hasStreamingAudio + "\n";
			_systemlog += "是否支持流式视频：" + Capabilities.hasStreamingVideo + "\n";
			_systemlog += "NetConnection 是否支持本机 SSL ：" + Capabilities.hasTLS + "\n";
			_systemlog += "视频编码器：" + Capabilities.hasVideoEncoder + "\n";
			_systemlog += "播放器为调试版本：" + Capabilities.isDebugger + "\n";
			_systemlog += "语言：" + Capabilities.language + "\n";
			_systemlog += "禁止读取本地文档：" + Capabilities.localFileReadDisable + "\n";
			_systemlog += "制造商：" + Capabilities.manufacturer + "\n";
			_systemlog += "操作系统：" + Capabilities.os + "\n";
			_systemlog += "屏幕像素高宽比例：" + Capabilities.pixelAspectRatio + "\n";
			_systemlog += "播放器模式：" + Capabilities.playerType + "\n";
			_systemlog += "屏幕颜色：" + Capabilities.screenColor + "\n";
			_systemlog += "屏幕每英寸点数：" + Capabilities.screenDPI + "\n";
			_systemlog += "屏幕水平分辨率：" + Capabilities.screenResolutionX + "\n";
			_systemlog += "屏幕垂直分辨率：" + Capabilities.screenResolutionY + "\n";
			_systemlog += "服务器字符串：" + Capabilities.serverString + "\n";
			_systemlog += "触摸屏：" + Capabilities.touchscreenType + "\n";
			_systemlog += "是否支持运行 64 位的进程：" + Capabilities.supports64BitProcesses + "\n";
			_systemlog += "运行时的制造商：" + Capabilities.manufacturer + "\n";
			return _systemlog;
		}
		
		public static function get getScreenDPI():Number
		{
			return Capabilities.screenDPI
		}
		
		public static function get getSystem():String
		{
			return Capabilities.os
		}
		
		public static function get isPCSystem():Boolean
		{
			if (Capabilities.os.toLowerCase().search("windows") > -1)
			{
				return true
			}
			else
			{
				return false
			}
		}
		
		/**
		 * 获取swf文件中提交进来的参数.是否可用
		 * @param	var_id
		 * @return
		 */
		public static function getFlashVar(var_id:String):String
		{
			var return_str:String = "";
			if (li.parameters[var_id] != null)
			{
				return_str = decodeURIComponent(li.parameters[var_id]);
			}
			return return_str;
		}
	
	}
}