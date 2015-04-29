package com.lizeqiangd.zweitehorizont.demo 
{
	import com.lizeqiangd.zweitehorizont.ZweiteHorziontServer;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class Main2 extends Sprite
	{
		public function Main2() 
		{
			ZweiteHorziontServer.getInstance.connectToServer('127.0.0.1',20100)
		
			
		}
		
	}

}