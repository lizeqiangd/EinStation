package com.lizeqiangd.einstation.applications.WorkAssistant
{
	
	import com.lizeqiangd.zweisystem.abstract.active.ActiveManager;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 */
	
	public class WorkAssistant extends TitleWindows implements iApplication
	{
		
		private var ssn:SystemStatusNotification
		private var am:ActiveManager
		private var urll_active:URLLoader
		private var urll_linode:URLLoader
		
		private var activity_server_api:String = 'http://events.acg.tv/zweitehorizont/api/system/server_info.php?token=76423416'
		private var linode_server_api:String = 'http://acfun.moe/zweitehorizont/api/system/server_info.php?token=76423416'
		private var last_data_cache:Object
		private var data_update_timer:Timer
		
		private var sp_heartbeat:Sprite
		
		public function WorkAssistant()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - WorkAssistant -";
			this.setApplicationName = "WorkAssistant";
			this.setBackGroundColor=0xffffff
			this.configWindows(700, 900)
			ssn = new SystemStatusNotification()
			ssn.y = 20
			ssn.config(this.getUiWidth, getUiHeight - 20)
			addChild(ssn)
			
			am = new ActiveManager(this)
			am.addActiveByClass(ServerMonitor, ServerMonitor, ServerMonitor, ServerMonitor, ServerMonitor, ServerMonitor)
			am.registerPointByXY(10, 30, 'p1')
			am.registerPointByXY(10 + 330 + 20, 30, 'p2')
			am.registerPointByXY(10, 30 + 210, 'p3')
			
			am.registerPointByXY(10, 30 + 210 + 210, 'p4')
			am.registerPointByXY(10 + 330 + 20, 30 + 210 + 210, 'p5')
			am.registerPointByXY(10, 30 + 210 + 210 + 210, 'p6')
			this.addChild(am)
			
			am.Active('ServerMonitor').activeMessage({type: 'active_name', 'active_name': 'activity_cpu'})
			am.Active('ServerMonitor').activeMessage({type: 'active_name', 'active_name': 'activity_net'})
			am.Active('ServerMonitor').activeMessage({type: 'active_name', 'active_name': 'activity_mem'})
			
			am.Active('ServerMonitor').activeMessage({type: 'active_name', 'active_name': 'linode_cpu'})
			am.Active('ServerMonitor').activeMessage({type: 'active_name', 'active_name': 'linode_net'})
			am.Active('ServerMonitor').activeMessage({type: 'active_name', 'active_name': 'linode_mem'})
			
			am.Active('activity_mem').activeMessage({type: 'title', title: '活动服务器-内存'})
			am.Active('activity_net').activeMessage({type: 'title', title: '活动服务器-网络发送'})
			am.Active('activity_cpu').activeMessage({type: 'title', title: '活动服务器-CPU'})
			am.Active('linode_cpu').activeMessage({type: 'title', title: 'Linode-CPU'})
			am.Active('linode_net').activeMessage({type: 'title', title: 'Linode-网络发送'})
			am.Active('linode_mem').activeMessage({type: 'title', title: 'Linode-内存'})
			
			am.Active('activity_mem').activeMessage({display: 'mem'})
			am.Active('activity_net').activeMessage({display: 'net'})
			am.Active('activity_cpu').activeMessage({display: 'cpu'})
			am.Active('linode_cpu').activeMessage({display: 'cpu'})
			am.Active('linode_net').activeMessage({display: 'net'})
			am.Active('linode_mem').activeMessage({display: 'mem'})
			
			data_update_timer = new Timer(5 * 1000)
			urll_active = new URLLoader()
			urll_linode = new URLLoader()
			
			sp_heartbeat = new Sprite
			sp_heartbeat.mouseChildren = false
			sp_heartbeat.mouseEnabled = false
			sp_heartbeat.graphics.beginFill(0x3399ff, 1)
			sp_heartbeat.graphics.drawRect(0, 0, getUiWidth, 20)
			sp_heartbeat.graphics.endFill()
			addChildAt(sp_heartbeat, 1)
			last_data_cache = {}
			this.showCloseButton()
			this.addEventListener(ApplicationEvent.INIT, init);
		}
		
		public function init(e:ApplicationEvent):void
		{
			
			am.movein('activity_mem', 'p1', 'left')
			am.movein('activity_net', 'p2', 'right')
			am.movein('activity_cpu', 'p3', 'left')
			
			am.movein('linode_mem', 'p4', 'left')
			am.movein('linode_net', 'p5', 'right')
			am.movein('linode_cpu', 'p6', 'left')
			
			onDataUpdateTimerHandle(null)
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
			data_update_timer.start()
		}
		
		private function addApplicationListener():void
		{
			urll_linode.addEventListener(Event.COMPLETE, onDataLoadedComplete)
			urll_active.addEventListener(Event.COMPLETE, onDataLoadedComplete)
			this.data_update_timer.addEventListener(TimerEvent.TIMER, onDataUpdateTimerHandle)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onDataUpdateTimerHandle(e:TimerEvent):void
		{
			urll_active.load(new URLRequest(activity_server_api+'&'+Math.random()))
			urll_linode.load(new URLRequest(linode_server_api+'&'+Math.random()))
		}
		
		private function onDataLoadedComplete(e:Event):void
		{
			sp_heartbeat.alpha = 1
			AnimationManager.fade(sp_heartbeat, 0.1)
			if (e.target == urll_active)
			{
				var activity_data:Object = JSON.parse(urll_active.data)
				am.Active('activity_mem').activeMessage({type: 'data', data: activity_data.mem.used / 1024})
				if (last_data_cache['activity'])
				{
					trace(activity_data.net.eth0.send, last_data_cache['activity'].net.eth0.send)
					am.Active('activity_net').activeMessage({type: 'data', data: (activity_data.net.eth0.send - last_data_cache['activity'].net.eth0.send) / 1000})
				}
				am.Active('activity_cpu').activeMessage({type: 'data', data: activity_data.cpu.cpu})
				last_data_cache['activity'] = activity_data
			}
			if (e.target == urll_linode)
			{
				var linode_data:Object = JSON.parse(urll_linode.data)
				am.Active('linode_cpu').activeMessage({type: 'data', data: linode_data.cpu.cpu})
				if (last_data_cache['linode'])
				{
					am.Active('linode_net').activeMessage({type: 'data', data: (linode_data.net.eth0.send - last_data_cache['linode'].net.eth0.send) / 1000})
				}
				am.Active('linode_mem').activeMessage({type: 'data', data: (linode_data.mem.used) / 1024})
				last_data_cache['linode'] = linode_data
			}
		
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