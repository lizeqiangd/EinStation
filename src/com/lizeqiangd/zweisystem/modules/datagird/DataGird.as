package com.lizeqiangd.zweisystem.modules.datagird
{
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.getDefinitionByName;
	
	/**
	 * DataGird.可以简便的使用制作出来的DataGird.其次可以自定义外观并拥有动画效果.
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 * 20141217
	 */
	public class DataGird extends Sprite
	{
		private var contentsRowClass:Class
		private var maxContents:int
		private var arrayRows:Array
		private var eventDispatcher:EventDispatcher
		private var nowAnimedId:int = 0
		
		/**
		 * 构造函数,初始化侦听器.
		 */
		public function DataGird()
		{
			eventDispatcher = new EventDispatcher
		}
		
		/**
		 * 设置DataGird的基本配置信息.
		 * @param	contenter 需要宿主显示对象,自动将自己addChild到宿主中
		 * @param	rowsId Rows的Class的全部名称.例如com.lizeqiangd.zweisystem.modules.datagird.ESDataGirdRowsExample
		 * @param	totalCounts 需要显示的总长度,不包括标题部分.
		 */
		public function config(contenter:DisplayObjectContainer, rows_path:String, totalCounts:int)
		{
			contenter.addChild(this)
			contentsRowClass = getDefinitionByName(rows_path) as Class;
			//var contentsRowClass:Class = getDefinitionByName(rowsId) as Class;
			arrayRows = new Array
			maxContents = totalCounts
		}
		
		/**
		 * 初始化本DataGird需要将所有数据放入一个数组中进行识别.
		 * @param	dataProvider Array对象,
		 */
		public function init(dataProvider:Array)
		{
			clean()
			var displayCount:int
			if (dataProvider.length < maxContents)
			{
				displayCount = dataProvider.length
			}
			else
			{
				displayCount = maxContents
			}
			for (var i:int = 0; i < displayCount; i++)
			{
				var r:* = new contentsRowClass
				r.rows_id = i
				r.dataProvider = dataProvider[i]
				r.y = r.height * i
				r.eventDispatcher = this.eventDispatcher
				arrayRows.push(r)
				this.addChild(r)
			}
		}
		
		/**
		 * 清理掉本DataGird涉及的全部子类显示对象
		 * 执行本DataGird内全部Row.dispose()同时赋空值
		 * 同时将arrayRows赋予新数组,原数组引用为0会被gc.
		 * 为了防止bug还会清理掉可能正在动画中的EnterFrame方法.
		 */
		public function clean()
		{
			StageProxy.removeEnterFrameFunction(onRowsAnimation)
			for (var i:int = 0; i < arrayRows.length; i++)
			{
				arrayRows[i].dispose()
				arrayRows[i] = null
			}
			arrayRows = new Array
			this.removeChildren()
		}
		
		/**
		 * 该方法由外部触发,一旦触发将会在StageProxy内的EnterFrame中添加方法
		 * 用于实行逐帧动画效果.
		 * 先触发所有Rows.rowsAnimationInit()
		 */
		public function animation()
		{
			nowAnimedId = 0
			for (var i:int = 0; i < arrayRows.length; i++)
			{
				arrayRows[i].rowsAnimationInit()
			}
			StageProxy.addEnterFrameFunction(onRowsAnimation)
		}
		
		/**
		 * 逐帧执行Rows.rowsAnimation()方法
		 */
		private function onRowsAnimation()
		{
			arrayRows[nowAnimedId].rowsAnimation()
			nowAnimedId++
			nowAnimedId == arrayRows.length ? StageProxy.removeEnterFrameFunction(onRowsAnimation) : null;
		}
		
		/**
		 * 添加对本DataGird的侦听,本类负责传达内部Row的全部事件.
		 */
		public function addRowsListener(e:String, func:Function, useCapture:Boolean = false, priority:int = 0, userWeakRefernce:Boolean = false)
		{
			eventDispatcher.addEventListener(e, func, useCapture, priority, userWeakRefernce)
		/*for (var i:int = 0; i < arrayRows.length; i++)
		   {
		   trace("addRowsListener", i)
		   EventDispatcher(arrayRows[i]).addEventListener(e, func, false, 0, true)
		 }*/
		}
		
		/**
		 * 移除本DataGird的事件侦听器(全部row的都不会进行反馈)
		 */
		public function removeRowsListener(e:String, func:Function)
		{
			eventDispatcher.removeEventListener(e, func)
		/*for (var i:int = 0; i < arrayRows.length; i++)
		   {
		   EventDispatcher(arrayRows[i]).removeEventListener(e, func)
		
		 }*/
		}
	}

}