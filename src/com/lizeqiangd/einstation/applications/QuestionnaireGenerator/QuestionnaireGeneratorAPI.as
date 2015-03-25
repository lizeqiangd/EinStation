package com.lizeqiangd.einstation.applications.QuestionnaireGenerator
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class QuestionnaireGeneratorAPI
	{
		private static var _instance:QuestionnaireGeneratorAPI
		
		public static function get getInstance():QuestionnaireGeneratorAPI
		{
			if (_instance)
			{
				return _instance
			}
			_instance = new QuestionnaireGeneratorAPI
			return _instance
		}
		private var baseurl:String = 'http://localhost/qg/'
		private var question_api:String = 'questions.php'
		private var questionnaire_api:String = 'questionnaires.php'
		
		public function QuestionnaireGeneratorAPI()
		{
			if (_instance)
			{
				throw new Error('do not new this.')
			}
		}
		
		public function call_api(api:String, onComplete:Function, data:Object = null):void
		{
			var urll:URLLoader = new URLLoader()
			var urlr:URLRequest = new URLRequest()
			urlr.data = new URLVariables()
			urlr.method = 'POST'
			if (data)
			{
				parse_object(data, urlr.data)
				
			}
			switch (api)
			{
				//questionnaire
				case 'get_questionnaire': 
					urlr.url = baseurl + questionnaire_api
					urlr.data['action'] = api
					break;
				case 'get_full_questionnaire': 
					urlr.url = baseurl + questionnaire_api
					urlr.data['action'] = api
					break;
				case 'update_questionnaire': 
					urlr.url = baseurl + questionnaire_api
					urlr.data['action'] = api
					break;
				case 'new_questionnaire': 
					urlr.url = baseurl + questionnaire_api
					urlr.data['action'] = api
					break;
				case 'delete_questionnaire': 
					urlr.url = baseurl + questionnaire_api
					urlr.data['action'] = api
					break;
				case 'list_questionnaire': 
					urlr.url = baseurl + questionnaire_api
					urlr.data['action'] = api
					break;
				case 'find_questionnaire': 
					urlr.url = baseurl + questionnaire_api
					urlr.data['action'] = api
					break;
				case 'get_questionnaire_count': 
					urlr.url = baseurl + questionnaire_api
					urlr.data['action'] = api
					break;
				case 'add_questionnaire_question': 
					urlr.url = baseurl + questionnaire_api
					urlr.data['action'] = api
					break;
				case 'remove_questionnaire_question': 
					urlr.url = baseurl + questionnaire_api
					urlr.data['action'] = api
					break;
				
				//question
				case 'get_question': 
					urlr.url = baseurl + question_api
					urlr.data['action'] = api
					break;
				case 'update_question': 
					urlr.url = baseurl + question_api
					urlr.data['action'] = api
					break;
				case 'new_question': 
					urlr.url = baseurl + question_api
					urlr.data['action'] = api
					break;
				case 'delete_question': 
					urlr.url = baseurl + question_api
					urlr.data['action'] = api
					break;
				case 'list_question': 
					urlr.url = baseurl + question_api
					urlr.data['action'] = api
					break;
				case 'find_question': 
					urlr.url = baseurl + question_api
					urlr.data['action'] = api
					break;
				case 'get_question_count': 
					urlr.url = baseurl + question_api
					urlr.data['action'] = api
					break;
				
				default: 
					trace('QG,找不到api方法:', question_api)
			}
			
			urll.load(urlr)
			urll.addEventListener(Event.COMPLETE, onLoadComplete)
			urll.addEventListener(IOErrorEvent.IO_ERROR, onError)
			urll.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onError)
			
			function onLoadComplete(e:Event):void
			{
				urll.removeEventListener(Event.COMPLETE, onLoadComplete)
				urll.removeEventListener(IOErrorEvent.IO_ERROR, onError)
				urll.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onError)
				var returnObj:Object = JSON.parse(urll.data)
				//var returnObj:Object = urll.data
				if (returnObj.code !== 200)
				{
					trace('QuestionnaireGenerator APIError:', api, returnObj.data)
					onComplete({})
				}
				else
				{
					onComplete(returnObj.data)
				}
				urll = null;
				urlr = null
			}
			function onError(e:*):void
			{
				trace('QuestionnaireGenerator LoadError:', api, e)
			}
		}
		
		private function parse_object(from:Object, target:Object):void
		{
			for (var i:String in from)
			{
				target[i] = from[i]
			}
		
		}
	}

}