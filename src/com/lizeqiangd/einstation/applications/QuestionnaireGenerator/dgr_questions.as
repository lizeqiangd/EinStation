package com.lizeqiangd.einstation.applications.QuestionnaireGenerator
{
	import com.lizeqiangd.zweisystem.events.UIEvent;
	import com.lizeqiangd.zweisystem.interfaces.baseunit.datagird.BaseDataGird;
	import com.lizeqiangd.zweisystem.interfaces.baseunit.datagird.BaseDataGirdRow;
	import com.lizeqiangd.zweisystem.interfaces.baseunit.datagird.iDataGirdRow;
	import com.lizeqiangd.zweisystem.system.config.ESTextFormat;
	import flash.text.TextFormat;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * lizeqiangd@gmail.com
	 * @author Lizeqiangd
	 * 弹幕列表中的标题栏
	 */
	public class dgr_questions extends BaseDataGirdRow implements iDataGirdRow
	{
		
		private var tx_id:TextField
		private var tx_type:TextField
		private var tx_title:TextField
		
		public function dgr_questions()
		{
			tx_id = new TextField
			tx_type = new TextField
			tx_title = new TextField
			
			tx_id.mouseEnabled = false
			tx_type.mouseEnabled = false
			tx_title.mouseEnabled = false
			
			tx_id.defaultTextFormat = ESTextFormat.LightBlueTitleTextFormat // BPTextFormat.DataGirdCommentRowTextFormat
			tx_type.defaultTextFormat = ESTextFormat.LightBlueTitleTextFormat // BPTextFormat.DataGirdCommentRowTextFormat
			var tf:TextFormat = ESTextFormat.LightBlueTitleTextFormat
			tf.align = 'left'
			tx_title.defaultTextFormat = tf //  BPTextFormat.DataGirdCommentRowTextFormat
			
			tx_id.text = ""
			tx_type.text = ""
			tx_title.text = ""
			
			tx_id.y = 2
			tx_type.y = 2
			tx_title.y = 2
			
			tx_id.x = 2
			tx_id.width = 30
			tx_type.x = 32
			tx_type.width = 20
			tx_title.defaultTextFormat.align = 'left'
			tx_title.x = 52
			tx_title.width = 238
			
			tx_id.height = 20
			tx_type.height = 20
			tx_title.height = 20
			
			addChild(tx_id)
			addChild(tx_title)
			addChild(tx_type)
		}
		
		public function update():void
		{
			if (data[indexInDataGird])
			{
				tx_id.text = data[indexInDataGird].id + ""
				tx_type.text = data[indexInDataGird].type + ""
				tx_title.text = data[indexInDataGird].title
			}
			else
			{
				tx_id.text = ""
				tx_type.text = ""
				tx_title.text = ''
			}
			cherkSelected()
		}
	}

}