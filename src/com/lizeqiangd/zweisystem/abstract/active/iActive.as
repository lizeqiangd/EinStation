package com.lizeqiangd.zweisystem.abstract.active
{
	import com.lizeqiangd.zweisystem.events.ActiveEvent;

	/**
	 * Active的接口程序,目前只有销毁和active信息.
	 * @author Lizeqiangd
	 */
	public interface iActive
	{
		 function dispose()
		 function activeMessage(msg:Object)
	}

}