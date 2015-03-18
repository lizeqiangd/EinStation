package com.lizeqiangd.zweisystem.abstract.windows
{
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;	
	/**
	 * Application的默认接口,方法只有3个:初始化,销毁,和应用程序消息
	 * @author:Lizeqiangd
	 * update:2014.03.28 增加注释,更改路径
	 */
	public interface iApplication
	{
		function init(e:ApplicationEvent);
		function applicationMessage(e:Object)
		function dispose()
	}
}