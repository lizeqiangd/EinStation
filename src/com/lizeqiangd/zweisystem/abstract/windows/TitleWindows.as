package com.lizeqiangd.zweisystem.abstract.windows
{
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.interfaces.button.icon.btn_close;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.system.config.ESTextFormat;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	/** TitleWindows 有标题和关闭按钮的窗口
	 * 2013.01.27 整理函数代码，修改应用事件
	 * 2014.03.28 重新整理代码,添加注释以及修正路径.
	 * 2015.03.18 整理代码,移除对flash pro的依赖!
	 */
	public class TitleWindows extends DragWindows
	{
		public var tx_title:TextField;
		
		private var orignalTitle:String = "";
		private var isInited:Boolean = false;
		private var btn_closes:btn_close;
		
		/**
		 *TitleWindows构造函数,添加2个侦听器:程序开始关闭,程序完全打开,程序初始化完成.
		 */
		public function TitleWindows()
		{
			this.addEventListener(ApplicationEvent.CLOSE, onTitleWindowsCloseHandle);
			this.addEventListener(ApplicationEvent.OPENED, onTitleWindowsOpenedHandle);
			this.addEventListener(ApplicationEvent.INITED, onTitleWindowsInitedHandle);
			tx_title = new TextField();
			btn_closes = new btn_close();
		}
		
		override public function configWindows(_w:Number, _h:Number):void
		{
			super.configWindows(_w, _h)
			sp_frame.graphics.moveTo(0, 20)
			sp_frame.graphics.lineTo(_w, 20)
			tx_title.height = 20
			tx_title.defaultTextFormat = ESTextFormat.LightBlueTitleTextFormat
			tx_title.width = _w
			tx_title.mouseEnabled = false;
			addChild(tx_title)
		}
		
		/**
		 * 当程序完全打开的时候的事件,对标题文字取消鼠标事件,同时修改标题为初始化文字.
		 */
		private function onTitleWindowsOpenedHandle(e:ApplicationEvent):void
		{
			btn_closes.addEventListener(MouseEvent.CLICK, onTitleWindowsCloseButtonClickHangle)
			btn_closes.x = getUiWidth - btn_closes.width
			addChild(btn_closes)
		}
		
		/**
		 * 当程序初始化完成的时候,会对标题建立拖拽侦听.使能端跟随DragWindows. 同时会对标题的文字激活一次动画效果.
		 */
		private function onTitleWindowsInitedHandle(e:ApplicationEvent):void
		{
			isInited = true;
			TextAnimation.Typing(tx_title);
		}
		
		/**
		 * 当程序的关闭按钮被点击的时候,触发的方法.(调用BaseWindwos.CloseApplication())
		 */
		private function onTitleWindowsCloseButtonClickHangle(e:MouseEvent):void
		{
			this.CloseApplication()
		}
		
		/**
		 *当程序开始关闭的时候,移除本抽象类的侦听器
		 */
		private function onTitleWindowsCloseHandle(e:ApplicationEvent):void
		{
		}
		
		/**
		 * 设置程序标题文字.
		 */
		public function set setApplicationTitle(t:String):void
		{
			tx_title.text = t+"";
		}
		
		/**
		 * 设置关闭按钮是否隐藏
		 */
		public function showCloseButton(e:Boolean=false ):void {
			this.btn_closes.visible=e
		}
	}
}