package com.lizeqiangd.zweisystem.system.applications.title
{
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	import com.lizeqiangd.zweisystem.system.config.ESFilter;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation
	import com.lizeqiangd.zweisystem.system.config.ESTextFormat;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.abstract.windows.BaseWindows;
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 * 2013.02.08 制作
	 * 2014.03.31 标题文字的显示设定重新审查制作.
	 * 2014.05.10 修复文字过高的bug
	 */
	
	public class TitleBar extends BaseWindows implements iApplication
	{
		private var frame:Sprite
		private var bg:Sprite
		private var tf:TextField
		
		public function TitleBar()
		{
			this.setDisplayLayer = "topLayer";
			this.setApplicationName = "TitleBar";
			this.setFocusAble = false
			
			addEventListener(ApplicationEvent.OPENED, init)
		}
		
		///初始化标题栏
		public function init(e:ApplicationEvent):void
		{
			removeEventListener(ApplicationEvent.OPENED, init)
			
			tf = new TextField
			frame = new Sprite
			bg = new Sprite
			
			frame.filters = [ESFilter.DefaultOrangeGlowFilter];
			tf.mouseEnabled = false;
			tf.defaultTextFormat = ESTextFormat.DefaultTextFormat;
			//tf.filters = [ESFilter.DefaultOrangeGlowFilter];
			tf.mouseEnabled=false
			
			this.addChild(bg)
			this.addChild(frame)
			this.addChild(tf)
			
			addApplicationListener()
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		
		}
		
		private function addApplicationListener():void
		{
			bg.addEventListener(MouseEvent.CLICK, onTitleClick)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function removeApplicationListener():void
		{
			bg.removeEventListener(MouseEvent.CLICK, onTitleClick)
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent):void
		{
			dispose()
		}
		
		private function makeTitleFrame():void
		{
			frame.graphics.clear()
			frame.graphics.lineStyle(1, 0xFF9900, 1)
			frame.graphics.moveTo(0, 0)
			frame.graphics.lineTo(20, 20)
			frame.graphics.lineTo(tf.textWidth + 20, 20)
			frame.graphics.lineTo(tf.textWidth + 40, 0)
			
			bg.graphics.clear()
			bg.graphics.beginFill(0x000000, 0.5)
			bg.graphics.moveTo(0, 0)
			bg.graphics.lineTo(20, 20)
			bg.graphics.lineTo(tf.textWidth + 20, 20)
			bg.graphics.lineTo(tf.textWidth + 40, 0)
			bg.graphics.lineTo(0, 0)
		}
		
		///触发标题点击时候的事件.
		private function onTitleClick(e:MouseEvent):void
		{
			this.dispatchEvent(e)
		}
		
		///直接通过applicationMessage(s:String)发送文字至显示.
		public function applicationMessage(e:Object):void
		{
			tf.text = e as String
			//trace("title",e)
			tf.x = 19
			tf.width = tf.textWidth + 20
			makeTitleFrame()
			tf.height = tf.textHeight+5
			TextAnimation.Typing(tf)
			frame.alpha = 0
			bg.alpha = 0
			AnimationManager.fade_in(frame)
			AnimationManager.fade_in(bg)
		}
		
		public function dispose():void
		{
			removeApplicationListener();
		}
	
	}

}