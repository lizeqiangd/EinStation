package com.lizeqiangd.zweisystem.system.applications.navigation
{
	import com.greensock.TweenLite;
	import com.lizeqiangd.zweisystem.components.encode.HexagonHelper;
	import com.lizeqiangd.zweisystem.components.PositionUtility;
	import com.lizeqiangd.zweisystem.system.config.ESSetting;
	import com.lizeqiangd.zweisystem.data.application.Application;
	import com.lizeqiangd.zweisystem.data.application.ApplicationExplorer;
	import com.lizeqiangd.zweisystem.events.UnitEvent;
	import com.lizeqiangd.zweisystem.interfaces.button.special.btn_hexagon;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.ApplicationManager;
	import com.lizeqiangd.zweisystem.components.StageProxy;
	import flash.utils.setTimeout
	import flash.display.Sprite;
	
	/**
	 * 本应用为菜单的按钮,由NavigationManager负责调度.
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 * @website http://www.lizeqiangd.com
	 * status 介绍
	 * 0：完全没有初始化
	 * 1：没有菜单状态
	 * 2：显示动画过程中
	 * 3：菜单显示完成状态
	 * 4：隐藏动画过程中
	 * 5: 按钮移动中
	 *
	 * 2013.06.30 初始化应用数据菜单转移给HostManager
	 * 2014.04.04 更改路径,目前没有什么新的创意和想法了...啧啧 凑合用吧.
	 * 2014.05.11 重新制作,漂亮多了~?
	 */
	public class ApplicationMenu extends Sprite
	{
		private var btn_app:btn_hexagon
		private var status:int = 0
		public var mc_content:Sprite
		private var icon_distance:int = ESSetting.NavigationApplicationMenuIconDistance
		private var icon_height_count:int = ESSetting.NavigationApplicationMenuIconHeightCount
		private var openApplicationDelay:int = ESSetting.NavigationApplicationMenuOpenApplicationDelay
		
		public function ApplicationMenu()
		{
			btn_showmenu.title = "显示菜单"
			mc_content = new Sprite
			addChild(mc_content)
			status = 1
			addMenuEventListener()
		}
		
		private function addMenuEventListener()
		{
			btn_showmenu.addEventListener(UnitEvent.CLICK, onMenuButtonClickHandle)
		}
		
		/**
		 * 菜单按钮点击后调度.
		 * @param	e
		 */
		private function onMenuButtonClickHandle(e:UnitEvent)
		{
			switch (status)
			{
				case 0: 
				case 1: 
					btn_showmenu.enable = false
					isCalcuatedSize = false
					nowDisplay = -1
					ApplicationExplorer.tempApplicationVector = new Vector.<Application>
					for (var i:int = 0; i < ApplicationExplorer.SystemApplication.length; i++)
					{
						ApplicationExplorer.tempApplicationVector.push(ApplicationExplorer.SystemApplication[i])
					}
					for (i = 0; i < ApplicationExplorer.NormalApplication.length; i++)
					{
						ApplicationExplorer.tempApplicationVector.push(ApplicationExplorer.NormalApplication[i])
					}
					for (i = 0; i < ApplicationExplorer.TestApplication.length; i++)
					{
						ApplicationExplorer.tempApplicationVector.push(ApplicationExplorer.TestApplication[i])
					}
					status = 2
					StageProxy.addEnterFrameFunction(createMenuButtonAnimation)
					break;
				case 3: 
					status = 4;
					btn_showmenu.enable = false
					removeMenuButtonAnimation()
					break;
				case 2: 
				case 4: 
					break
			}
		
		}
		///当前正在显示的按钮序数
		private var nowDisplay:int = -1
		///给只计算1次的总体积用的布尔值
		private var isCalcuatedSize:Boolean = false
		
		/**
		 * 显示菜单的动画效果.
		 */
		private function createMenuButtonAnimation()
		{
			nowDisplay++
			//当完全显示完成的时候的方法.
			if (nowDisplay == ApplicationExplorer.tempApplicationVector.length)
			{
				createMenuButtonAnimationComplete()
				return
			}
			btn_app = new btn_hexagon
			btn_app.addEventListener(UnitEvent.CLICK, onApplicationButtonHandle, false, 0, true)
			btn_app.dataProvider = ApplicationExplorer.tempApplicationVector[nowDisplay]
			btn_app.title = ApplicationExplorer.tempApplicationVector[nowDisplay].name
			btn_app.setColor = ApplicationExplorer.tempApplicationVector[nowDisplay].style
			mc_content.addChild(btn_app)
			btn_app.alpha = 0
			btn_app.x = HexagonHelper.calculateHorizontalPosition(nowDisplay, btn_app.width, btn_app.height, icon_distance, icon_height_count).x
			btn_app.y = HexagonHelper.calculateHorizontalPosition(nowDisplay, btn_app.width, btn_app.height, icon_distance, icon_height_count).y
			AnimationManager.fade_in(btn_app)
			
			if (!isCalcuatedSize)
			{
				//居中在NavigationBar中控制.
				isCalcuatedSize = true
				mc_content.y = -HexagonHelper.calculateHorizontalTotal(ApplicationExplorer.tempApplicationVector.length - 1, btn_app.width, btn_app.height, icon_distance, icon_height_count).y - 5
				mc_content.x = -100
				StageProxy.updateStageSize()
			}
		}
		
		/**
		 * 当显示菜单按钮动画完成时候调度
		 */
		private function createMenuButtonAnimationComplete()
		{
			btn_showmenu.title = "隐藏菜单"
			btn_showmenu.enable = true
			status = 3
			StageProxy.removeEnterFrameFunction(createMenuButtonAnimation)
		}
		
		/**
		 * 隐藏菜单动画
		 */
		private function removeMenuButtonAnimation()
		{
			for (var i:int = 0; i < mc_content.numChildren; i++)
			{
				var random:Number = Math.random() * Math.PI * 2
				var toX:Number = mc_content.getChildAt(i).x + 100 * Math.cos(random)
				var toY:Number = mc_content.getChildAt(i).y + 100 * Math.sin(random)
				TweenLite.to(mc_content.getChildAt(i), 1, {x: toX, y: toY, autoAlpha: 0})
			}
			setTimeout(removeMenuButtonAnimationComplete, 1100)
		}
		
		/**
		 * 当隐藏菜单动画时调度
		 */
		private function removeMenuButtonAnimationComplete()
		{
			mc_content.removeChildren()
			btn_showmenu.title = "显示菜单"
			btn_showmenu.enable = true
			status = 1
		}
		
		/**
		 * 当菜单中的按钮被点击的时候调度.
		 * @param	e
		 */
		private function onApplicationButtonHandle(e:UnitEvent)
		{
			dispatchEvent(new UnitEvent(UnitEvent.SELECTED))
			setTimeout(openApplication, openApplicationDelay, e.target.data.path)
		}
		
		/**
		 * 给打开程序有一段时间的延迟
		 * @param	e
		 */
		private function openApplication(e:String)
		{
			ApplicationManager.open(e)
		}
		
		/*
		   for (var i:int = 0; i < ApplicationExplorer.SystemApplication.length; i++)
		   {
		   k++
		   btn_app = new btn_hexagon
		   btn_app.addEventListener(UnitEvent.CLICK, onApplicationButtonHandle, false, 0, true)
		   btn_app.dataProvider = ApplicationExplorer.SystemApplication[i]
		   btn_app.title = ApplicationExplorer.SystemApplication[i].name
		   btn_app.setColor = "red"
		   mc_content.addChild(btn_app)
		   btn_app.alpha = 0
		   btn_app.x = HexagonHelper.calculateHorizontalPosition(k, btn_app.width, btn_app.height, icon_distance, icon_height_count).x
		   btn_app.y = HexagonHelper.calculateHorizontalPosition(k, btn_app.width, btn_app.height, icon_distance, icon_height_count).y
		   }
		   for (i = 0; i < ApplicationExplorer.NormalApplication.length; i++)
		   {
		   k++
		   btn_app = new btn_hexagon
		   btn_app.addEventListener(UnitEvent.CLICK, onApplicationButtonHandle, false, 0, true)
		   btn_app.dataProvider = ApplicationExplorer.NormalApplication[i]
		   btn_app.title = ApplicationExplorer.NormalApplication[i].name
		   btn_app.setColor = "orange"
		   mc_content.addChild(btn_app)
		   btn_app.alpha = 0
		   btn_app.x = HexagonHelper.calculateHorizontalPosition(k, btn_app.width, btn_app.height, icon_distance, icon_height_count).x
		   btn_app.y = HexagonHelper.calculateHorizontalPosition(k, btn_app.width, btn_app.height, icon_distance, icon_height_count).y
		
		   }
		   for (i = 0; i < ApplicationExplorer.TestApplication.length; i++)
		   {
		   k++
		   btn_app = new btn_hexagon
		   btn_app.addEventListener(UnitEvent.CLICK, onApplicationButtonHandle, false, 0, true)
		   btn_app.dataProvider = ApplicationExplorer.TestApplication[i]
		   btn_app.title = ApplicationExplorer.TestApplication[i].name
		   btn_app.setColor = "lightblue"
		   mc_content.addChild(btn_app)
		   btn_app.alpha = 0
		   btn_app.x = HexagonHelper.calculateHorizontalPosition(k, btn_app.width, btn_app.height, icon_distance, icon_height_count).x
		   btn_app.y = HexagonHelper.calculateHorizontalPosition(k, btn_app.width, btn_app.height, icon_distance, icon_height_count).y
		   }
		   addChild(mc_content)
		   mc_content.y = -mc_content.height - 5
		
		   status = 3
		   StageProxy.addEnterFrameFunction(onStageEnterFrame)
		   }
		
		
		
		   /*	private function startCreatingButton(type:String)
		   {
		   switch (type)
		   {
		   case "testapplication":
		   createTestApplicationButton()
		   break;
		   case "systemapplication":
		   createSystemApplicationButton()
		   break;
		   case "application":
		   createApplicationButton()
		   break;
		   default:
		   }
		   nowOpen = type
		
		   }
		
		   private function createSystemApplicationButton()
		   {
		   for (var i:int = 0; i < ApplicationExplorer.SystemApplication.length; i++)
		   {
		   btn_app = new btn_hexagon
		   btn_app.x = Math.floor(i / 3) * (btn_app.width + 5)
		   btn_app.y = (btn_app.height + 5) * (i % 3)
		   btn_app.dataProvider = ApplicationExplorer.SystemApplication[i]
		   btn_app.addEventListener(UnitEvent.CLICK, onApplicationButtonHandle, false, 0, true)
		   mc_content.addChild(btn_app)
		   btn_app.alpha = 0
		   }
		   }
		
		   private function createApplicationButton()
		   {
		   for (var i:int = 0; i < ApplicationExplorer.NormalApplication.length; i++)
		   {
		   btn_app = new btn_hexagon
		   btn_app.x = Math.floor(i / 3) * (btn_app.width + 5)
		   btn_app.y = (btn_app.height + 5) * (i % 3)
		   btn_app.dataProvider = ApplicationExplorer.NormalApplication[i]
		   btn_app.addEventListener(UnitEvent.CLICK, onApplicationButtonHandle, false, 0, true)
		   mc_content.addChild(btn_app)
		   btn_app.alpha = 0
		   }
		   }
		
		   private function createTestApplicationButton()
		   {
		   for (var i:int = 0; i < ApplicationExplorer.TestApplication.length; i++)
		   {
		   btn_app = new btn_hexagon
		   btn_app.x = Math.floor(i / 3) * (btn_app.width + 5)
		   btn_app.y = (btn_app.height + 5) * (i % 3)
		   btn_app.dataProvider = ApplicationExplorer.TestApplication[i]
		   btn_app.addEventListener(UnitEvent.CLICK, onApplicationButtonHandle, false, 0, true)
		   mc_content.addChild(btn_app)
		   btn_app.alpha = 0
		   }
		   }
		
		   private var moderater:int = 0
		   private const moderaterLimit:int = 5
		   private var nowDisplaying:int = 0
		
		   private function onStageEnterFrame():void
		   {
		   moderater++
		   switch (status)
		   {
		   case 3:
		   if (moderater > moderaterLimit)
		   {
		   moderater = 0
		   AnimationManager.fade_in(mc_content.getChildAt(nowDisplaying))
		   nowDisplaying++
		   if (nowDisplaying == mc_content.numChildren)
		   {
		   nowDisplaying = 0
		   status = 2
		   }
		   }
		   break;
		   case 4:
		   if (moderater > moderaterLimit)
		   {
		   moderater = 0
		   AnimationManager.fade_out(mc_content.getChildAt(nowDisplaying))
		   nowDisplaying++
		   if (nowDisplaying == mc_content.numChildren)
		   {
		   StageProxy.removeEnterFrameFunction(onStageEnterFrame)
		   nowDisplaying = 0
		   setTimeout(removeApplicationButtons, 1200)
		   }
		   }
		   break
		   default:
		   }
		 }*/
		
		private function removeApplicationButtons()
		{
			//StageProxy.removeEnterFrameFunction(onStageEnterFrame)
			
			status = 1
			mc_content.removeChildren()
			//	if (nextOpen !== nowOpen)
			//	{
			//		this.startCreatingButton(nextOpen)
			//	}
		}
		
		public function get content():Sprite
		{
			return mc_content
		}
	
	}
}

