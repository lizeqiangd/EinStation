package com.lizeqiangd.zweitehorizont.demo
{
	import com.lizeqiangd.zweisystem.events.UIEvent;
	import com.lizeqiangd.zweisystem.interfaces.button.btn_general;
	import com.lizeqiangd.zweisystem.interfaces.label.la_general;
	import com.lizeqiangd.zweisystem.interfaces.textinput.ti_general;
	import com.lizeqiangd.zweisystem.interfaces.textinput.ti_textfield;
	import com.lizeqiangd.zweitehorizont.events.ZweiteHorizontServerEvent;
	import com.lizeqiangd.zweitehorizont.ZweiteHorizontServer;
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
		private var tf_message:ti_textfield
		
		public function Main2()
		{
			ZweiteHorizontServer.getInstance.connectToServer('127.0.0.1', 20100)
			ti_message = new ti_general
			ti_message.y = 30
			addChild(ti_message)
			
			btn_message = new btn_general
			btn_message.title = '发送'
			btn_message.y = 70
			addChild(btn_message)
			
			la_client_id = new la_general
			la_client_id.text = ''
			addChild(la_client_id)
			
			tf_message = new ti_textfield
			tf_message.x = 320
			tf_message.config(300, 500)
			addChild(tf_message)
		
			btn_message.addEventListener(UIEvent.CLICK, onClick)
			ti_message.addEventListener(UIEvent.SUBMIT, onClick)
			ZweiteHorizontServer.getInstance.addEventListener(ZweiteHorizontServerEvent.INITED, onInited)
			ZweiteHorizontServer.getInstance.addEventListener(ZweiteHorizontServerEvent.DATA,onData)
		}
		
		private function onData(e:ZweiteHorizontServerEvent):void 
		{
			if (e.payload.data)				
			if(e.payload.data.msg)
			tf_message.textfield.appendText(e.payload.client_id +':\n'+ e.payload.data.msg+'\n')
		}
		private function onInited(e:ZweiteHorizontServerEvent):void
		{
			la_client_id.title = ZweiteHorizontServer.getInstance.getClientId
		}
		
		private function onClick(e:UIEvent):void
		{
			if (ZweiteHorizontServer.getInstance.getInited&&ti_message.text)
			{
				ZweiteHorizontServer.getInstance.sendData( { type: 'anime', msg: ti_message.text + '' }, 'communication_manager', 'test_boardcast_message')
				ti_message.text =''
			}
		}
	
	}

}