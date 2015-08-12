package com.lizeqiangd.einstation.applications.Heimdallr
{
	import com.greensock.TweenLite;
	import com.lizeqiangd.zweisystem.abstract.windows.DragWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.interfaces.checkbox.cb_content;
	import com.lizeqiangd.zweisystem.interfaces.label.la_general;
	import com.lizeqiangd.zweisystem.interfaces.label.la_rect;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.modules.charter.LinearChart;
	import com.lizeqiangd.zweisystem.modules.imagedisplay.ImageDisplay;
	import com.lizeqiangd.zweisystem.modules.imagedisplay.MutilImageDisplay;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import flash.display.Shape;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 */
	
	public class Heimdallr extends DragWindows implements iApplication
	{
		
		private var ssn:SystemStatusNotification
		private var id:MutilImageDisplay
		
		public function Heimdallr()
		{
			this.setBackGroundColor = 0
			this.setBgAlpha = 0.8
			this.setDisplayLayer = "applicationLayer";
			//this.setApplicationTitle = "テルミヌス·エスト(Terminus Est)";
			this.setApplicationName = "Heimdallr";
			this.configWindows(900, 600)
			ssn = new SystemStatusNotification()
			ssn.y = 20
			ssn.config(this.getUiWidth, getUiHeight - 20)
			addChild(ssn)
			id = new MutilImageDisplay()
			this.addEventListener(ApplicationEvent.INIT, init);
		}
		private var arr_char:Array = ['http://utils.lizeqiangd.com/EinStation/Heimdallr/character_6_1.png', 'http://utils.lizeqiangd.com/EinStation/Heimdallr/character_6_2.png']
		private var arr_char_index:uint = 0
		private var mask_char:Shape
		
		public function init(e:ApplicationEvent):void
		{
			
			mask_char = new Shape
			mask_char.graphics.beginFill(0, 0)
			mask_char.graphics.drawRect(0, 0, getUiWidth, getUiHeight)
			addChild(mask_char)
			mask_char.visible = false
			id.mask = mask_char;
			id.y = getUiHeight - 500;
			setInterval(function():void
			{
				id.load(arr_char[arr_char_index % 2]);
				arr_char_index++
			}, 10000)
			startCharAnimation()
			addChild(id)
			createInfomationBoard()
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function createInfomationBoard():void
		{
			var la_functions:la_rect
			var la_services:la_rect
			var la_systeminfo:la_rect
			la_functions = new la_rect;
			la_services = new la_rect;
			la_systeminfo = new la_rect;
			la_services.text = '服务器监控'
			la_systeminfo.text = '服务器信息'
			la_functions.text = '业务和功能'
			addChild(la_functions);
			addChild(la_services);
			addChild(la_systeminfo);
			la_functions.x = la_services.x = la_systeminfo.x = 400;
			la_functions.y = 440;
			la_services.y = 220;
			la_systeminfo.y = 20;
			
			var cb_ssserver:cb_content = new cb_content
			cb_ssserver.x = 400 + 10 + 140 * 0
			cb_ssserver.y = 440 + 30 + 40 * 0
			cb_ssserver.title = 'ShadowSocks'
			cb_ssserver.selected = true
			AnimationManager.changeColor(cb_ssserver, 0x66ff00)
			addChild(cb_ssserver)
			
			var cb_pptpd:cb_content = new cb_content
			cb_pptpd.x = 400 + 10 + 140
			cb_pptpd.y = 440 + 30 + 40 * 0
			cb_pptpd.title = 'PPTP'
			cb_pptpd.selected = true
			AnimationManager.changeColor(cb_pptpd, 0x66ff00)
			addChild(cb_pptpd)
			
			var cb_heimdallr:cb_content = new cb_content
			cb_heimdallr.x = 400 + 10 + 140 * 2
			cb_heimdallr.y = 440 + 30 + 40 * 0
			cb_heimdallr.title = 'Heimdallr'
			//cb_heimdallr.selected = true
			//AnimationManager.changeColor(cb_heimdallr, 0x66ff00)
			addChild(cb_heimdallr)
			
			var cb_mariadb:cb_content = new cb_content
			cb_mariadb.x = 400 + 10 + 140 * 0
			cb_mariadb.y = 440 + 30 + 40 * 1
			cb_mariadb.title = 'MariaDB'
			cb_mariadb.selected = true
			AnimationManager.changeColor(cb_mariadb, 0x66ff00)
			addChild(cb_mariadb)
			
			var cb_php:cb_content = new cb_content
			cb_php.x = 400 + 10 + 140
			cb_php.y = 440 + 30 + 40 * 1
			cb_php.title = 'PHP'
			cb_php.selected = true
			AnimationManager.changeColor(cb_php, 0x66ff00)
			addChild(cb_php)
			
			var cb_nginx:cb_content = new cb_content
			cb_nginx.x = 400 + 10 + 140 * 2
			cb_nginx.y = 440 + 30 + 40 * 1
			cb_nginx.title = 'NGINX'
			cb_nginx.selected = true
			AnimationManager.changeColor(cb_nginx, 0x66ff00)
			addChild(cb_nginx)
			
			var cb_redis:cb_content = new cb_content
			cb_redis.x = 400 + 10 + 140 * 0
			cb_redis.y = 440 + 30 + 40 * 2
			cb_redis.title = 'Redis'
			//cb_redis.selected = true
			AnimationManager.changeColor(cb_redis, 'red')
			addChild(cb_redis)
			
			var cb_memcached:cb_content = new cb_content
			cb_memcached.x = 400 + 10 + 140
			cb_memcached.y = 440 + 30 + 40 * 2
			cb_memcached.title = 'Memcached'
			cb_memcached.selected = true
			AnimationManager.changeColor(cb_memcached, 0x66ff00)
			addChild(cb_memcached)
			
			//var cb_nginx:cb_content = new cb_content
			//cb_nginx.x = 400 + 10 + 140 * 2
			//cb_nginx.y = 440 + 30 + 40 * 1
			//cb_nginx.title = 'NGINX'
			//cb_nginx.selected = true
			//AnimationManager.changeColor(cb_nginx, 0x66ff00)
			//addChild(cb_nginx)
			
			//服务器介绍环节.
			var la_server:la_general = new la_general
			la_server.text = '服务器名称:Terminus Est'
			la_server.x = 400 + 10
			la_server.y = 20 + 30 * 1;
			addChild(la_server)
			
			var la_server_info:la_general = new la_general
			la_server_info.text = '无法获取详细信息'
			la_server_info.x = 400 + 10
			la_server_info.y = 20 + 30 * 2;
			addChild(la_server_info)
			
			var chart_server:LinearChart = new LinearChart()
			chart_server.x = 400
			chart_server.y = 220;
			chart_server.config(490, 190)
			chart_server.data=[1,1,1,1,1,1,1,1,1,1]
			chart_server.createChartData()
			addChild(chart_server)
		
		}
		
		private function startCharAnimation():void
		{
			TweenLite.to(id,5, {y: id.y == getUiHeight - 500 ? getUiHeight - 475 : getUiHeight - 500, delay: Math.random() * 2, onComplete: startCharAnimation})
		}
		
		private function addApplicationListener():void
		{
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function removeApplicationListener():void
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent):void
		{
			removeApplicationListener();
		
		}
		
		public function dispose():void
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE))
		}
		
		public function applicationMessage(e:Object):void
		{
			switch (e)
			{
			case "": 
				break;
			default: 
				break;
			}
		}
	}

}