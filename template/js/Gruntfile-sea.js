//引入 path 模块
var path = require('path');
//共享 node_modules 目录的路径
var nodeModulesPath = '../../node_modules/';
//package.json 位置
var packageJsonFile = 'package.json';
//是否为当前目录
var isCurPath = false;

/*配置*/
module.exports = function(grunt) {
	if(!isCurPath){
		// 重新设置 grunt 的项目路径
		grunt.file.setBase(__dirname);

		//获取当前目录相对于共享 node_modules 目录的路径
		var nodepath = path.relative(__dirname, nodeModulesPath);
	}

	grunt.initConfig({
		pkg: grunt.file.readJSON(packageJsonFile),

		hashmap: {
			demo1: {
				options: {
					build_dest: '.build'
				},
				files: [{
					expand: false,
					cwd: '',
					src: ['src/**/*.js'],
					dest: 'seajs-config.js'
				}]
			}
		},

		transport: {
			options: {
				alias: '<%= pkg.spm.alias %>',
				paths: ['../'],
				//modules位置，这里是js/
				//include: 'all',
				debug: true
			},
			demo1: {
				options: {
					idleading: 'demo1/dist/' //*当前路径为： seajs.base路径+当前路径=最终路径
				},
				files: [{
					expand: true,
					cwd: 'src',
					src: '**/*',
					filter: 'isFile',
					dest: '.build/'
				}]
			}
		},

		concat: {
			demo1: {
				options: {
					include: 'relative' //spm-build 用的是这个
				},
				files: [{
					expand: true,
					cwd: '.build/',
					//src: ['**/*.js'],
					src: '<%= pkg.spm.main %>',
					//入口文件
					dest: 'dist/'
				}]
			}
		},

		uglify: {
			options: {
				banner: '/** LastChange:  ' + (new Date()).toLocaleDateString() + '\r */',
				sourceMap: false,
				sourceMapIncludeSources: false,
				sourceMapName: function(path) {
					return path.replace(/js$/, 'map').replace('.js$', ".map");
				},
				sourceMapRoot: true
			},
			demo1: {
				files: [{
					expand: true,
					cwd: 'dist/',
					src: ['**/*.js', '!**/*-debug.js'],
					dest: 'dist/',
					ext: '.js'
				}]
			}
		},

		clean: {
			demo1: ['.build']
		}

	});

	if(!isCurPath){
		//自定义目录
		//nodepath/grunt-cmd-transport/tasks/
		grunt.task.loadTasks(path.join(nodepath, 'grunt-cmd-transport', 'tasks'));
		grunt.task.loadTasks(path.join(nodepath, 'grunt-cmd-concat', 'tasks'));
		grunt.task.loadTasks(path.join(nodepath, 'grunt-contrib-uglify', 'tasks'));
		grunt.task.loadTasks(path.join(nodepath, 'grunt-contrib-clean', 'tasks'));
		grunt.task.loadTasks(path.join(nodepath, 'grunt-sea-hashmap', 'tasks'));
	}else{
		//加载模块
		grunt.loadNpmTasks('grunt-cmd-transport');
		grunt.loadNpmTasks('grunt-cmd-concat');
		grunt.loadNpmTasks('grunt-contrib-uglify');
		grunt.loadNpmTasks('grunt-contrib-clean');
		grunt.loadNpmTasks('grunt-sea-hashmap');
	}
	
	//grunt.registerTask('build-demo1', ['hashmap','transport:demo1', 'concat:demo1', 'uglify:demo1', 'clean']);
	grunt.registerTask('build', '编译项目', function(project){
		grunt.task.run(['hashmap:' + project,'transport:' + project, 'concat:' + project, 'uglify:' + project, 'clean:' + project]);
		console.log(project + "编译完成！");
	});

    //注册任务
    grunt.registerTask('default', '默认任务', function(){
        console.log("输入 grunt help 查看帮助");
    });

    //查看帮助
    grunt.registerTask('help', function(){
        console.log("查看帮助: ");
        console.log("");
        console.log("============================ 注意事项 ============================");
        console.log("如果出现：Fatal error: Unable to find local grunt.");
        console.log("在命令后面加上 --base=<grunt目录位置>");
        console.log("如：grunt build:demo1 --base=<grunt模块位置>");
        console.log("");

        console.log("============================ 编译命令 ============================");
        console.log("grunt build:demo1      => 编译项目demo1");
        console.log("");
    });
};

