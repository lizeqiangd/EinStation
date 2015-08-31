package com.lizeqiangd.zweisystem.abstract.windows
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowRenderMode;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class NativeWindows extends NativeWindow
	{
		/**
		 * 选择初始化windwos的样式.
		 * @param	windows_mode 0:drag 1:title
		 */
		private var windows:TitleWindows
		
		public function NativeWindows(n:NativeWindowInitOptions)
		{
			super(n)
			//if (!NativeWindow.isSupported)
			//{
				//throw new Error('NativeWindow is not supported!');
			//}
			//addChild(windows);
			var s:Sprite = new Sprite
			s.graphics.beginFill(0xff0000)
			s.graphics.drawRect(0, 0, 30, 30)
			s.graphics.endFill();			
			this.stage.addChild(s)
		}
	
	}
}