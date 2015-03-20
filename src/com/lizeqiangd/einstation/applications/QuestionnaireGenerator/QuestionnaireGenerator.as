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
	import com.lizeqiangd.zweisystem.interfaces.datagird.dgr_defaultDataGirdRow;
	import com.lizeqiangd.zweisystem.interfaces.textinput.ti_general;
	import com.lizeqiangd.zweisystem.interfaces.textinput.ti_general_rect;
	import com.lizeqiangd.zweisystem.manager.AnimationManager;
	import com.lizeqiangd.zweisystem.manager.ApplicationManager;
	import com.lizeqiangd.zweisystem.modules.notification.SystemStatusNotification;
	import flash.text.TextField;
	
	/**
	 * @author Lizeqiangd
	 *
	 */
	
	public class QuestionnaireGenerator extends TitleWindows implements iApplication
	{
		private var qga:QuestionnaireGeneratorAPI = QuestionnaireGeneratorAPI.getInstance
		private var ssn:SystemStatusNotification
		private var creator:iApplication
		public function QuestionnaireGenerator()
		{
			this.setDisplayLayer = "applicationLayer";
			this.setApplicationTitle = "BILIBILI Application - QuestionnaireGenerator - 题目管理器";
			this.setApplicationName = "QuestionnaireGenerator";
			this.configWindows(600, 500)
			self=this
			this.addEventListener(ApplicationEvent.INIT, init);
			ssn = new SystemStatusNotification()
			ssn.y = 20
			ssn.init(this.getUiWidth, getUiHeight - 20)
			initUI()
			addChild(ssn)
			creator = ApplicationManager.open('com.lizeqiangd.einstation.applications.QuestionnaireGenerator.QuestionnaireCreator')
			creator.applicationMessage({'master':self})
		}
		private var self:QuestionnaireGenerator
		private var dg_questions:dg_defaultDataGird
		private var cb_content1:btn_general = new btn_general
		private var cb_content2:btn_general = new btn_general
		private var cb_content3:btn_general = new btn_general
		
		private var cb_contentc_1:cb_content = new cb_content
		private var cb_contentc_2:cb_content = new cb_content
		private var cb_contentc_3:cb_content = new cb_content
		//
		//private var btn_general1:btn_general = new btn_general
		private var btn_general2:btn_general_s = new btn_general_s
		////private var btn_general2:btn_general=new btn_general
		////private var btn_general3:btn_general=new btn_general
		////private var btn_general4:btn_general=new btn_general
		////private var btn_general5:btn_general=new btn_general
		private var question_type:uint = 1
		private var control_mode:uint = 1
		private var cache_questions_arr:Array = []
		
		private function initUI():void
		{
			cb_content1.x = 10
			cb_content2.x = 160
			cb_content3.x = 10
			cb_content1.y = 100
			cb_content2.y = 100
			cb_content3.y = 130
			//cb_content1.selected = true
			cb_content1.name = '1'
			cb_content2.name = '3'
			cb_content3.name = '4'
			cb_content1.title = '选择题'
			cb_content2.title = '填空题'
			cb_content3.title = '矩阵题'
			addChild(cb_content1)
			addChild(cb_content2)
			addChild(cb_content3)
			cb_content1.addEventListener(UIEvent.CLICK, onCBClick)
			cb_content2.addEventListener(UIEvent.CLICK, onCBClick)
			cb_content3.addEventListener(UIEvent.CLICK, onCBClick)
			
			cb_contentc_1.x = 10
			cb_contentc_2.x = 160
			cb_contentc_3.x = 10
			cb_contentc_1.y = 30
			cb_contentc_2.y = 30
			cb_contentc_3.y = 60
			cb_contentc_1.selected = true
			cb_contentc_1.name = '1'
			cb_contentc_2.name = '2'
			cb_contentc_3.name = '3'
			cb_contentc_1.title = '创建模式'
			cb_contentc_2.title = '更新模式'
			cb_contentc_3.title = '删除模式'
			addChild(cb_contentc_1)
			addChild(cb_contentc_2)
			addChild(cb_contentc_3)
			cb_contentc_1.addEventListener(UIEvent.CLICK, onModeClick)
			cb_contentc_2.addEventListener(UIEvent.CLICK, onModeClick)
			cb_contentc_3.addEventListener(UIEvent.CLICK, onModeClick)
			AnimationManager.changeColor(cb_contentc_1, 'lightblue')
			//AnimationManager.changeColor(cb_contentc_1,'lightblue')
			AnimationManager.changeColor(cb_contentc_3, 'red')
			
			//ti_general0.x = 10
			//ti_general0.textWidth = 40
			//ti_general0.text = '1'
			//ti_general0.y = 160
			//addChild(ti_general0)
			//ti_general1.x = 80
			//ti_general1.y = 160
			//addChild(ti_general1)
			//ti_general2.x = 10
			//ti_general2.textWidth = 280
			//ti_general2.y = 190
			//addChild(ti_general2)
			//ti_general3.x = 10
			//ti_general3.textWidth = 280
			//ti_general3.y = 220
			//addChild(ti_general3)
			//
			//btn_general1.x = 20
			//btn_general1.y = 470
			//btn_general1.title = '执行'
			//addChild(btn_general1)
			btn_general2.x = 170
			btn_general2.y = 470
			btn_general2.title = '刷新'
			addChild(btn_general2)
			
			dg_questions = new dg_defaultDataGird(dgr_questions)
			dg_questions.config(300, 480)
			dg_questions.y = 20
			dg_questions.x = 300
			addChild(dg_questions)
		}
		
		public function init(e:ApplicationEvent):void
		{
			//ssn.anime('ssn.ssn_wait', 'loading')
			qga.call_api('list_question', function(e:Object):void
				{
					cache_questions_arr = e as Array
					dg_questions.dataProvider = cache_questions_arr
				//ssn.clean()
				}, {page: 1, page_size: 100000})
			
			dispatchEvent(new ApplicationEvent(ApplicationEvent.INITED))
			addApplicationListener()
		}
		
		private function onCBClick(e:UIEvent):void
		{
			question_type = parseInt(e.target.name)
			creator.applicationMessage({'type':question_type})
		}
		
		private function onModeClick(e:UIEvent):void
		{
			cb_contentc_1.selected = false
			cb_contentc_2.selected = false
			cb_contentc_3.selected = false
			e.target.selected = true
			switch (e.target)
			{
				case cb_contentc_1: 
					break;
				case cb_contentc_2: 
					break;
				case cb_contentc_3: 
					break;
				default: 
			}
			control_mode = parseInt(e.target.name)
		}
		
		private function addApplicationListener():void
		{
			dg_questions.addEventListener(UIEvent.SELECTED, onDGClick)
			//btn_general1.addEventListener(UIEvent.CLICK, onButtonClick)
			btn_general2.addEventListener(UIEvent.CLICK, onButtonClick)
			this.addEventListener(ApplicationEvent.CLOSE, onApplicationClose);
		}
		
		private function onButtonClick(e:UIEvent):void
		{
			switch (e.target)
			{
				//case btn_general1:
					//
					//break;
				case btn_general2: 
					refrush()
					break;
				default: 
			}
		}
		
		private function refrush():void
		{
			cb_contentc_1.selected = true
			cb_contentc_2.selected = false
			cb_contentc_3.selected = false
			control_mode = 1
			question_type = 1
			qga.call_api('list_question', function(e:Object):void
				{
					cache_questions_arr = e as Array
					dg_questions.dataProvider = cache_questions_arr
				//ssn.clean()
				}, {page: 1, page_size: 100000})
		}
		
		private function onDGClick(e:UIEvent):void
		{
			switch (control_mode)
			{
				case 1:
					
					break;
				case 2: 
					//ssn.anime('ssn.ssn_wait', 'loading')
					qga.call_api('get_question', function(e:Object):void
						{
							
							//cb_content1.selected = false
							//cb_content2.selected = false
							//cb_content3.selected = false
							//cb_content4.selected = false
							if (e.type > 0)
							{
								//self['cb_content'+e.type].selected = true
							}
							creator.applicationMessage({'type':e.type,'data':e});
							//ti_general0.text = e.id
							//ti_general1.text = e.title
							//ti_general2.text = JSON.stringify(e.selection)
							//ti_general3.text = JSON.stringify(e.option)
						//ssn.clean()
						}, {question_id: cache_questions_arr[dg_questions.getSelectedArray[0]].id})
					break;
				case 3: 
					//ssn.anime('ssn.ssn_wait', 'loading')
					//qga.call_api('get_question', function(e:Object):void
						//{
							////e.type
							////e.id
							////ti_general1.text = e.title
							////ti_general2.text = JSON.stringify(e.selection)
							////ti_general3.text = JSON.stringify(e.option)
						////ssn.clean()
						//}, {question_id: cache_questions_arr[dg_questions.getSelectedArray[0]].id})
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