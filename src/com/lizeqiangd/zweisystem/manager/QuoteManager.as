package com.lizeqiangd.zweisystem.manager
{
	//import com.lizeqiangd.einstation.applications.QuestionnaireGenerator.QuestionCreator;
	//import com.lizeqiangd.einstation.applications.QuestionnaireGenerator.QuestionnaireCreator;
	//import com.lizeqiangd.einstation.applications.QuestionnaireGenerator.QuestionnaireGenerator;
	import com.lizeqiangd.einstation.applications.Heimdallr.Heimdallr;
	import com.lizeqiangd.einstation.applications.WorkAssistant.WorkAssistant;
	import com.lizeqiangd.zweisystem.animations.messbox.mb_blue_excalmatory;
	import com.lizeqiangd.zweisystem.animations.messbox.mb_blue_excalmatory_motion;
	import com.lizeqiangd.zweisystem.animations.messbox.mb_green_correct;
	import com.lizeqiangd.zweisystem.animations.messbox.mb_red_cross;
	import com.lizeqiangd.zweisystem.animations.messbox.mb_yellow_interrogation;
	import com.lizeqiangd.zweisystem.animations.ssn.ssn_wait;
	
	/**
	 * ...
	 * @author Lizeqiangd
	 */
	public class QuoteManager
	{
		//****application****
		//private var QuestionnaireGenerators:QuestionnaireGenerator	
		//private var QuestionnaireCreators:QuestionnaireCreator 	
		//private var QuestionCreators:QuestionCreator 	
		//private var WorkAssistants:WorkAssistant
		private var heimdallr:Heimdallr
		
		//****animation****
		private var ssn_waits:ssn_wait
		private var mb_blue_excalmatorys:mb_blue_excalmatory
		private var mb_blue_excalmatory_motions:mb_blue_excalmatory_motion
		private var mb_green_corrects:mb_green_correct
		private var mb_red_crosss:mb_red_cross
		private var mb_yellow_interrogations:mb_yellow_interrogation
		
		public static function init():void
		{
			new QuoteManager;
		}
	}

}