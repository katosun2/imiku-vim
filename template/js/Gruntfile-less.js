module.exports = function(grunt) {
	grunt.initConfig({
		pkg: grunt.file.readJSON('package.json'),
		less: {
			// 编译
			compile: {
				files: {
					'css/main.css': 'css/main.less'
				}
			},
			// 压缩
			yuicompress: {
				files: {
					'css/main-min.css': 'css/main.css'
				},
				options: {
					yuicompress: true
				}
			},
			test2: {
				options: {
					paths: ['js/base']
				},
				// target name
				src: {
					// no need for files, the config below should work
					expand: true,
					cwd:    "js/base",
					src:    "*.less",
					dest : "js/base",
					ext:    ".css"
				}
			}
		},
		watch: {
			scripts: {
				files: ['css/*.less'],
				tasks: ['less']
			}
		}
	});

	grunt.loadNpmTasks('grunt-contrib-less');
	grunt.loadNpmTasks('grunt-contrib-watch');

	grunt.registerTask('default', ['less', 'watch']);

};

