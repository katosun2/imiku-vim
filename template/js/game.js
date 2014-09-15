//定义一个游戏
var game = new Phaser.Game(288, 505, Phaser.AUTO, 'mygame');

/*定义游戏场景*/
game.States = {
	//boot场景，用来做一些游戏启动前的准备
	boot : function(){ 
		this.preload = function(){
			game.load.image('loading', './img/preloader.gif');
		};
		this.create = function(){
			//启动资源加载
			game.state.start('preload');
			//game.world.setBounds(0, 0, 4000, 300);
		};
	},
	//prelaod场景，用来显示资源加载进度
	preload : function(){
		this.preload = function(){
			/*var preloadSprite = game.add.sprite( game.world.centerX, game.world.centerY, 'loading');
			preloadSprite.anchor.set(0.5,0);
			game.load.setPreloadSprite(preloadSprite, 0);*/

			//加载进度
			var text = game.add.text( game.world.centerX, game.world.centerY, "0%",{font:"16px Arial", fill:"#FFFFFF", align: "center"}),
			percent = 0,
			curPercent = 0,
			loadKey,
			_addPrecent = function(from, to){
				if(percent < to){
					if(percent >= from){
						percent++;
					}

					if (percent > 100) {
						percent = 100;
					}

					text.setText(percent + "%");

					if(percent == 100){
						game.time.events.remove(loadKey);
					}
				}
			};
			//文字居中
			text.anchor.set(0.5, 0.5);
			//添加定时器
			loadKey = game.time.events.loop(Phaser.Timer.SECOND / 30, function(){
				_addPrecent(percent , curPercent);
			}, this);
			//绑定
			game.load.onFileComplete.add(function( progress ) {
				curPercent  = progress;
			});

			//加载资源
		};
		this.create = function(){
			//启动菜单场景
			game.state.start('menu');
		};
	},
	//menu场景, 显示菜单
	menu : function(){
		this.create = function(){ };
	},
	//play场景， 游戏场景
	play : function(){
		this.create = function(){ };
		this.update = function(){ };
	}
};

game.main = {
	init : function(){
		//添加场景
		game.state.add('boot', game.States.boot);
		game.state.add('preload', game.States.preload);
		game.state.add('menu', game.States.menu);
		game.state.add('play', game.States.play);

		//调用boot启动游戏
		game.state.start('boot');
	}
};

/*初始化*/
game.main.init();
