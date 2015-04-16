package com.lizeqiangd.einstation.applications.QuestionnaireGenerator
{
	
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.events.UIEvent;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * 问卷调查系统子程序: 问题制作器
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 */
	
	public class QuestionCreator extends TitleWindows implements iApplication
	{
		private var ssn:SystemStatusNotification
		private var assest:Loader
		private var self:QuestionCreator
		private var assest_mc:DisplayObject
		
		private var mode:String = ''
		private var master:iApplication
		private var qga:QuestionnaireGeneratorAPI = QuestionnaireGeneratorAPI.getInstance
		
		public function QuestionCreator()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "BILIBILI Application - 题目内容编辑器 -";
			this.setApplicationName = "QuestionnaireCreator";
			this.configWindows(600, 500)
			ssn = new SystemStatusNotification()
			ssn.y = 20
			ssn.config(this.getUiWidth, getUiHeight - 20)
			addChild(ssn)
			self = this
			assest = new Loader
			assest.load(new URLRequest('assest/QuestionnaireGenerator/Interfaces.swf'),new LoaderContext(false,ApplicationDomain.currentDomain))
			assest.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssestLoadComplete)
			function onAssestLoadComplete(e:Event):void
			{
				assest_mc = assest.content
				assest_mc['selection_question'].addEventListener(UIEvent.SUBMIT, onSubmit);
				assest_mc['cloze_question'].addEventListener(UIEvent.SUBMIT, onSubmit);
				assest_mc['matrix_question'].addEventListener(UIEvent.SUBMIT, onSubmit);
			}
			this.addEventListener(ApplicationEvent.INIT, init);
			showCloseButton(false)
		}
		
		private function onSubmit(e:UIEvent):void
		{
			ssn.anime('ssn.ssn_wait', '发送请求中')
			trace('********实际发送的数据***********')
			for (var i:String in e.data)
			{
				trace(i, e.data[i])
				for (var s:String in e.data[i])
				{
					trace(i, s, e.data[i][s])
				}
			}
			trace('***********************************')
			if (e.data.id == '创建模式')
			{
				qga.call_api('new_question', onComplete, e.data)
			}
			else
			{
				qga.call_api('update_question', onComplete, e.data)
			}
			function onComplete(k:Object):void
			{
				master.applicationMessage({"refrush": 1})
				ssn.clean()
			}
		}
		
		public function init(e:ApplicationEvent):void
		{
			//this.visible = false
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function addApplicationListener():void
		{
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function removeApplicationListener():void
		{
			this.removeEventListener(ApplicationEvent.INIT, init);
			this.removeEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onApplicationClose(e:ApplicationEvent):void
		{
			removeApplicationListener();
		}
		
		public function dispose():void
		{
			dispatchEvent(new ApplicationEvent(ApplicationEvent.CLOSE))
		}
		
		public function applicationMessage(e:Object):void
		{
			this.visible = true
			if (mode)
			{
				
				removeChild(assest_mc[mode])
			}
			if (e.master)
			{
				master = e.master
			}
			switch (e.type)
			{
				case 1: 
				case 2: 
				case '1': 
				case '2': 
					mode = "selection_question"
					break;
				case 3: 
				case '3': 
					mode = "cloze_question"
					break;
				case 4: 
				case '4': 
					mode = "matrix_question"
					
					break;
				default: 
					break;
			}
			
			if (assest_mc)
			{
				if (e.data)
				{
					assest_mc[mode]['getData'](e.data)
				}
				else
				{
					assest_mc[mode]['la_id']['text'] = '创建模式'
					assest_mc[mode]['onClear']()
				}
				addChild(assest_mc[mode])
			}
		}
	}

}