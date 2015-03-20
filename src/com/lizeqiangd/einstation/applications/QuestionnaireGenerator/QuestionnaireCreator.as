package com.lizeqiangd.einstation.applications.QuestionnaireGenerator
{
	
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.events.UIEvent;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import flash.display.DisplayObject;
	//import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 */
	
	public class QuestionnaireCreator extends TitleWindows implements iApplication
	{
		private var ssn:SystemStatusNotification
		private var assest:Loader
		private var self:QuestionnaireCreator
		private var assest_mc:DisplayObject
		
		private var mode:String = ''
		private var master:iApplication
		
		public function QuestionnaireCreator()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "EinStation Application - QuestionnaireCreator -";
			this.setApplicationName = "QuestionnaireCreator";
			this.configWindows(600, 500)
			ssn = new SystemStatusNotification()
			ssn.y = 20
			ssn.init(this.getUiWidth, getUiHeight - 20)
			addChild(ssn)
			self = this
			assest = new Loader
			assest.load(new URLRequest('../assest/QuestionnaireGenerator/Interfaces.swf'))
			assest.contentLoaderInfo.addEventListener(Event.COMPLETE, onAssestLoadComplete)
			function onAssestLoadComplete(e:Event):void
			{
				assest_mc = assest.content
				assest_mc['selection_question'].addEventListener(UIEvent.SUBMIT, onSubmit);
				assest_mc['cloze_question'].addEventListener(UIEvent.SUBMIT, onSubmit);
				assest_mc['matrix_question'].addEventListener(UIEvent.SUBMIT, onSubmit);
			}
			this.addEventListener(ApplicationEvent.INIT, init);
		}
		
		private function onSubmit(e:UIEvent):void
		{
			trace(e.data)
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
					if (e.data)
					{
						assest_mc[mode]['getData'](e.data)
					}
					else
					{
						assest_mc[mode]['onClear']()
					}
					break;
				case 3: 
				case '3': 
					mode = "cloze_question"
					if (e.data)
					{
						assest_mc[mode]['getData'](e.data)
					}
					else
					{
						assest_mc[mode]['onClear']()
					}
					break;
				case 4: 
				case '4': 
					mode = "matrix_question"
					if (e.data)
					{
						assest_mc[mode]['getData'](e.data)
					}
					else
					{
						assest_mc[mode]['onClear']()
					}
					break;
				default: 
					break;
			}
			
			if (assest_mc)
			{
				addChild(assest_mc[mode])
			}
		}
	}

}