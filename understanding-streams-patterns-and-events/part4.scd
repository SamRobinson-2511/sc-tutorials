//Environment
currentEnvironment.put(\myvariable, 999);
currentEnvironment.at(\myvariable).postln;

~myvariable = 888;


//making an environment
(
var a;
a = Environment.make({
	~a=100;
	~b=200;
	~c=300
});
a.postln;
)

//using an environment
(
var a;
a = Environment.make({
	~a = 10;
	~b = 200;
	~c = 3000;
});
a.use({
	~a + ~b + ~c
}).postln;
)

//use class method
(
var a;
a = Environment.use({
	~a = 10;
	~b = 200;
	~c = 3000;
	~a + ~b + ~c
}).postln;
)


























