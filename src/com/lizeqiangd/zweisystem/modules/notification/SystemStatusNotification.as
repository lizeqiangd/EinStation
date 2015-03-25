package com.lizeqiangd.zweisystem.modules.notification
{
	import com.lizeqiangd.zweisystem.system.config.ESPath;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.system.config.ESTextFormat;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	//import com.lizeqiangd.zweisystem.managers.SEManager;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	
	/**
	 * SystemStatusNotification是我做过比较成功的一个动画管理类.
	 * 使用方法很简单,通常的默认用法是:
	 * var ssn:SystemStatusNotification=new SystemStatusNotification()
	 * ssn.init(300,300,this)用于显示位置.你可以选择前两个为0这样你好在宿主位置处管理.
	 * ssn.anime("your anime","your text")
	 * ssn.anime("","loading")
	 * ssn.clean()
	 * ssn.dispose()
	 *
	 * 当然你也可以选择没有动画的纯暗淡遮罩使用.
	 *
	 * @author:Lizeqiand
	 * @update:2014.03.30 更改内部方法,精简并更高效率
	 */
	public class SystemStatusNotification extends Sprite
	{
		//	private const defaultAnimeClassPreAddress = "com.lizeqiangd.zweisystem."
		private var mc_shadow:Shape;
		private var nowAnime:MovieClip;
		private var isMasked:Boolean
		private var isAnimeExisted:Boolean
		private var isUseText:Boolean
		private var tf:TextField
		
		/**
		 * 初始化SystemStatusNotification,并输入基本参数即可运作,你可以输入载体,也可以不输入自行addChild.
		 * @param	_Width  显示范围宽度 会左右各减少1(默认是300)
		 * @param	_Height 显示范围高度 会上下各减少1(默认是200)
		 * @param	_displayContenter 显示的载体
		 */
		public function init(_Width:Number = 300, _Height:Number = 200, _displayContenter:DisplayObjectContainer = null):void
		{
			//初始化文字格式设定.
			tf = new TextField
			tf.defaultTextFormat = ESTextFormat.DefaultTextFormat
			tf.mouseEnabled = false
			tf.selectable = false
			//初始化遮罩层设定
			mc_shadow = new Shape()
			mc_shadow.graphics.beginFill(0, 1);
			mc_shadow.graphics.drawRect(0, 0, 10, 10);
			mc_shadow.graphics.endFill();
			mc_shadow.visible = false;
			mc_shadow.x = 0.5
			mc_shadow.y = 0.5
			this.addChild(mc_shadow);
			isMasked = false
			isAnimeExisted = false
			if (_displayContenter)
			{
				_displayContenter.addChild(this)
			}
			resize(_Width, _Height);
		
		}
		
		/**
		 * 重新设定显示范围
		 * @param	_Width  显示范围宽度 会左右各减少1 默认为0,则不动仅仅更新中间动画效果位置
		 * @param	_Height 显示范围高度 会上下各减少1 默认为0,则不动仅仅更新中间动画效果位置
		 */
		public function resize(_Width:Number = 0, _Height:Number = 0):void
		{
			if (_Width > 0 || _Height > 0)
			{
				mc_shadow.width = _Width - 1;
				mc_shadow.height = _Height - 1;
			}
			if (isAnimeExisted)
			{
				nowAnime.x = mc_shadow.width / 2 - nowAnime.width / 2;
				nowAnime.y = mc_shadow.height / 2 - nowAnime.height / 2;
			}
			if (isUseText)
			{
				if (isAnimeExisted)
				{
					nowAnime.y = nowAnime.y - tf.textHeight / 2 - 5
					tf.x = mc_shadow.width / 2 - tf.width / 2
					tf.y = nowAnime.y + nowAnime.height
				}
				else
				{
					tf.x = mc_shadow.width / 2 - tf.width / 2;
					tf.y = mc_shadow.height / 2 - tf.textHeight / 2;
				}
			}
		}
		
		/**
		 * 主要方法..开始执行动画
		 * @param	AnimationClassAddress 目标动画的Class路径.不需要库前缀.
		 * @param	InformationText 显示需要显示的文字在动画下面.
		 */
		public function anime(AnimationClassPath:String = "", InformationText:String = ""):void
		{
			this.parent.setChildIndex(this,this.parent.numChildren-1)
			//当ssn没有遮罩时,增加遮罩
			if (!isMasked)
			{
				AnimationManager.fade(mc_shadow, 0.7);
				isMasked = true;
			}
			//当ssn已经存在动画效果时候,卸载掉当前动画
			if (isAnimeExisted)
			{ //忘记方法了.↓这里.
				nowAnime.stop()
				removeChild(nowAnime);
				nowAnime = null;
			}
			//当有输入动画Class路径时候.
			if (AnimationClassPath)
			{
				var ClassReference:Object = getDefinitionByName(ESPath.AnimePath + AnimationClassPath) as Class;
				nowAnime = new ClassReference();
				addChild(nowAnime);
				isAnimeExisted = true
			}
			//当有文字输入的时候
			if (InformationText !== "")
			{
				tf.text = InformationText
				tf.width = tf.textWidth + 5
				tf.height = tf.textHeight + 3
				addChild(tf)
				TextAnimation.Typing(tf)
				isUseText = true
			}
			else
			{
				if (isUseText)
				{
					removeChild(tf)
				}
				isUseText = false
				tf.text = ""
				
			}
			resize()
		}
		
		/**
		 * 主要方法..结束动画显示,
		 */
		public function clean():void
		{
			this.parent.setChildIndex(this,this.parent.numChildren-1)
			//消除遮罩层
			if (isMasked)
			{
				AnimationManager.fade_out(mc_shadow);
				isMasked = false;
			}
			//当ssn已经存在动画效果时候,卸载掉当前动画
			if (isAnimeExisted)
			{ //忘记方法了.↓这里.
				nowAnime.stop()
				removeChild(nowAnime);
				nowAnime = null;
				isAnimeExisted = false
			}
			//当有文字输入的时候
			if (isUseText)
			{
				removeChild(tf)
				isUseText = false
			}
		}
		
		/**
		 * 销毁本ssn.全部清除外加赋null
		 */
		public function dispose():void
		{
			clean()
			removeChildren()
			mc_shadow = null
			tf = null
			nowAnime = null
		}
	}
}