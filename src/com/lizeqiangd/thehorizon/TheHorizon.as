package com.lizeqiangd.thehorizon
{
	import com.thehorizon.LayerManager;
	import com.thehorizon.manager.MarkManager;
	import com.thehorizon.manager.PositionManager;
	import com.zweitehorizont.ZweiteHorizont;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class TheHorizon
	{
		private static var _maincontain:Sprite
		private static var lm:LayerManager
		private static var mm:MarkManager
		private static var pm:PositionManager
		public function TheHorizon()
		{
		
		}
		
		public function init():void
		{
			initTheHorizont()
		}
		
		public function initTheHorizont():void
		{
			_maincontain = new Sprite()
			lm = new LayerManager
			mm = new MarkManager
			pm = new PositionManager
			
			
			lm.init(_maincontain)
			mm.init(lm)
			//pm.init()
			
		}
		
		
		public function get MainContain():Sprite
		{
			return _maincontain
		}
		
		public function get LayerManagers():LayerManager
		{
			return lm
		}
		public function get MarkManagers():MarkManager {
		return mm	
		}
	}

}