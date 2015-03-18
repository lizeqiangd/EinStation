package com.zweisystem.applications.GraduationHelper.actives
{
	
	/**
	 * @author lizeqiangd
	 * @email $(DefaultEmail)
	 * @website $(DefaultSite)
	 */
	import com.zweisystem.abstracts.active.*
	import com.zweisystem.events.ActiveEvent;
	import com.zweisystem.events.UnitEvent;
	import com.zweisystem.net.AMFPHP;
	import com.zweisystem.system.applications.message.Message;
	
	public class ControlActive extends BaseActive implements iActive
	{
		public function ControlActive()
		{
			super("ControlActive")
			this.addEventListener(ActiveEvent.IN, onAddToHost)
			this.addEventListener(ActiveEvent.OUT, onRemoveToHost)
		
		}
		
		private function onAddToHost(e:ActiveEvent)
		{
			
			addUiListener()
		}
		
		private function onRemoveToHost(e:ActiveEvent)
		{
			
			removeUiListener()
		}
		
		private function addUiListener()
		{
			btn_submit.addEventListener(UnitEvent.CLICK, onSubmitClick)
			btn_manager.addEventListener(UnitEvent.CLICK, onManagerClick)
		}
		
		private function onSubmitClick(e:UnitEvent):void
		{
			if (tx_name.text == "")
			{
				return
			}
			if (tx_copy.text == "")
			{
				return
			}
			this.host.applicationMessage("wait")
			getAcitveManager.moveOutActiveByPoint("p1", "left")
			getAcitveManager.moveOutActiveByPoint("p2", "right")
			
			getAcitveManager.Active("ClassActive").activeMessage({type: "copy", copy: tx_copy.text})
			AMFPHP.callResult("GraduationHelper.loadModule2", onLoadModuleComplete, tx_name.text)
		}
		
		private function onLoadModuleComplete(e:Object)
		{
			this.host.applicationMessage("clean")
			if (e.state == "success")
			{
				getAcitveManager.movein("ClassActive", "p1")
				getAcitveManager.Active("ClassActive").activeMessage({type: "module",data:e.data})
			}
			if (e.state == "failed")
			{
				Message.GraduationHelper_Failed("没有查询到课程模块名")
				this.getAcitveManager.movein("ControlActive", "p1", "left")
				this.getAcitveManager.movein("InformationActive", "p2", "right")
			}
		}
			private function onManagerClick(e:UnitEvent):void
			{
				getAcitveManager.moveOutActiveByPoint("p2", "right")
				getAcitveManager.movein("ManagerActive", "p2", "right")
			}
			
			private function removeUiListener()
			{
			
			}
			
			public function activeMessage(msg:Object)
			{
				switch (msg)
				{
					case "": 
						break;
					default: 
						break;
				}
			
			}
			
			public function dispose()
			{
				removeUiListener()
				this.removeEventListener(ActiveEvent.IN, onAddToHost)
				this.removeEventListener(ActiveEvent.OUT, onRemoveToHost)
			
			}
		}
	
	}