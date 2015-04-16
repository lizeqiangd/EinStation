package com.lizeqiangd.einstation.applications.QuestionnaireGenerator
{
	
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.events.UIEvent;
	import com.lizeqiangd.zweisystem.interfaces.button.btn_general;
	import com.lizeqiangd.zweisystem.interfaces.datagird.dg_defaultDataGird;
	import com.lizeqiangd.zweisystem.interfaces.label.la_general;
	import com.lizeqiangd.zweisystem.interfaces.textinput.ti_textfield;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * 问卷调查系统子程序: 问卷制作器
	 * @author Lizeqiangd
	 * @email lizeqiangd@gmail.com
	 */
	
	public class QuestionnaireCreator extends TitleWindows implements iApplication
	{
		private var ssn:SystemStatusNotification
		private var self:QuestionnaireCreator
		
		private var mode:String = ''
		private var master:iApplication
		private var qga:QuestionnaireGeneratorAPI = QuestionnaireGeneratorAPI.getInstance
		
		private var ti_title:ti_textfield
		private var ti_description:ti_textfield
		private var dg_questions:dg_defaultDataGird
		
		private var la_title:la_general
		private var la_date:la_general
		private var btn_1:btn_general
		private var btn_2:btn_general
		private var btn_3:btn_general
		
		private var cache_questionnaire:Object = {}
		
		public function QuestionnaireCreator()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "BILIBILI Application - 问卷内容编辑器 -";
			this.setApplicationName = "QuestionnaireCreator";
			this.configWindows(600, 500)
			ssn = new SystemStatusNotification()
			ssn.y = 20
			ssn.config(this.getUiWidth, getUiHeight - 20)
			addChild(ssn)
			self = this
			this.addEventListener(ApplicationEvent.INIT, init);
			showCloseButton(false)
			
			ti_title = new ti_textfield
			ti_title.x = 10
			ti_title.y = 30 + 30
			ti_title.config(280, 100)
			
			ti_description = new ti_textfield
			ti_description.x = 10
			ti_description.y = 140 + 30
			ti_description.config(280, 100)
			
			dg_questions = new dg_defaultDataGird(dgr_questions)
			dg_questions.config(300, 480)
			dg_questions.x = 300
			dg_questions.y = 20
			
			la_title = new la_general
			la_title.text = '没有参数'
			la_title.x = 10
			la_title.y = 30
			
			btn_1 = new btn_general
			btn_1.title = '提交'
			btn_1.x = 10
			btn_1.y = 470
			
			btn_2 = new btn_general
			btn_2.title = '清空数据'
			btn_2.x = 10 + 120 + 20
			btn_2.y = 470
			
			btn_3 = new btn_general
			btn_3.title = '删除选中题目'
			btn_3.x = 10 + 120 + 20
			btn_3.y = 470 - 30
			AnimationManager.changeColor(btn_3, 'red')
			
			la_date = new la_general
			la_date.x = 10
			la_date.y = 280
			la_date.title = '';
			
			addChild(dg_questions)
			addChild(ti_title)
			addChild(ti_description)
			addChild(la_title)
			addChild(btn_1)
			addChild(btn_2)
			addChild(btn_3)
			addChild(la_date)
		}
		
		public function init(e:ApplicationEvent):void
		{
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function onSubmit():void
		{
			//ssn.anime('ssn.ssn_wait', '发送请求中')
			//trace('********实际发送的数据********')
			//for (var i:String in e.data)
			//{
			//trace(i, e.data[i])
			//}
			//trace('********')
			//if (e.data.id == '创建模式')
			//{
			//qga.call_api('new_question', onComplete, e.data)
			//}
			//else
			//{
			//qga.call_api('update_question', onComplete, e.data)
			//}
			//function onComplete(k:Object):void
			//{
			//master.applicationMessage({"refrush": 1})
			////ssn.clean()
			//}
		}
		
		private function addApplicationListener():void
		{
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
			btn_1.addEventListener(UIEvent.CLICK, onClick)
			btn_2.addEventListener(UIEvent.CLICK, onClick)
			btn_3.addEventListener(UIEvent.CLICK, onClick)
		}
		
		private function onClick(e:UIEvent):void
		{
			switch (e.target)
			{
				case btn_1: 
					ssn.anime('ssn.ssn_wait', '发送请求中')
					if (la_title.title == '新建问卷模式')
					{
						qga.call_api('new_questionnaire', function(e:Object):void
							{
								master.applicationMessage( { 'refrush': 1 } )
								ssn.clean()
							}, {title: ti_title.title, description: ti_description.title, content: JSON.stringify([])})
					}
					else
					{
						qga.call_api('update_questionnaire', function(e:Object):void
							{
								master.applicationMessage( { 'refrush': 1 } )
								ssn.clean()
							}, {title: ti_title.title, description: ti_description.title, id: la_title.text, content: JSON.stringify(now_question_array)})
					}
					break;
				case btn_2: 
					clearFrom();
					break;
				case btn_3: 
					for (var i:int = dg_questions.getSelectedArray.length - 1; i >= 0; i--)
					{
						cache_questionnaire.splice(dg_questions.getSelectedArray[i], 1)
					}
					dg_questions.update()
					break;
				default: 
			}
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
			if (e.master)
			{
				master = e.master
			}
			
			if (e.data)
			{
				la_title.title = e.data.id+""
				ti_title.text = e.data.title+""
				ti_description.text = e.data.description+""
				la_date.text = e.data.update_time+""
				cache_questionnaire = e.data.questions
				this.dg_questions.dataProvider = e.data.questions
			}
			else
			{
				la_title.title = '新建问卷模式'
				clearFrom()
			}
		}
		
		private function get now_question_array():Array
		{
			var temp:Array = []
			for (var i:int = 0; i < cache_questionnaire.length; i++)
			{
				temp.push(cache_questionnaire[i].id)
			}
			return temp
		}
		
		private function clearFrom(e:* = null):void
		{
			this.ti_description.text = ''
			this.ti_title.text = ''
			this.dg_questions.dataProvider = [];
			cache_questionnaire = {}
		}
	}
}