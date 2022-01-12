package;

import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var tacosnsushi:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var gfportraitnoway:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'division':
				FlxG.sound.playMusic(Paths.music('breakfast'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);

				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			case 'division':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('splitDialog/Dialogue_Box', 'shared');
				box.animation.addByPrefix('normalOpen', 'tcghasmeheldhostagesomeonepleasegetmeoutofhere', 24, false);
				box.animation.addByIndices('normal', 'tcghasmeheldhostagesomeonepleasegetmeoutofhere', [10], "", 24);
				box.animation.addByPrefix('closing', 'sealedawayforeternity', 24, false);
				box.animation.addByIndices('closed', 'sealedawayforeternity', [10], "", 24);
				box.width = 280;
				box.height = 280;
				box.x = -130;
				box.y = -200;
				box.antialiasing = false;
		}

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;
		
		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft = new FlxSprite(-20, 40);
			portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter instance 1', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
		}
		else if (PlayState.SONG.song.toLowerCase() == 'division')
		{
			portraitLeft = new FlxSprite(-20, 40);
			portraitLeft.frames = Paths.getSparrowAtlas('splitDialog/Split_Portraits');
			portraitLeft.animation.addByPrefix('dadsonic', 'splitsonic', 24, false);
			portraitLeft.animation.addByPrefix('dadconfused', 'splitconfused', 24, false);
			portraitLeft.animation.addByPrefix('dadexcited', 'splitexcited', 24, false);
			portraitLeft.animation.addByPrefix('dadidle', 'splitidle', 24, false);
			portraitLeft.animation.addByPrefix('dadreally', 'splitreally', 24, false);
			portraitLeft.animation.addByPrefix('dadtired', 'splittired', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.5));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
		}

		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitRight = new FlxSprite(0, 40);
			portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter instance 1', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * PlayState.daPixelZoom * 0.9));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
		}
		else if (PlayState.SONG.song.toLowerCase() == 'division')
		{
			portraitRight = new FlxSprite(0, 40);
			portraitRight.frames = Paths.getSparrowAtlas('splitDialog/BF_Portraits');
			portraitRight.animation.addByPrefix('bfidle', 'bfidle', 24, false);
			portraitRight.animation.addByPrefix('bfup', 'bfup', 24, false);
			portraitRight.animation.addByPrefix('bfyeah', 'bfyeah', 24, false);
			portraitRight.animation.addByPrefix('bfholySHIThesgfnow', 'holySHIThesgfnow', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.5));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
		}

		if (PlayState.SONG.song.toLowerCase() == 'division')
		{
			gfportraitnoway = new FlxSprite(0, 40);
			gfportraitnoway.frames = Paths.getSparrowAtlas('splitDialog/GF_portraits');
			gfportraitnoway.animation.addByPrefix('gfidle', 'gfidle', 24, false);
			gfportraitnoway.animation.addByPrefix('gfhey', 'gfhey', 24, false);
			gfportraitnoway.animation.addByPrefix('gfscared', 'gfscared', 24, false);
			gfportraitnoway.animation.addByPrefix('gfsob', 'gfsob', 24, false);
			gfportraitnoway.setGraphicSize(Std.int(gfportraitnoway.width * 0.5));
			gfportraitnoway.updateHitbox();
			gfportraitnoway.scrollFactor.set();
			add(gfportraitnoway);
			gfportraitnoway.visible = false;
		}
		
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);

		box.screenCenter(X);
		portraitLeft.screenCenter(X);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic(Paths.image('weeb/pixelUI/hand_textbox'));
		handSelect.setGraphicSize(Std.int(handSelect.width * 2));
		add(handSelect);


		if (!talkingRight)
		{
			// box.flipX = true;
		}

		swagDialogue = new FlxTypeText(240, 380, Std.int(FlxG.width * 0.65), "", 32);
		swagDialogue.font = 'Robot_Font';
		swagDialogue.color = 0xFFFFFFFF;
		swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
		}

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				trace ('spuch bombb the prequel');
				box.animation.play('normal');
				dialogueOpened = true;
			}
			else if (box.animation.curAnim.name == 'closing' && box.animation.curAnim.finished)
			{
				trace ('spuch bombb the sequel');
				box.animation.play('closed');
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (PlayerSettings.player1.controls.ACCEPT && dialogueStarted == true)
		{
			remove(dialogue);
				
			FlxG.sound.play(Paths.sound('clickText'), 0.8);
			handSelect.x += 5;
			new FlxTimer().start(0.05, function(tmr:FlxTimer)
				{
					handSelect.x -= 5;
				});

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'division')
						FlxG.sound.music.fadeOut(2.2, 0);

					if (PlayState.SONG.song.toLowerCase() == 'division')
					{
						FlxTween.tween(handSelect, {alpha: 0}, 0.15);
						box.animation.play('closing');

						new FlxTimer().start(0.2, function(tmr:FlxTimer)
							{
								FlxTween.tween(box, {alpha: 0}, 0.5);
								FlxTween.tween(bgFade, {alpha: 0}, 0.3);
								FlxTween.tween(portraitLeft, {alpha: 0}, 0.3);
								FlxTween.tween(portraitRight, {alpha: 0}, 0.3); 
								FlxTween.tween(gfportraitnoway, {alpha: 0}, 0.3);
								FlxTween.tween(swagDialogue, {alpha: 0}, 0.3);
							});
					}
					else
					{
						new FlxTimer().start(0.2, function(tmr:FlxTimer)
							{
								box.alpha -= 1 / 5;
								bgFade.alpha -= 1 / 5 * 0.7;
								portraitLeft.visible = false;
								portraitRight.visible = false;
								swagDialogue.alpha -= 1 / 5;
								handSelect.alpha -= 1 / 5;
							}, 5);
					}

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var cooltimer:Float = 1.2;
	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'dad':
				portraitRight.visible = false;
				gfportraitnoway.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.visible = true;
					portraitLeft.animation.play(curCharacter + tacosnsushi);
				}
			case 'bf':
				portraitLeft.visible = false;
				gfportraitnoway.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.visible = true;
					portraitRight.animation.play(curCharacter + tacosnsushi);
				}
			case 'gf':
				portraitLeft.visible = false;
				portraitRight.visible = false;
				if (!gfportraitnoway.visible)
				{
					gfportraitnoway.visible = true;
					gfportraitnoway.animation.play(curCharacter + tacosnsushi);
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		tacosnsushi = splitName[2];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 3 + splitName[2].length).trim();
	}
}
