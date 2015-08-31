package com.lizeqiangd.zweisystem.system.applications.message
{
	import com.lizeqiangd.zweisystem.animations.messbox.mb_yellow_interrogation;
	import com.lizeqiangd.zweisystem.events.UIEvent;
	import com.lizeqiangd.zweisystem.interfaces.button.btn_general_s;
	import com.lizeqiangd.zweisystem.interfaces.textinput.ti_textfield;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.utils.setTimeout
	import flash.utils.setInterval
	import flash.utils.clearInterval
	import flash.utils.getDefinitionByName;
	
	/**
	 * @author Lizeqiangd
	 * 对话框标准实例.
	 * 2013.06.21 修改部分逻辑，让对话框更流畅
	 * 2013.06.21 根本无法优化，全部重做
	 * 2014.04.04 优化更新,增加注释.
	 * 2015.04.09 移除对FLash pro的依赖.完全使用as3重新绘制.
	 */
	public class Messbox extends TitleWindows
	{
		///自动关闭窗口的时间默认值.
		private const closeDelay:int = 4000;
		///自动重复播放动画的默认时间值
		private const replayAnimeDelay:int = 4000;
		//默认的动画路径.
		private const MessageBoxAnimePath:String = 'com.lizeqiangd.zweisystem.animations.messbox.'
		
		public var mc_btn1:btn_general_s
		public var mc_btn2:btn_general_s
		public var mc_color:Sprite
		public var tx_text:ti_textfield
		private var mc_anime:*;
		
		private var intervalId:uint = 0
		private var _func1:Function
		private var _func2:Function
		private var config:Object
		private var isAutoRepeat:Boolean = false
		private var isAutoClose:Boolean = false
		private var inited:Boolean = false
		
		public function Messbox()
		{
			this.setDisplayLayer = "messageLayer";
			this.setApplicationName = "MessageBox";
			this.setApplicationTitle = "Notification"
			this.setOpeningAnimationType = "popup"
			this.setMutiExistEnable = true;
			this.addEventListener(ApplicationEvent.INIT, init);
			configWindows(200, 200)
			createUI()
		}
		
		private function createUI():void
		{
			mc_btn1 = new btn_general_s
			mc_btn2 = new btn_general_s
			
			mc_btn1.x = 10
			mc_btn1.y = 175
			mc_btn2.x = 110
			mc_btn2.y = 175
			addChild(mc_btn1)
			addChild(mc_btn2)
			
			tx_text = new ti_textfield
			tx_text.removeFrame()
			tx_text.y = 71
			tx_text.config(getUiWidth, 100)
			addChild(tx_text)
			
			mc_color = new Sprite
			mc_color.y = 20
			mc_color.graphics.beginFill(0, 0.5)
			mc_color.graphics.drawRect(0, 0, getUiWidth, 50)
			mc_color.graphics.endFill()
			addChild(mc_color)
			
			setChildIndex(sp_frame, this.numChildren - 1)
			sp_frame.graphics.moveTo(0, 70)
			sp_frame.graphics.lineTo(getUiWidth, 70)
			sp_frame.graphics.moveTo(0, 170)
			sp_frame.graphics.lineTo(getUiWidth, 170)
		
		}
		
		/**
		 * 该方法是自然打开窗口后实现,因此次方法会在传入dataProvider后使用.
		 * 所有信息都会在本方法中录入.
		 * @param	e
		 */
		private function init(e:ApplicationEvent):void
		{
			if (inited)
			{
				return
			}
			inited = true
			
			addApplicationListener();
			switch (config.type)
			{
			case "show": 
				this.btn1 = config.btn1 ? config.btn1 : "关闭";
				this.mc_btn2.visible = false;
				this.mc_btn1.x = 60;
				break;
			case "confirm": 
				this.btn1 = config.btn1 ? config.btn1 : "确定";
				this.btn2 = config.btn2 ? config.btn2 : "取消";
				break;
			case "info": 
				config.anime = "mb_blue_excalmatory_motion"
				CONFIG::LOWANIMATION
			{
				config.anime = "mb_blue_excalmatory"
			}
				config.animeText1 = "系统提示信息";
				config.animeText2 = "System Information";
				config.replayAnime = false
				this.mc_btn2.visible = false;
				this.mc_btn1.x = 60;
				this.btn1 = "关闭";
				break;
			default: 
			}
			this.anime = {anime: config.anime, title1: config.animeText1, title2: config.animeText2};
			//this.setApplicationTitle = config.title;
			this.info = config.info;
			this.color = config.color;
			this.isAutoRepeat = config.replayAnime ? true : false;
			//this.btn_close
			this.isAutoClose = config.autoClose ? true : false;
			showCloseButton(config.showCloseButton)
			//this.btn_close.visible = config.showCloseButton;
			//SoundManager.play(o.sound);
			//mc_anime.gotoAndPlay(1)
			//mc_anime.mc_anime.gotoAndPlay(1)
			if (isAutoRepeat)
			{
				intervalId = setInterval(replayAnimeHandle, replayAnimeDelay)
			}
			if (isAutoClose)
			{
				
				setTimeout(closeMessageBox, closeDelay, null)
			}
			addChild(mc_anime);
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
		
		}
		
		///增加侦听器
		private function addApplicationListener():void
		{
			mc_btn1.addEventListener(UIEvent.CLICK, onButtonFunction);
			mc_btn2.addEventListener(UIEvent.CLICK, onButtonFunction);
			this.addEventListener(ApplicationEvent.CLOSE, closeMessageBox)
			this.addEventListener(ApplicationEvent.INITED, onApplicationInited)
		}
		
		///当初始化完毕后,激活所有鼠标操作对象.
		private function onApplicationInited(e:ApplicationEvent):void
		{ ///关闭所有非触发按钮的鼠标事件
			for (var i:Object in this)
			{
				i.mouseEnabled = false
			}
			mc_btn1.mouseEnabled = true
			mc_btn2.mouseEnabled = true
			tx_text.mouseEnabled = true
			//mc_bg.mouseEnabled = true
			//mc_title.mouseEnabled = true
			//btn_close.mouseEnabled = true
		}
		
		///删除侦听器
		private function removeApplicationListener():void
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			mc_btn1.removeEventListener(UIEvent.CLICK, onButtonFunction);
			mc_btn2.removeEventListener(UIEvent.CLICK, onButtonFunction);
			this.removeEventListener(ApplicationEvent.CLOSE, closeMessageBox)
		}
		
		///点击按钮的时候进行反馈.无论点击什么都会关闭该窗口.
		private function onButtonFunction(e:UIEvent):void
		{
			switch (e.target.name)
			{
			case "mc_btn1": 
				try
				{
					_func1()
				}
				catch (f:*)
				{ //trace("func1",f)
				}
				break;
			case "mc_btn2": 
				try
				{
					_func2()
				}
				catch (h:*)
				{ //trace("func2",h)
				}
				break;
			}
			closeMessageBox(null)
		}
		
		///当按钮触发关闭窗口的时候,会自动删除全部侦听器.
		private function closeMessageBox(e:ApplicationEvent):void
		{
			for (var i:Object in this)
			{
				i.mouseEnabled = false
			}
			try
			{
				mc_anime.stop();
				mc_anime.mc_anime.stop();
			}
			catch (e:*)
			{
			}
			if (intervalId > 0)
			{
				clearInterval(intervalId)
			}
			removeApplicationListener();
			//	removeChild(mc_anime);
			this.CloseApplication()
		}
		
		///自动关闭方法
		private function set timeToClose(value:Boolean):void
		{
			isAutoClose = value;
		}
		
		//自动重播方法
		private function set replayAnime(value:Boolean):void
		{
			isAutoRepeat = value
		}
		
		//设置动画名称以及动画对象的class
		private function set anime(o:Object):void
		{
			//var ClassReference:Class = getDefinitionByName('com.lizeqiangd.zweisystem.animations.messbox.mb_yellow_interrogationcom.lizeqiangd.zweisystem.animations.messbox.mb_blue_excalmatory_motion') as Class;
			//mc_anime = (new ClassReference() as MovieClip);
			//mc_anime.y = 15;
			//addChild(mc_anime)
			
			trace(MessageBoxAnimePath + o.anime)
			trace('com.lizeqiangd.zweisystem.animations.messbox.mb_blue_excalmatory_motion')
			var ClassReference:Class = getDefinitionByName(MessageBoxAnimePath + o.anime) as Class;
			mc_anime = (new ClassReference() as MovieClip);
			mc_anime.y = 20;
			//mc_anime.stop()
			//mc_anime.mc_anime.stop()
			mc_anime.tx_title1.text = o.title1; //"系统错误";
			mc_anime.tx_title2.text = o.title2; //"System Error";
		}
		
		///设置动画背景颜色
		private function set color(s:String):void
		{
			if (s)
			{
				AnimationManager.changeColor(this.mc_color, s);
			}
		}
		
		///设置信息
		private function set info(s:String):void
		{
			this.tx_text.text = s;
			TextAnimation.Typing(tx_text.textfield);
		}
		
		///设置左边按钮的文字
		private function set btn1(s:String):void
		{
			this.mc_btn1.title = s;
		}
		
		///设置右边按钮的文字
		private function set btn2(s:String):void
		{
			this.mc_btn2.title = s;
		}
		
		///设置左边按钮触发的方法
		public function set func1(value:Function):void
		{
			_func1 = value;
		}
		
		///设置右边按钮触发的方法
		public function set func2(value:Function):void
		{
			_func2 = value;
		}
		
		/**
		 * 重要方法,初始化之前务必传入所有信息.
		 */
		public function set dataProvider(value:Object):void
		{
			config = value;
		}
		
		///当触发动画重播时
		private function replayAnimeHandle():void
		{
			mc_anime.gotoAndPlay(1);
			mc_anime.mc_anime.gotoAndPlay(1);
		}
	}
}