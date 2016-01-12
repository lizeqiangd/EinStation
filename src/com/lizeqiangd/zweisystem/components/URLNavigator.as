package com.lizeqiangd.zweisystem.components
{
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * URLNavigateManager.as ->URLNavigator.as
	 * Lizeqiangd
	 * 2013.06.21 删除毫无疑义的信任域名功能
	 * 2014.04.05 进一步删除无用方法和引用,同时改成一个组件.
	 */
	public class URLNavigator
	{
		/**
		 * 打开一个url.默认会提示信息框.注意.这个时候点击其他对话框会覆盖要打开的网站.务必注意.
		 * @param	url 要打开的url
		 * @param	direct 是否直接打开不弹窗
		 * @param	type 打开的方式.按照html标准.默认是_blank 弹窗
		 * @param	trusted  是否为信任域名
		 */
		public static function open(url:String, direct:Boolean = false, type:String = "_blank", trusted:Boolean = false):void
		{
			if (direct)
			{
				navigateToURL(new URLRequest(url), type);
				return;
			}
			Message.OpenUrl(url, type, function()
				{
					navigateToURL(new URLRequest(url), type);
				}, trusted);
			return;
		}
	}
}