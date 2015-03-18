public static function loadPlaylist(list:PlayList)
		{
		}
		public static function loadPlaylistUrl(url:String )
		{
		}
		private var _isPlaying:Boolean = false;
		private var _soundPlayer:SoundPlayer;
		private var _container:SoundContainer;
		private var _base:Sprite;
		private var _mask:Sprite;
		private var _pys:Array;
		private var _pysDummy:Array;
		
		public function BackgroundView()
		{
		this._pys = [];
		this._pysDummy = [];
		super();
		this._init();
		}
		public function playBgm(_arg1:String, _arg2:SoundContainer):void
		{
		if (this._isPlaying)
		{
		this.stopBgm();
		}
		this._isPlaying = true;
		visible = true;
		this._container = _arg2;
		this._container.playBgm();
		var _local3:Sound = new Sound(new URLRequest(_arg1));
		this._soundPlayer = new SoundPlayer(_local3);
		this._soundPlayer.play(0, int.MAX_VALUE);
		var _local4:int;
		while (_local4 < 0x0100)
		{
		this._pysDummy[_local4] = 0;
		this._pys[_local4] = StageReference.stageHeight;
		_local4++;
		}
		this._resize();
		StageReference.addResizeFunction(this._resize);
		StageReference.addEnterFrameFunction(this._update);
		}
		public function stopBgm():void
		{
		if (! this._isPlaying)
		{
		return;
		}
		this._container.stopBgm();
		this._soundPlayer.kill();
		this._soundPlayer = null;
		this._isPlaying = false;
		visible = false;
		StageReference.removeResizeFunction(this._resize);
		StageReference.removeEnterFrameFunction(this._update);
		}
		public function update():void
		{
		this._resize();
		}
		private function _init():void
		{
		this._base = new Sprite();
		addChild(this._base);
		this._mask = new Sprite();
		addChild(this._mask);
		this._base.mask = this._mask;
		}
		private function _update():void
		{
		var g:* = null;
		var i:* = 0;
		var n:* = 0;
		var px:* = 0;
		var py:* = 0;
		g = this._mask.graphics;
		g.clear();
		i = 0;
		var output:* = new ByteArray();
		var arr:* = [];
		g.beginFill(0);
		g.moveTo(0, StageReference.stageHeight);
		try
		{
		SoundMixer.computeSpectrum(output, false);
		}
		catch (e)
		{
		i = 0;
		while (i < 0x0100)
		{
		if ((i % 2) == 0)
		{
		if (_pysDummy[i] < 0.01)
		{
		_pysDummy[i] = MathUtil.rand(0.01,1);
		}
		else
		{
		_pysDummy[i] = (_pysDummy[i] / 1.5);
		if ((((_pysDummy[i] < 0.8)) && ((MathUtil.randInt(0, 30) == 0))))
		{
		_pysDummy[i] = MathUtil.rand(_pysDummy[i],1);
		}
		}
		}
		else
		{
		_pysDummy[i] = (_pysDummy[(i - 1)] * 0.98);
		}
		px = ((StageReference.stageWidth / 0xFF) * i);
		_pys[i] = (_pys[i] + (((StageReference.stageHeight * (1 - _pysDummy[i])) - _pys[i]) / 3));
		py = _pys[i];
		g.lineTo(px, py);
		i = (i + 1);
		}
		g.lineTo(StageReference.stageWidth, StageReference.stageHeight);
		g.endFill();
		return;
		}
		i = 0;
		while (i < 0x0100)
		{
		arr[i] = MathUtil.abs((output.readFloat() / 2));
		i = (i + 1);
		}
		i = 0x0100;
		while (i < 0x0200)
		{
		n = (i - 0x0100);
		arr[n] = (arr[n] + MathUtil.abs((output.readFloat() / 2)));
		px = ((StageReference.stageWidth / 0xFF) * n);
		this._pys[n] = (this._pys[n] + (((StageReference.stageHeight * (1 - arr[n])) - this._pys[n]) / 3));
		py = this._pys[n];
		g.lineTo(px, py);
		i = (i + 1);
		}
		g.lineTo(StageReference.stageWidth, StageReference.stageHeight);
		g.endFill();
		}
		private function _resize():void
		{
		Pattern.draw(this._base, new Rectangle(0, 0, StageReference.stageWidth, StageReference.stageHeight), Context.model.homeDotNum, true);
		}
		