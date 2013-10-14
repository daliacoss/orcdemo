package com.cosstropolis.orcdemo
{
	import flash.utils.Dictionary;
	
	import org.flixel.*;
	
	public class Orc extends Character
	{
		[Embed(source="assets/peon.png")] private var orcSpriteSheet:Class;
		[Embed(source="assets/death0.mp3")] private var deathSound:Class;
	
		private const VELX_DEF:Number = 100;
		private const VELY_DEF:Number = 100;
		private const HEIGHT:Number = 40;
		private const WIDTH:Number = 51;
		private const TIME_DEATH:Number = 2;
		
		private var keyWalk:String = "SPACE";
		
		private var walkingAnimSpeed:uint = 16;
		private var currentAnim:String = "idle_up";
		private var animations:Object = {
			//in a larger project i'd use a script to generate a lookup table for these
			"idle_up" : [0],
			"idle_up_diag" : [1],
			"idle_side" : [2],
			"idle_down_diag" : [3],
			"idle_down" : [4],
			"walk_up" : [10, 5, 10, 0, 20, 15, 20, 0],
			"walk_up_diag" : [11, 6, 11, 1, 21, 16, 21, 1],
			"walk_side" : [12, 7, 12, 2, 22, 17, 22, 2],
			"walk_down_diag" : [13, 8, 13, 3, 23, 18, 23, 3],
			"walk_down": [14, 9, 14, 4, 24, 19, 24, 4],
			"die": [25]
		};

		public function Orc(X:Number=0, Y:Number=0, MaxVelocityX:Number=VELX_DEF, MaxVelocityY:Number=VELY_DEF)
		{
			super(X, Y, MaxVelocityX, MaxVelocityY);
			timeUntilDeath = TIME_DEATH;
			
			loadGraphic(orcSpriteSheet, true, true, WIDTH, HEIGHT);
			for (var i:String in animations){
				addAnimation(i, animations[i], walkingAnimSpeed);
			}
			
			solid = true;
		}
		
		override public function update():void{
			
			if (alive){
				if (FlxG.keys.justPressed(keyWalk)) idle = !idle;
				
				updateAnimationAndFacing();
				pathMovement();
			}
			
			else{
				runDeathTimer();
			}
			
			super.update();
		}
		
		/* use direction property to update animations */
		private function updateAnimationAndFacing():void{
			var anim:String = currentAnim;
			facing = (direction.x < 0) ? LEFT : RIGHT;
			
			//if walking
			if (!idle){
				if (direction.x == 0){ //straight vertical
					if (direction.y > 0) anim = "walk_up";
					else anim = "walk_down";
				}
				else{ //sideways and diagonal
					if (direction.y > 0) anim = "walk_up_diag";
					else if (direction.y < 0) anim = "walk_down_diag";
					else anim = "walk_side";
				}
			}
			
			//if idle, use directionPrev to figure out facing
			else{
				if (direction.x == 0){
					if (direction.y > 0) anim = "idle_up";
					else anim = "idle_down";
				}
				else{
					if (direction.y > 0) anim = "idle_up_diag";
					else if (direction.y < 0) anim = "idle_down_diag";
					else anim = "idle_side";
				}
			}
			
			currentAnim = anim;
			play(currentAnim);
		}
		
		/* move along set path */
		private function pathMovement():void{
			//turn right after hitting bottom
			if (y >= FlxG.height - height && direction.y < 0){
				y = FlxG.height - height;
				direction = new FlxPoint(1, 0);
			}
			//turn up after hitting right
			else if (x >= FlxG.width - width && direction.x > 0){
				x = FlxG.width - width;
				direction = new FlxPoint(0, 1);
			}
			//turn left after hitting top
			else if (y <= 0 && direction.y > 0){
				y = 0;
				direction = new FlxPoint(-1, 0);
			}
			//turn down after hitting left
			else if (x <= 0 && direction.x < 0){
				x = 0;
				direction = new FlxPoint(0, -1);
			}
		}
		
		override public function kill():void{
			alive = false;
			if (deathTimer < timeUntilDeath){
				FlxG.play(deathSound, .4);
				play("die");				
			}
			else{
				super.kill();
			}
			
		}
		
		private function runDeathTimer():void{
			deathTimer += FlxG.elapsed;
			if (deathTimer >= timeUntilDeath) kill();
			//(FlxG.state as PlayState).debug2.text = deathTimer.toString() + " , " + timeUntilDeath.toString();
		}
	}
}