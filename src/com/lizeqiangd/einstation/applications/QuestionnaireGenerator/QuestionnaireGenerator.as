package com.lizeqiangd.einstation.applications.QuestionnaireGenerator
{
	import com.lizeqiangd.zweisystem.abstract.windows.iApplication;
	import com.lizeqiangd.zweisystem.abstract.windows.TitleWindows;
	import com.lizeqiangd.zweisystem.events.ApplicationEvent;
	import com.lizeqiangd.zweisystem.events.UIEvent;
	import com.lizeqiangd.zweisystem.interfaces.button.btn_general;
	import com.lizeqiangd.zweisystem.interfaces.button.btn_general_s;
	import com.lizeqiangd.zweisystem.interfaces.checkbox.cb_content;
	import com.lizeqiangd.zweisystem.interfaces.datagird.dg_defaultDataGird;
	import com.lizeqiangd.zweisystem.interfaces.textinput.ti_general;
	import com.lizeqiangd.zweisystem.interfaces.textinput.ti_general_rect;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.ApplicationManager;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import flash.text.TextField;
	
	/**
	 * 问卷调查系统入口程序.
	 * @author Lizeqiangd
	 *
	 */
	
	public class QuestionnaireGenerator extends TitleWindows implements iApplication
	{
		private var qga:QuestionnaireGeneratorAPI = QuestionnaireGeneratorAPI.getInstance
		private var ssn:SystemStatusNotification
		private var qcreator:iApplication
		private var qncreator:iApplication
		
		public function QuestionnaireGenerator()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "BILIBILI Application - QuestionnaireGenerator - 问卷及题目总管理器 -";
			this.setApplicationName = "QuestionnaireGenerator";
			this.configWindows(850, 500)
			self = this
			this.addEventListener(ApplicationEvent.INIT, init);
			ssn = new SystemStatusNotification()
			ssn.y = 20
			ssn.init(this.getUiWidth, getUiHeight - 20)
			initUI()
			addChild(ssn)
			showCloseButton(false)
		
		}
		private var self:QuestionnaireGenerator
		private var dg_questions:dg_defaultDataGird
		private var dg_questionnaires:dg_defaultDataGird
		
		private var cb_content1:btn_general = new btn_general
		private var cb_content2:btn_general = new btn_general
		private var cb_content3:btn_general = new btn_general
		private var cb_content4:btn_general = new btn_general
		
		//private var cb_contentc_1:cb_content = new cb_content
		private var cb_contentc_2:cb_content = new cb_content
		private var cb_contentc_3:cb_content = new cb_content
		//
		private var btn_general0:btn_general_s = new btn_general_s
		private var btn_general1:btn_general = new btn_general
		private var btn_general2:btn_general = new btn_general
		
		private var question_type:uint = 1
		private var control_mode:uint = 2
		private var cache_questions_arr:Array = []
		private var cache_questionnaires_arr:Array = []
		
		private var btn_general3:btn_general_s = new btn_general_s
		
		private function initUI():void
		{
			cb_content1.x = 10
			cb_content2.x = 10
			cb_content3.x = 10
			cb_content4.x = 10
			cb_content1.y = 30
			cb_content2.y = 60
			cb_content3.y = 90
			cb_content4.y = 120
			cb_content1.title = '创建选择题'
			cb_content2.title = '创建填空题'
			cb_content3.title = '创建矩阵题'
			cb_content4.title = '创建问卷'
			addChild(cb_content1)
			addChild(cb_content2)
			addChild(cb_content3)
			addChild(cb_content4)
			
			cb_contentc_2.x = 10
			cb_contentc_3.x = 10
			cb_contentc_2.y = 180
			cb_contentc_3.y = 240
			cb_contentc_2.selected = true
			cb_contentc_2.name = '2'
			cb_contentc_3.name = '3'
			cb_contentc_2.title = '更新模式'
			cb_contentc_3.title = '删除模式'
			addChild(cb_contentc_2)
			addChild(cb_contentc_3)
			AnimationManager.changeColor(cb_contentc_2, 'lightblue')
			AnimationManager.changeColor(cb_contentc_3, 'red')
			
			btn_general1.x = 10
			btn_general1.y = 270
			btn_general1.title = '删除题目'
			addChild(btn_general1)
			AnimationManager.changeColor(btn_general1, 'red')
			btn_general2.x = 10
			btn_general2.y = 300
			btn_general2.title = '删除问卷'
			addChild(btn_general2)
			AnimationManager.changeColor(btn_general2, 'red')
			
			btn_general0.x = 40
			btn_general0.y = 470
			btn_general0.title = '刷新'
			addChild(btn_general0)
			
			btn_general3.x = 460
			btn_general3.y = 30
			btn_general3.title = '添加到问卷'
			addChild(btn_general3)
			
			dg_questions = new dg_defaultDataGird(dgr_questions)
			dg_questions.config(300, 480)
			dg_questions.y = 20
			dg_questions.x = 150
			addChild(dg_questions)
			
			dg_questionnaires = new dg_defaultDataGird(dgr_questionnaires)
			dg_questionnaires.config(300, 480)
			dg_questionnaires.y = 20
			dg_questionnaires.x = 550
			addChild(dg_questionnaires)
		}
		
		public function init(e:ApplicationEvent):void
		{
			refrush()
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
			qcreator = ApplicationManager.open('com.lizeqiangd.einstation.applications.QuestionnaireGenerator.QuestionCreator')
			qcreator.applicationMessage({'master': self})
			qncreator = ApplicationManager.open('com.lizeqiangd.einstation.applications.QuestionnaireGenerator.QuestionnaireCreator')
			qncreator.applicationMessage({'master': self})
		}
		
		private function onCBClick(e:UIEvent):void
		{
			switch (e.target)
			{
				case cb_content1:
					
					question_type = 1
					qcreator.applicationMessage({'type': question_type})
					break;
				case cb_content2:
					
					question_type = 3
					qcreator.applicationMessage({'type': question_type})
					break;
				case cb_content3:
					
					question_type = 4
					qcreator.applicationMessage({'type': question_type})
					break;
				case cb_content4: 
					//question_type = parseInt(e.target.name)
					qncreator.applicationMessage({'type': question_type})
					break;
				default: 
			}
		}
		
		private function onModeClick(e:UIEvent):void
		{
			cb_contentc_2.selected = false
			cb_contentc_3.selected = false
			e.target.selected = true
			switch (e.target)
			{
				case cb_contentc_2: 
					AnimationManager.changeColor(sp_frame, 'lightblue')
					AnimationManager.changeColor(tx_title, 'lightblue')
					break;
				case cb_contentc_3: 
					AnimationManager.changeColor(sp_frame, 'red')
					AnimationManager.changeColor(tx_title, 'red')
					break;
				default: 
			}
			control_mode = parseInt(e.target.name)
		}
		
		private function addApplicationListener():void
		{
			dg_questionnaires.addEventListener(UIEvent.SELECTED, onDGClick)
			dg_questions.addEventListener(UIEvent.SELECTED, onDGClick)
			cb_content1.addEventListener(UIEvent.CLICK, onCBClick)
			cb_content2.addEventListener(UIEvent.CLICK, onCBClick)
			cb_content3.addEventListener(UIEvent.CLICK, onCBClick)
			cb_content4.addEventListener(UIEvent.CLICK, onCBClick)
			cb_contentc_2.addEventListener(UIEvent.CLICK, onModeClick)
			cb_contentc_3.addEventListener(UIEvent.CLICK, onModeClick)
			btn_general2.addEventListener(UIEvent.CLICK, onButtonClick)
			btn_general1.addEventListener(UIEvent.CLICK, onButtonClick)
			btn_general0.addEventListener(UIEvent.CLICK, onButtonClick)
			btn_general3.addEventListener(UIEvent.CLICK, onButtonClick)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onButtonClick(e:UIEvent):void
		{
			var i:int = 0
			switch (e.target)
			{
				case btn_general0: 
					refrush()
					break;
				case btn_general1: 
					if (control_mode == 3)
					{
						for (i = 0; i < dg_questions.getSelectedArray.length; i++)
						{
							qga.call_api('delete_question', function(e:Object):void
								{
								
								}, {id: cache_questions_arr[dg_questions.getSelectedArray[i]].id})
						}
					}
					refrush()
					break;
				case btn_general2: 
					if (control_mode == 3)
					{
						for (i = 0; i < dg_questionnaires.getSelectedArray.length; i++)
						{
							qga.call_api('delete_questionnaire', function(e:Object):void
								{
								
								}, {id: cache_questionnaires_arr[dg_questionnaires.getSelectedArray[i]].id})
						}
					}
					refrush()
					break;
				case btn_general3: 
					cache_questionnaires_arr[dg_questionnaires.getSelectedArray[i]].id
					var question_arr:Array = []
					var questionnaire_id:String = cache_questionnaires_arr[dg_questionnaires.getSelectedArray[0]].id
					for (i = 0; i < dg_questions.getSelectedArray.length; i++)
					{
						question_arr.push(cache_questions_arr[dg_questions.getSelectedArray[i]].id)
					}
					qga.call_api('add_questionnaire_question', function(e:Object):void
						{
							qga.call_api('get_full_questionnaire', function(k:Object):void
								{
									qncreator.applicationMessage({'data': k});
								}, {id: questionnaire_id})
						
						}, {id: questionnaire_id, question_array: JSON.stringify(question_arr)})
					
					break;
				default: 
			}
		}
		
		private function refrush():void
		{
			ssn.anime('ssn.ssn_wait', 'loading')
			qga.call_api('list_question', function(e:Object):void
				{
					cache_questions_arr = e as Array
					dg_questions.dataProvider = e as Array
					ssn.clean()
				}, {page: 1, page_size: 100000})
			qga.call_api('list_questionnaire', function(e:Object):void
				{
					cache_questionnaires_arr = e as Array
					dg_questionnaires.dataProvider = e as Array
				ssn.clean()
				}, {page: 1, page_size: 100000})
		}
		
		private function onDGClick(e:UIEvent):void
		{
			switch (control_mode)
			{
				case 2: 
					if (e.target == dg_questions)
					{
						qga.call_api('get_question', function(e:Object):void
							{
								if (e)
								{
									qcreator.applicationMessage({'type': e.type, 'data': e});
								}
							}, {id: cache_questions_arr[dg_questions.getSelectedArray[0]].id})
					}
					if (e.target == dg_questionnaires)
					{
						qga.call_api('get_full_questionnaire', function(e:Object):void
							{
								qncreator.applicationMessage({'type': e.type, 'data': e});
							}, {id: cache_questionnaires_arr[dg_questionnaires.getSelectedArray[0]].id})
					}
				case 3: 
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
			if (e['refrush'])
			{
				this.refrush()
			}
			switch (e)
			{
				case "": 
					break;
				default: 
					break;
			}
		}
	}

}