package com.lizeqiangd.einstation.applications.WorkAssistant
{
	import com.lizeqiangd.zweisystem.abstract.active.BaseActive;
	import com.lizeqiangd.zweisystem.abstract.active.iActive;
	import com.lizeqiangd.zweisystem.events.ActiveEvent;
	import com.lizeqiangd.zweisystem.modules.charter.LinearChart;
	import flash.events.MouseEvent;
	import flash.utils.setInterval;
	
	/**
	 *
	 * @author Lizeqiangd
	 */
	public class ServerMonitor extends BaseActive implements iActive
	{
		private var lc:LinearChart
		private var arr:Array
		private var title:String = '等待数据接收...'
		
		public function ServerMonitor()
		{
			super("ServerMonitor")
			this.setActiveTitle = title
			this.setFrameColor = 0xff0000
			this.config(330, 200)
			this.createFrame()
			addActiveListener()
			lc = new LinearChart
			lc.config(getUiWidth, getUiHeight - 20)
			lc.y = 20
			addChild(lc)
			arr = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
			lc.data=arr
		}
		
		private function addActiveListener():void
		{
			this.addEventListener(ActiveEvent.IN, onActiveIn)
			this.addEventListener(ActiveEvent.OUT, onActiveOut)
		}
		
		private function onActiveIn(e:ActiveEvent):void
		{
		
		}
		
		private function onActiveOut(e:ActiveEvent):void
		{
		
		}
		
		public function dispose():void
		{
		
		}
		
		public function activeMessage(msg:Object):void
		{
			switch (msg.type)
			{
				case 'data': 
					arr.push(msg.data as Number)
					if (arr.length > 20)
					{
						arr.shift()
					}
					lc.update()
					updateTitle()
					break;
				case 'title': 
					title = msg.title
					break;
				case 'active_name': 
					setActiveName = msg.active_name;
					break;
				default: 
			}
			
			switch (msg.display)
			{
				case 'cpu': 
					display_type = 'cpu'
					this.setFrameColor = 0xff0000
					this.config(330 * 2 + 20, 200)
					this.createFrame()
					//lc.setDataColor=(0xff0000)
					lc.config(getUiWidth, getUiHeight - 20)
					break;
				case 'net': 
					display_type = 'net'
					this.setFrameColor = 0x3399ff
					this.config(330, 200)
					this.createFrame()
					lc.config(getUiWidth, getUiHeight - 20)
					break;
				case 'mem': 
					display_type = 'mem'
					this.setFrameColor = 0x3399ff
					this.config(330, 200)
					this.createFrame()
					lc.config(getUiWidth, getUiHeight - 20)
					break;
				default: 
			}
		}
		private var display_type:String = 'cpu'
		
		private function updateTitle():void
		{
			var server:String
			switch (display_type)
			{
				case 'cpu': 
					server = '最高:' + lc.getMax.toFixed(2) + ' 最低' + lc.getMin.toFixed(2) + '';
					this.setActiveTitle = title + '  ' + server
					break;
				case 'net': 
					server = '最高:' + lc.getMax.toFixed(2) + 'Kb/s 最低' + lc.getMin.toFixed(2) + 'Kb/s';
					this.setActiveTitle = title + '  ' + server
					break;
				case 'mem': 
					server = '最高:' + lc.getMax.toFixed(2) + 'Mb 最低' + lc.getMin.toFixed(2) + 'Mb';
					this.setActiveTitle = title + '  ' + server
					break;
				default: 
			}		
		}
	}
}