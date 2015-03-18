package com.lizeqiangd.zweisystem.abstract.windows
{
	import adobe.utils.CustomActions;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
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
		//private static const _btn_close:String = "btn_close";
		//private static const _mc_title:String = "mc_title";
		//private static const _tx_title:String = "tx_title";
		
		private var orignalTitle:String = ""
		private var isInited:Boolean = false
		
		private var tx_title:TextField;
		//private var btn_close
		/**
		 *TitleWindows构造函数,添加2个侦听器:程序开始关闭,程序完全打开,程序初始化完成.
		 */
		public function TitleWindows()
		{
			this.addEventListener(ApplicationEvent.CLOSE, onTitleWindowsCloseHandle);
			this.addEventListener(ApplicationEvent.OPENED, onTitleWindowsOpenedHandle);
			this.addEventListener(ApplicationEvent.INITED, onTitleWindowsInitedHandle);
				
			tx_title = new TextField()
		}
		
		override public function configWindows(_w:Number, _h:Number):void
		{
			super.configWindows(_w, _h)
			sp_frame.graphics.moveTo(0, 20)
			sp_frame.graphics.lineTo(_w, 20)	
			tx_title.height = 20
			tx_title.defaultTextFormat = ESTextFormat.LightBlueTitleTextFormat
			tx_title.width = _w
			//tx_title.text = "Initializing.";
			tx_title.mouseEnabled = false;
			addChild(tx_title)
		}
		
		/**
		 * 当程序完全打开的时候的事件,对标题文字取消鼠标事件,同时修改标题为初始化文字.
		 */
		private function onTitleWindowsOpenedHandle(e:ApplicationEvent):void
		{
			
			try
			{
				//orignalTitle = tx_title.text;
			}
			catch (e:*)
			{
				//trace("TitleWindows配置错误，找不到需要的实例,请检查是否放置tx_title");
			}
		
		}
		
		/**
		 * 当程序初始化完成的时候,会对标题建立拖拽侦听.使能端跟随DragWindows. 同时会对标题的文字激活一次动画效果.
		 */
		private function onTitleWindowsInitedHandle(e:ApplicationEvent):void
		{
			try
			{
				//getChildByName(TitleWindows._btn_close).addEventListener(MouseEvent.CLICK, onTitleWindowsCloseButtonClickHangle);
				
			}
			catch (e:*)
			{
				//trace("TitleWindows配置错误，找不到需要的实例,请检查是否放置btn_close");
			}
			try
			{
				
					//getChildByName(TitleWindows._mc_title).addEventListener(MouseEvent.MOUSE_DOWN, onDragWindowsStartDrag);
					//getChildByName(TitleWindows._mc_title).addEventListener(MouseEvent.MOUSE_UP, onDragWindowsStopDrag);
			}
			catch (e:*)
			{
				//trace("TitleWindows配置错误，找不到需要的实例,请检查是否放置mc_title");
			}
			isInited = true;
			TextAnimation.Typing(tx_title);
		}
		
		/**
		 * 当程序的关闭按钮被点击的时候,触发的方法.(调用BaseWindwos.CloseApplication())
		 */
		private function onTitleWindowsCloseButtonClickHangle(e:MouseEvent)
		{
			this.CloseApplication()
		}
		
		/**
		 *当程序开始关闭的时候,移除本抽象类的侦听器
		 */
		private function onTitleWindowsCloseHandle(e:ApplicationEvent)
		{
			//getChildByName(TitleWindows._btn_close).removeEventListener(MouseEvent.CLICK, onTitleWindowsCloseButtonClickHangle);
			//getChildByName(TitleWindows._mc_title).removeEventListener(MouseEvent.MOUSE_DOWN, onDragWindowsStartDrag);
			//getChildByName(TitleWindows._mc_title).removeEventListener(MouseEvent.MOUSE_UP, onDragWindowsStopDrag);
		}
		
		/**
		 * 设置程序标题文字.
		 */
		public function set setApplicationTitle(t:String)
		{
			tx_title.text = t;
			if (true)
			{
				TextAnimation.Typing(tx_title);
			}
		}
	}
}