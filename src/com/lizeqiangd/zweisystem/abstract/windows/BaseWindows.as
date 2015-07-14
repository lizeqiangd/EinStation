package com.lizeqiangd.zweisystem.abstract.windows
{
	import com.lizeqiangd.zweisystem.interfaces.baseunit.BaseUI;
	import com.lizeqiangd.zweisystem.manager.SystemManager;
	import com.lizeqiangd.zweisystem.system.applications.background.BackgroundManager;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.manager.LayerManager;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**BaseWindows是所有windows的基类，记录应用程序的基本信息。
	 * Lizeqiangd @2012.10.29
	 * 2013.01.27 更新应用事件。
	 * 2014.03.28 更新所有备注.并重新检查.  目前无法进行任何更改...很完善?
	 * 2014.12.17 添加对baseui的继承
	 * 2015.03.19 删除版本功能.
	 */
	public class BaseWindows extends BaseUI
	{
		
		protected const BaseWindowsDefaultScale:Number = 1
		protected const BaseWindowsRetinaScale:Number = 2
		protected const BaseWindowsRetinaScaleLimit:Number = 140
		private var nowScale:Number = 1
		private var appName:String = "untitled";
		private var displayLayer:String = "topLayer";
		private var mutiExist:Boolean = false;
		private var autoRemove:Boolean = true;
		private var removeBackground:Boolean = false;
		private var backgroundApplication:Boolean = false;
		private var isFocusAble:Boolean = true;
		private var autoAdjustToRetina:Boolean = true
		
		/**
		 * BaseWindows的构造函数,对本应用添加事件侦听器,打开完成和完全关闭,以及对鼠标的侦听以触发聚焦.
		 * 同时调度ApplicationEvent.OPEN事件
		 */
		public function BaseWindows()
		{
			adjustToRetinaScreen()
			this.addEventListener(MouseEvent.MOUSE_DOWN, onBaseWindowsFocus);
			this.addEventListener(ApplicationEvent.CLOSED, onBaseWindowsClosedHangle);
			this.addEventListener(ApplicationEvent.OPENED, onBaseWindowsOpenedHangle);
			this.addEventListener(ApplicationEvent.OPEN, onBaseWindowsOpenHangle);
			this.dispatchEvent(new ApplicationEvent(ApplicationEvent.OPEN));
		}
		
		/**
		 * 简单粗暴的方法对应苹果高清屏幕所使用.效果拔群
		 */
		private function adjustToRetinaScreen():void
		{
			if (SystemManager.getScreenDPI > BaseWindowsRetinaScaleLimit && autoAdjustToRetina)
			{
				nowScale = BaseWindowsRetinaScale
				this.scaleX = BaseWindowsRetinaScale
				this.scaleY = BaseWindowsRetinaScale
			}
		}
		
		/**
		 * 设置basewindows的设置
		 * @param	_w
		 * @param	_h
		 */
		public function configWindows(_w:Number, _h:Number):void
		{
			//this.setBackGroundColor = 0
			this.configBaseUi(_w, _h)
			this.createFrame(true)
			this.createBackground(0.8)
		}
		
		/**
		 * 提供手动初始化的方法给不适用完整系统的组件.
		 */
		public function manualInitWindows():void
		{
			this.dispatchEvent(new ApplicationEvent(ApplicationEvent.INIT))
		}
		
		/**
		 * 该方法将 ApplicationEvent.CLOSE 事件放入本应用,则应用将会和常规关闭方法一样被关闭.
		 */
		public function CloseApplication(e:* = null):void
		{
			this.dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE));
		}
		
		/**
		 * 强行将本应用成为LayerManager中的聚焦程序,相当于被点击.
		 */
		private function onBaseWindowsFocus(e:MouseEvent):void
		{
			if (isFocusAble)
			{
				LayerManager.setForceLayer(this);
			}
		}
		
		/**
		 * BaseWindows当窗口被确认打开后执行的方法.
		 * private function onBaseWindowsOpenedHangle(e:ApplicationEvent):void
		 */
		private function onBaseWindowsOpenedHangle(e:ApplicationEvent):void
		{
			//adjustToRetinaScreen()
		}
		
		/**
		 * BaseWindows当窗口被打开时执行的方法. 默认无事件,可覆盖
		 * 本方法原本只在LayerManager中处理
		 */
		private function onBaseWindowsOpenHangle(e:ApplicationEvent):void
		{
		
		}
		
		/**
		 * BaseWindows当窗口被关闭完成的时候调用的方法.
		 * 例如重新恢复背景菜单等.不建议覆盖.
		 */
		private function onBaseWindowsClosedHangle(e:ApplicationEvent):void
		{
			this.removeEventListener(ApplicationEvent.CLOSED, onBaseWindowsClosedHangle);
			this.removeEventListener(ApplicationEvent.OPENED, onBaseWindowsOpenedHangle);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onBaseWindowsFocus);
			if (removeBackground)
			{
				//BackgroundManager.addBackGroundImage()
			}
			if (!(this is AnimeWindows))
			{
				//trace("BaseWindows CLOSED函数");
				dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSED));
			}
		}
		
		/**
		 *获取该应用是否允许多重存在.
		 */
		
		public function set setMutiExistEnable(e:Boolean):void
		{
			mutiExist = e;
		}
		
		/**
		 * 获取应用程序是否允许多重存在
		 */
		public function get getMutiExistEnable():Boolean
		{
			return mutiExist;
		}
		
		/**
		 * 设置当前应用程序名字.
		 */
		public function set setApplicationName(e:String):void
		{
			appName = e;
		}
		
		/**
		 * 获取应用程序名字.
		 */
		public function get getApplicationName():String
		{
			return appName;
		}
		
		/**
		 * 设置当前应用显示层.初始化之前定义有效.之后修改无效.
		 */
		public function set setDisplayLayer(e:String):void
		{
			displayLayer = e;
		}
		
		/**
		 * 获取当前应用程序显示层名称
		 */
		public function get getDisplayLayer():String
		{
			return displayLayer;
		}
		
		/**
		 * 设置当前应用是否允许被聚焦(放置最前)
		 */
		public function set setFocusAble(e:Boolean):void
		{
			isFocusAble = e;
		}
		
		/**
		 * 获取该程序是否允许被聚焦.
		 */
		public function get getFocusAble():Boolean
		{
			return isFocusAble;
		}
		
		/**
		 * 设置是否该应用是否暂时移除背景程序(默认是白色背景)
		 */
		public function set setAutoRemoveBackground(s:Boolean):void
		{
			if (s)
			{
				BackgroundManager.control(BackgroundManager.white)
				removeBackground = s;
			}
		
		}
		
		/**
		 * 获取应用程序是否会被自动移出背景
		 */
		public function get getAutoRemoveBackground():Boolean
		{
			return removeBackground;
		}
		
		/**
		 * 设置是否自动校正屏幕大小.
		 */
		public function set setAutoAdjustToRetina(value:Boolean):void
		{
			this.autoAdjustToRetina = value
		}
		
		/**
		 * 获取当前windows的缩放情况.
		 */
		public function get getNowScale():Number
		{
			return nowScale
		}
	}
}