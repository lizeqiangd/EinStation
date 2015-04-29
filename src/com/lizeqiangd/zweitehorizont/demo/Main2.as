package com.lizeqiangd.zweitehorizont.demo
{
	import com.lizeqiangd.zweisystem.events.UIEvent;
	import com.lizeqiangd.zweisystem.interfaces.button.btn_general;
	import com.lizeqiangd.zweisystem.interfaces.label.la_general;
	import com.lizeqiangd.zweisystem.interfaces.textinput.ti_general;
	import com.lizeqiangd.zweitehorizont.events.ZweiteHorizontServerEvent;
	import com.lizeqiangd.zweitehorizont.ZweiteHorziontServer;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class Main2 extends Sprite
	{
		private var la_client_id:la_general
		private var ti_message:ti_general
		private var btn_message:btn_general
		
		public function Main2()
		{
			ZweiteHorziontServer.getInstance.connectToServer('127.0.0.1', 20100)
			ZweiteHorziontServer
			ti_message = new ti_general
			ti_message.y=30
			addChild(ti_message)
			
			btn_message = new btn_general
			btn_message.title = '发送'
			btn_message.y = 70
			addChild(btn_message)
			
			la_client_id = new la_general
			la_client_id.text = ''
			addChild(la_client_id)
			btn_message.addEventListener(UIEvent.CLICK, onClick)
			
			ZweiteHorziontServer.getInstance.addEventListener(ZweiteHorizontServerEvent.INITED,onInited)
		}
		
		private function onInited(e:ZweiteHorizontServerEvent):void 
		{
			la_client_id.title=ZweiteHorziontServer.getInstance.getClientId
		}
		
		private function onClick(e:UIEvent):void
		{
			if (ZweiteHorziontServer.getInstance.getInited)
			{
				ZweiteHorziontServer.getInstance.sendData({msg: ti_message.text + ''}, 'communication_manager', 'test_boardcast_message')
			}
		}
	
	}

}