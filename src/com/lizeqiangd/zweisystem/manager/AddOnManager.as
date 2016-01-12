package com.lizeqiangd.zweisystem.manager
{
	
	/**
	 * 负责激活外部插件。
	 * @author Lizeqiangd
	 * 2014.04.02 增加全部
	 * 2015.03.19 移除Console
	 */
	
	import com.lizeqiangd.zweisystem.components.banword.SensitiveWordFilter;
	import com.lizeqiangd.zweisystem.components.texteffect.TextAnimation;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import com.greensock.plugins.*;
	import com.greensock.loading.*;
	
	public class AddOnManager
	{
		/**
		 * 激活GreenSock的全部动画
		 */
		public static function initTweenPlugin():void
		{
			TweenPlugin.activate([AutoAlphaPlugin, TintPlugin, BlurFilterPlugin,  GlowFilterPlugin, EndArrayPlugin]);
			TweenPlugin.activate([TransformAroundCenterPlugin, ShortRotationPlugin, TransformAroundPointPlugin]);
			//Cc.debug("TweenPlugin activated:AutoAlphaPlugin, TintPlugin, BlurFilterPlugin, MotionBlurPlugin, GlowFilterPlugin, EndArrayPlugin");
			//Cc.debug("TweenPlugin activated:TransformAroundCenterPlugin, ShortRotationPlugin, TransformAroundPointPlugin");
		}
		
		/**
		 * 激活 GreenSock的LoaderMax
		 */
		public static function initLoaderMax():void
		{
			LoaderMax.activate([ImageLoader, XMLLoader, MP3Loader]);
			//Cc.debug("LoaderMax activated: ImageLoader, XMLLoader, MP3Loader");
		}
		
		/**
		 * 激活敏感词列表.
		 * @param	extend_mode   特殊模式则开启google
		 */
		public static function initSensitiveWordFilter(extend_mode:Boolean = false):void
		{
			extend_mode ? SensitiveWordFilter.regSensitiveWords(SensitiveWordFilter.negativeList) : SensitiveWordFilter.regSensitiveWords(SensitiveWordFilter.googleBanList + SensitiveWordFilter.mark + SensitiveWordFilter.negativeList)
		}
		
	
	}}