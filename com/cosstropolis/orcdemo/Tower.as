package com.cosstropolis.orcdemo
{
	import org.flixel.*;
	
	public class Tower extends FlxSprite
	{
		[Embed("assets/guardtower.png")] private var towerSprite:Class;
		[Embed("assets/arrow.mp3")] private var projectileSound:Class;
		
		/*properties*/
		private var target:Character;
		private var projectileSpeed:Number;
		private var firingRate:Number;
		/*input*/
		private var keyAutofire:String = "F";
		/*other*/
		private var shootTimer:Number = 0;
		private var projectile:FlxSprite;
		private var autofire:Boolean = true;
		
		private const PROJ_SPEED_DEF:Number = 800;
		private const FIRE_RATE_DEF:Number = 1.5;
		
		public function Tower(Target:Character, 
							  X:Number=0, 
							  Y:Number=0, 
							  ProjectileSpeed:Number = PROJ_SPEED_DEF, 
							  FiringRate:Number = FIRE_RATE_DEF)
		{
			super(X, Y);
			this.target = Target;
			this.projectileSpeed = ProjectileSpeed;
			this.firingRate = FiringRate;
			loadGraphic(towerSprite, false);
			
			projectile = new FlxSprite(this.x, this.y);
			projectile.makeGraphic(20, 4, 0xff804500);
			projectile.solid = false;
			projectile.visible = false;
		}
		
		override public function update():void{
			(FlxG.state as PlayState).add(projectile);
			
			if (FlxG.keys.justPressed(keyAutofire)){
				autofire = !autofire;
				if (autofire) shoot(angleToTarget());
			}
			
			//handle fire rate
			shootTimer = (autofire) ? shootTimer + FlxG.elapsed : 0;
			if (shootTimer >= firingRate){
				shoot(angleToTarget());
				shootTimer = 0;
			}
			
			if (FlxG.collide(projectile, target)){
				target.kill();
				projectile.kill();
			}
			
			(FlxG.state as PlayState).debug.text = "autofire: " + autofire.toString();
			super.update();
		}
		
		/*return angle to target (relative to x-axis) in radians*/
		private function angleToTarget():Number{
			var angle:Number;
			var dir:FlxPoint = new FlxPoint(0, 0);
			angle = Math.atan2(target.y - y, (target.x - (target.width>>1)) - x + (width>>1));
			
			return angle;
		}
		
		private function shoot(angleInRadians:Number):void{
			if (!projectile.alive) return;
			
			var dir:FlxPoint = new FlxPoint(0,0);
			dir.x = Math.cos(angleInRadians);
			dir.y = Math.sin(angleInRadians);
			
			projectile.solid = true;
			projectile.visible = true;
			projectile.x = x + (width>>1);
			projectile.y = y;
			projectile.angle = angleInRadians * 57.295;
			projectile.velocity.x = dir.x * projectileSpeed;
			projectile.velocity.y = dir.y * projectileSpeed;
			
			FlxG.play(projectileSound);
		}
	}
}