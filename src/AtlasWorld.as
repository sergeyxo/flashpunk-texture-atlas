package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Tween;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.tweens.motion.CircularMotion;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.TextureAtlas;
	import net.flashpunk.World;
	
	/**
	 * A world created using texture atlases.
	 * @author Zachary Lewis
	 */
	public class AtlasWorld extends World 
	{
		[Embed(source = "../assets/gameatlas.xml", mimeType="application/octet-stream")]
		public static const ATLAS:Class;
		
		[Embed(source = "../assets/gameatlas.png")]
		public static const TEXTURE:Class;
		
		public var myAtlas:TextureAtlas;
		
		protected var _fireballImage:Image;
		protected var _fireball:Entity;
		protected var _coinImage:Image;
		protected var _playerImage:Image;
		protected var _player:Entity;

		protected var _mapTiles:Tilemap;

		protected var _fireballTween:CircularMotion;

		protected var _fireballPulse:int = 1;
		
		public function AtlasWorld() 
		{
		}
		
		override public function begin():void 
		{
			myAtlas = new TextureAtlas(TEXTURE, ATLAS);
			_fireballImage = myAtlas.getImage("item_fireball");
			_fireballImage.smooth = true;
			_fireballImage.centerOrigin();
			_coinImage = myAtlas.getImage("item_coin");
			_fireball = addGraphic(_fireballImage);
			addGraphic(_coinImage, 0, 472, 90);
			
			_playerImage = myAtlas.getImage("player_walk_5");
			_playerImage.smooth = true;
			_playerImage.centerOrigin();
			_player = addGraphic(_playerImage, -1, FP.halfWidth, FP.halfHeight);

			_mapTiles = myAtlas.getTilemap("basic_tiles", 800, 600);

			// Create a simple map.
			_mapTiles.line(0, 8, 11, 8, 1);
			_mapTiles.line(0, 7, 4, 7, 1);
			_mapTiles.line(4, 7, 9, 7, 3);
			_mapTiles.line(10, 7, 11, 7, 1);
			_mapTiles.line(0, 6, 3, 6, 3);
			_mapTiles.setTile(4, 6, 4);
			_mapTiles.setRect(9, 5, 3, 2, 1);
			_mapTiles.setTile(9, 4, 2);
			_mapTiles.line(10, 4, 11, 4, 3);
			_mapTiles.setTile(6, 2, 5);
			_mapTiles.setTile(7, 2, 6);

			// Add the basic map.
			addGraphic(_mapTiles, 10);

			addGraphic(myAtlas.getBackdrop("background"), 20);
			_fireballTween = new CircularMotion(null, Tween.LOOPING);
			_fireballTween.setMotion(490, 108, 100, 360, true, 240);
			_fireballTween.object = _fireball;
			addTween(_fireballTween, true);
			super.begin();
		}
		
		override public function update():void 
		{
			// Simple player movement toward the cursor.
			FP.stepTowards(_player,Input.mouseX, Input.mouseY, FP.distance(_player.x, _player.y, Input.mouseX, Input.mouseY) * 0.1);
			_playerImage.angle++;
			_fireballImage.angle -= 12;
			_fireballImage.scale += _fireballPulse * 0.005;

			if (_fireballImage.scale >= 1.25)
			{
				_fireballPulse = -1;
			}
			else if (_fireballImage.scale <= 1)
			{
				_fireballPulse = 1;
			}

			super.update();
		}
		
	}

}
