package com.lizeqiangd.zweisystem.system.config
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * 这是EinStation的默认字体格式库
	 * @author lizeqiangd
	 */
	public class ESTextFormat extends TextFormat
	{
		public static const DefaultTextFormat:TextFormat = new TextFormat("微软雅黑", 12, 0xff9900)
		
		public static function get LightBlueTitleTextFormat():TextFormat
		{
			var tf:TextFormat = new TextFormat("微软雅黑", 12, 0x3399ff, null, null, null, null, null, TextFormatAlign.CENTER)
			return tf
		}
	}
}