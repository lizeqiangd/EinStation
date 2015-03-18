package com.lizeqiangd.zweisystem.applications.PsychoPass
{
	import com.greensock.TweenLite;
	//import com.nuigesture.event.GestureEvent;
	//import com.nuigesture.NuiGesture;
	import com.sina.microblog.events.MicroBlogEvent;
	import com.zweisystem.applications.PsychoPass.addon.UserPsychoPassBar;
	import com.zweisystem.applications.SinaWeibo.SinaMicroBlogManager;
	import com.zweisystem.events.ApplicationEvent;
	import com.zweisystem.abstracts.windows.FullWindows;
	import com.zweisystem.abstracts.windows.iApplication;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.managers.ApplicationManager;
	import com.zweisystem.managers.PositionManager;
	import com.zweisystem.net.AMFPHP;
	import com.zweisystem.system.applications.message.Message;
	import com.zweisystem.system.proxy.StageProxy;
	import com.zweisystem.system.applications.background.BackgroundManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * 用于查看所有用户的PsychoPass
	 * 2013.02.19 制作开始
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 */
	public class PsychoPassControlSystem extends FullWindows implements iApplication
	{
		private var PsychoDisplay:Sprite
		private var PsychoBar:UserPsychoPassBar
		private const defaultRows:int = 54000
		
		public function PsychoPassControlSystem()
		{
			this.setDisplayLayer = "backgroundLayer";
			this.setBackgroundTitle = "EinStation Application - PsychoPassControlSystem -";
			this.setApplicationName = "PsychoPassControlSystem";
			this.setBackgroundControlType = BackgroundManager.blackWithoutText
			this.setAutoRemoveBackground = false
			this.setApplicationVersion = "0.0.1"
			this.setBgAlpha = 1
			this.setBackgroundTitle = "PsychoPass主查询系统"
			this.addEventListener(ApplicationEvent.INIT, init);
			onStageResize()
			StageProxy.addResizeFunction(onStageResize);
		}
		
		public function init(e:ApplicationEvent)
		{
			this.mc_controlPanel.btn_scroll.textWidth = 160
			this.mc_controlPanel.btn_scroll.setStepAndTotal(20, defaultRows)
			this.mc_controlPanel.btn_refresh.title = "刷新"
			this.mc_controlPanel.btn_application.title = "进行授权"
			this.mc_controlPanel.tx_input.text = "0"
			mc_controlPanel.mc_search.defaultText = "查询名字"
			PsychoDisplay = new Sprite
			addChildAt(PsychoDisplay, 0)
			addApplicationListener()
			
		//	test()
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		}
		
		private function addApplicationListener()
		{
			mc_controlPanel.btn_go.addEventListener(MouseEvent.CLICK, onGoClick)
			mc_controlPanel.mc_search.addEventListener(UnitEvent.SEARCH, onSearchHangle)
			mc_controlPanel.btn_scroll.addEventListener(UnitEvent.CHANGE, onScrollChange)
			mc_controlPanel.btn_application.addEventListener(UnitEvent.CLICK, onOpenMainApplication)
			mc_controlPanel.btn_refresh.addEventListener(UnitEvent.CLICK, onRefreshClick)
			mc_controlPanel.btn_close.addEventListener(MouseEvent.CLICK, CloseApplication)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			SinaMicroBlogManager.addEventListener("UserShow", onWeiboUserShow, false, 0, false)
			
		}
		/*private function test() {
		//	SinaMicroBlogManager.debugMode ()
		//	NuiGesture.addEventListener(GestureEvent.GESTURE, onGestureHandle)
				
		}
		private function onGestureHandle(e:GestureEvent):void
		{
			switch (e.data.direction)
			{	case "down":
					this.mc_controlPanel.tx_input.text="17660"
					onGoClick(null)
				break
				case "right":
					mc_controlPanel.btn_scroll.Next()
					break;
				case "left":
					mc_controlPanel.btn_scroll.Prev()
					break;
				case "in":
					var o:Object = {
					screen_name:"9bishi",uid:"2093001685",create_date:"2013-01-21 01:10:58",psycho_pass:"16",id:"21534",psycho_pass_array:"2-0-1-2-3-0-1-1-0-0-0-1-0-1-2-5-0-1-0-1-0-0-0-0-0-0-0-0-1-0-2-0-1-0-1-1-2-1-5-1-0-1"}
						ApplicationManager.open("com.zweisystem.applications.PsychoPass.PsychoPassAnalyse", true).applicationMessage(o)
					
		
					break;
				default: 
			}
		}*/
		
		private function onWeiboUserShow(e:MicroBlogEvent):void
		{
			this.mc_controlPanel.btn_application.enable = false
			this.mc_controlPanel.btn_application.title = "授权成功"
			SinaMicroBlogManager.removeEventListener("UserShow", onWeiboUserShow)
		
		}
		
		private function onGoClick(e:MouseEvent):void
		{
			mc_controlPanel.btn_scroll.setNow = int(mc_controlPanel.tx_input.text)
		}
		
		private function onSearchHangle(e:UnitEvent):void
		{
			searchName = e.data
			mc_controlPanel.btn_scroll.setNow = 0
		}
		
		private function onOpenMainApplication(e:UnitEvent):void
		{
			SinaMicroBlogManager.login()
			//SinaMicroBlogManager.debugMode()
		}
		private var searchName:String = " "
		
		private function onRefreshClick(e:UnitEvent):void
		{
			mc_controlPanel.btn_scroll.setStepAndTotal(displayZoneRows, defaultRows)
			mc_controlPanel.btn_scroll.setNow = 0
			mc_controlPanel.mc_search.defaultText = "查询名字"
			searchName = " "
		}
		
		private function onScrollChange(e:UnitEvent):void
		{
			this.mc_controlPanel.tx_input.text = e.data
			var o:Array = new Array;
			o.screen_name = searchName
			o.step = displayZoneRows;
			o.start = e.data;
			AMFPHP.callResult("PsychoPassWeiboApplication.getDefaultPsychoPassData", onAmfphpCallBack, o);
		}
		
		private function onAmfphpCallBack(e:*)
		{
			if (e.length > 0)
			{
				_now = 0
				_total = e.length
				PsychoDisplay.removeChildren()
				_displayArr = new Vector.<UserPsychoPassBar>
				for (var i:int = 0; i < _total; i++)
				{
					PsychoBar = new UserPsychoPassBar
					PsychoBar.addEventListener(UnitEvent.CLICK, onOpenPsychoPassAnalyse, false, 0, true)
					PsychoBar.y = 20 + 60 * i
					PsychoBar.dataProvider(e[i])
					PsychoDisplay.addChild(PsychoBar)
					_displayArr.push(PsychoBar)
				}
				StageProxy.addEnterFrameFunction(onEntryFrame)
			}
		
		}
		
		private function onOpenPsychoPassAnalyse(e:UnitEvent):void
		{
			if (SinaMicroBlogManager.uid)
			{
				
				ApplicationManager.open("com.zweisystem.applications.PsychoPass.PsychoPassAnalyse", true).applicationMessage(e.data)
			}
			else
			{
				Message.SinaWeiboAuthorizationError("需要经过授权后才可使用。请点击下方授权按钮。")
					//ApplicationManager.open ("com.zweisystem.applications.PsychoPass.PsychoPassAnalyse",)//.applicationMessage({})
					//ApplicationManager.open ("com.zweisystem.applications.PsychoPass.PsychoPassAnalyse")//.applicationMessage(e.data)
				
			}
		}
		private var _now:int
		private var _total:int
		private var _displayArr:Vector.<UserPsychoPassBar>
		private var _slowdown:int = 0
		
		private function onEntryFrame()
		{
			if (++_slowdown > 3)
			{
				
				_displayArr[_now].init()
				_now++
				if (_now >= _total)
				{
					StageProxy.removeEnterFrameFunction(onEntryFrame)
					return
				}
				_slowdown = 0
			}
		}
		
		private function removeApplicationListener()
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			mc_controlPanel.btn_go.removeEventListener(MouseEvent.CLICK, onGoClick)
			mc_controlPanel.mc_search.removeEventListener(UnitEvent.SEARCH, onSearchHangle)
			mc_controlPanel.btn_scroll.removeEventListener(UnitEvent.CHANGE, onScrollChange)
			mc_controlPanel.btn_application.removeEventListener(UnitEvent.CLICK, onOpenMainApplication)
			mc_controlPanel.btn_refresh.removeEventListener(UnitEvent.CLICK, onRefreshClick)
			mc_controlPanel.btn_close.removeEventListener(MouseEvent.CLICK, CloseApplication)
		}
		
		private function onApplicationClose(e:ApplicationEvent)
		{
			dispose()
		}
		
		public function dispose()
		{
			removeApplicationListener();
			StageProxy.removeResizeFunction(onStageResize);
		}
		
		private function onStageResize()
		{
			mc_controlPanel.x = StageProxy.stageWidth - mc_controlPanel.width
			mc_controlPanel.y = StageProxy.stageHeight - mc_controlPanel.height
			mc_controlPanel.btn_scroll.setStep = displayZoneRows
		}
		
		private function get displayZoneHeight():Number
		{
			return (StageProxy.stageHeight - 20 - 30)
		}
		
		private function get displayZoneRows():int
		{
			return Math.floor((StageProxy.stageHeight - 20 - 30) / 60)
		}
		
		public function applicationMessage(e:Object)
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