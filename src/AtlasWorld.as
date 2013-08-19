package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.Tween;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.tweens.motion.CircularMotion;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.TextureAtlas;
	import net.flashpunk.utils.textures.Tileset;
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
		
		/** The TextureAtlas containing all the game's textures. */
		public var myAtlas:TextureAtlas;
		
		protected var _backdrop:Backdrop;
		protected var _fireballImage:Image;
		protected var _fireball:Entity;
		protected var _coinImage:Image;
		protected var _playerImage:Image;
		protected var _player:Entity;

		protected var _mapTiles:Tilemap;

		protected var _fireballTween:CircularMotion;

		protected var _fireballPulse:int = 1;
		
		protected var _basicTileset:Tileset;
		protected const USE_CONTIGUOUS_SUBTEXTURE:Boolean = true;
		
		public function AtlasWorld() 
		{
		}
		
		override public function begin():void 
		{
			initializeTextureAtlas();
			createBackground();
			createMap();
			populateWorld();
			super.begin();
		}
		
		/** Create a simple map for testing. */
		private function createMap():void
		{
			// Create a new Tilemap from the TextureAtlas.
			var _mapTiles:Tilemap = myAtlas.getTilemap(_basicTileset, 810, 610);
			
			// Create a simple map.
			_mapTiles.line(0, 8, 11, 8, 7);
			_mapTiles.line(0, 7, 4, 7, 7);
			_mapTiles.line(4, 7, 9, 7, 2);
			_mapTiles.line(10, 7, 11, 7, 7);
			_mapTiles.line(0, 6, 3, 6, 2);
			_mapTiles.setTile(4, 6, 3);
			_mapTiles.setRect(9, 5, 3, 2, 7);
			_mapTiles.setTile(9, 4, 1);
			_mapTiles.line(10, 4, 11, 4, 2);
			_mapTiles.setTile(6, 2, 4);
			_mapTiles.setTile(7, 2, 5);
			
			// Add the newly-created Tilemap.
			addGraphic(_mapTiles, 10);
		}
		
		/** Create a background for testing. */
		private function createBackground():void 
		{
			_backdrop = myAtlas.getBackdrop("background");
			_backdrop.scrollX = -1.0;
			_backdrop.scrollY = -1.0;
			addGraphic(_backdrop, 20);
		}
		
		/** Fill the world with Entities pulled from the TextureAtlas. */
		private function populateWorld():void 
		{
			// Create the player.
			_playerImage = myAtlas.getImage("player_walk_5");
			_playerImage.smooth = true;
			_playerImage.centerOrigin();
			_player = addGraphic(_playerImage, -1, FP.halfWidth, FP.halfHeight);
			
			// Create the fireball.
			_fireballImage = myAtlas.getImage("item_fireball");
			_fireballImage.smooth = true;
			_fireballImage.centerOrigin();
			_fireball = addGraphic(_fireballImage);
			
			// Create the fireball's movement.
			_fireballTween = new CircularMotion(null, Tween.LOOPING);
			_fireballTween.setMotion(490, 108, 100, 360, true, 240);
			_fireballTween.object = _fireball;
			addTween(_fireballTween, true);
			
			// Create the coin.
			_coinImage = myAtlas.getImage("item_coin");
			addGraphic(_coinImage, 0, 472, 90);
		}
		
		override public function update():void 
		{
			// Simple player movement toward the cursor.
			FP.stepTowards(_player,Input.mouseX, Input.mouseY, FP.distance(_player.x, _player.y, Input.mouseX, Input.mouseY) * 0.1);
			_playerImage.angle += Input.mouseDown ? 4 : 1;
			
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
			
			FP.camera.x = _player.x / FP.width * 10;
			FP.camera.y = _player.y / FP.height * 10;

			super.update();
		}
		
		protected function initializeTextureAtlas():void
		{
			// Create the TextureAtlas.
			myAtlas = new TextureAtlas(TEXTURE);
			var xml:XML = FP.getXML(ATLAS);
			
			for each(var st:XML in xml.SubTexture)
			{
				myAtlas.defineSubtexture(st.@name, uint(st.@x), uint(st.@y), uint(st.@width), uint(st.@height), uint(st.@frameX), uint(st.@frameY), uint(st.@frameWidth), uint(st.@frameHeight));
			}
			
			// Create the Tileset.
			_basicTileset = new Tileset(xml.Tileset.(@name == "basicTileset").@tileWidth, xml.Tileset.(@name == "basicTileset").@tileHeight, USE_CONTIGUOUS_SUBTEXTURE);
			
			if (USE_CONTIGUOUS_SUBTEXTURE)
			{
				// If testing with a contiguous subtexture, it is the only thing that needs to be added to the Tileset.
				_basicTileset.addTile(myAtlas.getSubtexture("basicTileset"));
			}
			else
			{
				// If testing without a contiguous subtexture, each tile's subtexture should be added.
				for each(var t:XML in xml.Tileset.(@name == "basicTileset").Tile)
				{
					_basicTileset.addTile(myAtlas.getSubtexture(t.@source));
				}
			}
		}
		
	}

}
