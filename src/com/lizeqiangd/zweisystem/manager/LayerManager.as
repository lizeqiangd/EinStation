package com.lizeqiangd.zweisystem.manager
{
	import com.lizeqiangd.zweisystem.components.CompareClass;
	import com.lizeqiangd.zweisystem.components.debug.db;
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import com.lizeqiangd.zweisystem.abstract.windows.*;
	import com.lizeqiangd.zweisystem.abstract.layers.Layer
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.system.applications.message.Message;
	import flash.events.EventDispatcher;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	
	/**
	 * PopUpManager负责打开应用，并对他dispatchEvent(new ApplicationEvent(ApplicationEvent.OPENED))
	 * 然后根据应用所在层，分发至LayerManager。默认为LayerManager的顶层。并对应用进行居中。
	 * @author Lizeqiangd
	 * 2013.01.27 修改为应用事件,类被删除，融合进入LayerManager
	 * -----------------------------------------------------------
	 * LayerManager负责将建立完成的popup放入合适的层中，并显示和居中。
	 * 其实是管理所有显示在舞台上的实例
	 * 2012.10.29 修改onLayer成为getDisplayLayer
	 * 2013.01.27 修改抽象类组件，完善函数本身,融合PopupManager
	 * 2013.01.28 删除层数组，访问方式改为LayerManager["topLayer"]效率更高，方便理解。
	 * 2013.01.29 增加CompareClass处理FullWindows冲突问题
	 * 2013.01.20 将FullWindows移交给ApplicationManager管理，此类只负责开
	 * 2014.04.05 删除无用方法,更新逻辑.全部文字信息交给ESSetting
	 */
	public class LayerManager
	{
		public static const LayerManagerBackground:String = "backgroundLayer"
		public static const LayerManagerApplication:String = "applicationLayer";
		public static const LayerManagerFloat:String = "floatLayer";
		public static const LayerManagerAnimation:String = "animationLayer";
		public static const LayerManagerMessage:String = "messageLayer";
		public static const LayerManagerTop:String = "topLayer";
		
		private static var backgroundLayer:Layer;
		private static var applicationLayer:Layer;
		private static var floatLayer:Layer;
		private static var animationLayer:Layer;
		private static var messageLayer:Layer;
		private static var topLayer:Layer;
		private static var inited:Boolean = false
		
		/**
		 * 初始化全系统的显示层对象.并添加在StageProxy
		 */
		public static function init():void
		{
			if (inited)
			{
				trace("LayerManager.init:already inited.")
				return
			}
			inited = true
			
			backgroundLayer = new Layer(LayerManagerBackground, 0);
			applicationLayer = new Layer(LayerManagerApplication, 1);
			floatLayer = new Layer(LayerManagerFloat, 2);
			animationLayer = new Layer(LayerManagerAnimation, 3);
			messageLayer = new Layer(LayerManagerMessage, 4);
			topLayer = new Layer(LayerManagerTop, 5);
			StageProxy.addChild(backgroundLayer);
			StageProxy.addChild(applicationLayer);
			StageProxy.addChild(floatLayer);
			StageProxy.addChild(animationLayer);
			StageProxy.addChild(messageLayer)
			StageProxy.addChild(topLayer);
			StageProxy.addResizeFunction(onStageResize)
		}
		
		/**
		 * 直接从Class创建一个实例到显示层中.通常是系统级别应用和特殊用法.不建议直接使用.
		 * 如果Class是一个BaseWindows则按照常规走法,并会根据ApplicationEvent.CLOSED将其关闭删除.如果设定错误则程序会崩溃.
		 * 如果不是则会要求显示层,默认是顶层.
		 * 使用的话会触发一个ApplicationEvent.OPENED事件.使用完毕后务必卸载掉
		 * 同时返回这个Class的实例
		 * @param	c
		 * @return
		 */
		public static function createPopUp(c:Class, atLayer:String = ""):*
		{
			if (!inited)
			{
				db.log("LayerManager.createPopUp:not inited")
				return
			}
			
			db.log("LayerManager.createPopUp: opening[", c, "]")
			var o:* = null
			///检测是否为BaseWindows,如果是则完全按照常规
			if (CompareClass.isSuperClass(c, BaseWindows))
			{
				///建立程序实例，居中，添加到指定层，添加关闭侦听。
				o = new c;
				EventDispatcher(o).addEventListener(ApplicationEvent.CLOSED, removeApplicatoin, false, 0, true);
				PositionUtility.center(o);
				LayerManager.addChildLayer(o, o.getDisplayLayer);
				///根据不同类的程序作出判断
				switch (o.getDisplayLayer)
				{
					case LayerManagerApplication: 
					case LayerManagerFloat: 
					case LayerManagerAnimation: 
					case LayerManagerMessage: 
					case LayerManagerTop: 
						break;
					case LayerManagerBackground: 
						PositionUtility.setDisplayPosition(o, "TL")
						break;
					default: 
						db.log("LayerManager.createPopUp:[", c, "] is a BaseWindows but the layername is wrong!")
				}
			}
			else
			{ ///如果不是BaseWindows会强行写入目标所在层的属性 getDisplayLayer.!注意!.
				if (atLayer == "")
				{
					o.getDisplayLayer = LayerManagerTop
					LayerManager.addChildLayer(o, LayerManagerTop);
					db.log("LayerManager.createPopUp:[", c, "] is not a BaseWindows,directly open at " + atLayer)
				}
				else
				{
					o.getDisplayLayer = atLayer
					LayerManager.addChildLayer(o, atLayer);
					db.log("LayerManager.createPopUp:[", c, "] is not a BaseWindows,directly open at topLayer")
				}
			}
			o.dispatchEvent(new ApplicationEvent(ApplicationEvent.OPENED));
			return o;
		}
		
		public static function addChildLayer(o:DisplayObject, layername:String = ""):void
		{
			layername == "" ? layername = LayerManagerTop : null
			if (!inited)
			{
				db.log("LayerManager:not inited")
				return
			}
			if (LayerManager[layername])
			{
				LayerManager[layername].addChild(o);
				
				///信息层则处理方式特殊.
				
				if (layername == "messageLayer")
				{
					//trace("layer:",layername)
					///自动堆叠MessageBox
					o.x = o.x + int(messageLayer.numChildren - 1) * 20;
					o.y = o.y + int(messageLayer.numChildren - 1) * 20;
				}
			}
			else
			{
				db.log("LayerManager.addChildLayer:not found layer:", layername)
			}
		}
		
		/**
		 * 从层中移除一个显示对象,自定义对象需要准确的显示层.
		 * @param	o
		 * @param	fromLayer
		 */
		public static function removeChildLayer(o:*):void
		{
			if (!inited)
			{
				db.log("LayerManager:not inited")
				return
			}
			if (CompareClass.isSuperClass(o, BaseWindows))
			{
				LayerManager[BaseWindows(o).getDisplayLayer].removeChild(o);
			}
			else
			{
				try
				{
					LayerManager[o.getDisplayLayer].removeChild(o);
				}
				catch (e:*)
				{
					trace("LayerManager.removeChildLayer:can not found getDisplayLayer")
				}
			}
		}
		
		///类似于windows的点击窗口使之聚焦，成为最前。
		public static function setForceLayer(o:BaseWindows):void
		{
			if (!inited)
			{
				return
			}
			if (LayerManager[o.getDisplayLayer])
			{
				LayerManager[o.getDisplayLayer].setChildIndex(o, LayerManager[o.getDisplayLayer].numChildren - 1)
			}
		}
		
		///当舞台大小放生变化时候的函数，目前为防止应用出界
		private static function onStageResize():void
		{
			if (!inited)
			{
				return
			}
			for (var i:int = 0; i < applicationLayer.numChildren; i++)
			{
				PositionUtility.setDisplayBackToStage(applicationLayer.getChildAt(i));
			}
			for (var k :int= 0; k < messageLayer.numChildren; k++)
			{
				PositionUtility.setDisplayBackToStage(messageLayer.getChildAt(k));
			}
		} ///响应AppicationEvent.CLOSED事件。removeChild。
		
		private static function removeApplicatoin(e:ApplicationEvent):void
		{
			removeChildLayer(e.target)
		}
	
	}
}