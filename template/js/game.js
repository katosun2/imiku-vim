/*加载资源*/
var preload = function() { };

/*创建世界*/
var create = function() { };

/*每帧重绘*/
var update = function() { };

/*每帧渲染*/
var render = function() { };

/*第三个参数可以是Phaser.CANVAS，Phaser.WEBGL，或Phaser.AUTO。这个是你想使用的渲染上下文。推荐的参数是Phaser.AUTO，它会自动尝试使用WebGL，如果浏览器或设备不支持它就会回滚成Canvas。*/
var game = new Phaser.Game(800, 600, Phaser.AUTO, '空|id|dom', { preload: preload, create: create, update: update, render: render}, true);
