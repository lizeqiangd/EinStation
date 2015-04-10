package com.lizeqiangd.zweisystem.abstract.active
{
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	
	/**
	 * Active的接口程序,目前只有销毁和active信息.
	 * @author Lizeqiangd
	 */
	public interface iActive
	{
		function dispose():void
		function activeMessage(msg:Object):void
		
		function config(_w:Number, _h:Number):void
		function createFrame(value:Boolean = true):void
		function getActive(active_name:String):iActive
		function set setActiveTitle(e:String):void
		function get getActiveTitle():String
		function get ActiveName():String
		function set setAcitveManager(e:ActiveManager):void
		function get getAcitveManager():ActiveManager
		
		function set setPositionName(e:String):void
		function get getPositionName():String
		function get host():iApplication
		function set host(e:*):void
	}

}