package com.lizeqiangd.zweisystem.manager
{
	
	/**
	 * 负责激活外部插件。
	 * @author Lizeqiangd
	 * 2014.04.02 增加全部
	 */
	
	import com.lizeqiangd.zweisystem.components.banword.SensitiveWordFilter;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import com.junkbyte.console.Cc;
	import com.greensock.plugins.*;
	import com.greensock.loading.*;
	
	public class AddOnManager
	{
		/**
		 * 激活Console信息回馈组件
		 */
		public static function initCc()
		{
			Cc.start(StageProxy.stage);
			Cc.config.tracing = true;
			Cc.remoting = true;
			Cc.y = 200;
			Cc.width = 600;
			Cc.height = 500
			Cc.config.commandLineAllowed = true;
			Cc.debug("*******************************************");
			Cc.debug("Console is inited.");
		}
		
		/**
		 * 激活GreenSock的全部动画
		 */
		public static function initTweenPlugin()
		{
			TweenPlugin.activate([AutoAlphaPlugin, TintPlugin, BlurFilterPlugin, MotionBlurPlugin, GlowFilterPlugin, EndArrayPlugin]);
			TweenPlugin.activate([TransformAroundCenterPlugin, ShortRotationPlugin, TransformAroundPointPlugin]);
			Cc.debug("TweenPlugin activated:AutoAlphaPlugin, TintPlugin, BlurFilterPlugin, MotionBlurPlugin, GlowFilterPlugin, EndArrayPlugin");
			Cc.debug("TweenPlugin activated:TransformAroundCenterPlugin, ShortRotationPlugin, TransformAroundPointPlugin");
		}
		
		/**
		 * 激活 GreenSock的LoaderMax
		 */
		public static function initLoaderMax()
		{
			LoaderMax.activate([ImageLoader, XMLLoader, MP3Loader]);
			Cc.debug("LoaderMax activated: ImageLoader, XMLLoader, MP3Loader");
		}
		
		/**
		 * 激活敏感词列表.
		 * @param	extend_mode   特殊模式则开启google
		 */
		public static function initSensitiveWordFilter(extend_mode:Boolean = false)
		{
			extend_mode ? SensitiveWordFilter.regSensitiveWords(SensitiveWordFilter.negativeList) : SensitiveWordFilter.regSensitiveWords(SensitiveWordFilter.googleBanList + SensitiveWordFilter.mark + SensitiveWordFilter.negativeList)
		}
		
		/**
		 * 激活文字动画效果
		 */
		public static function initTextAnimation()
		{
			TextAnimation.init(StageProxy.stage)
		}
	
	}}