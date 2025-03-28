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

//Call functions with arguments from the current environment
(
var f;

f = {|x, y, z| [x, y, z].postln};

Environment.use({
	~x = 7;
	~y = 8;
	~z = 9;

	f.valueEnvir(1, 2, 3); // all values supplied
	f.valueEnvir(1, 2); //z is looked up in the current Environment
	f.valueEnvir(1); // y and z are looked up int the current Environment
	f.valueEnvir(z: 1); //x and y are looked up in the current environment
});
)

(
var a, b, c, n;

n = 40;
a = {
	|freq, amp, pan|
	Pan2.ar(SinOsc.ar(freq), pan, amp);
	Pan2.ar(SinOsc.ar(freq), pan, amp);
};
b = {
	|amp, pan, freq|
	Pan2.ar(RLPF.ar(Saw.ar(freq), freq * 6, 0.1), pan, amp);
};
c = {
	|pan, freq, amp|
	Pan2.ar(Resonz.ar(GrayNoise.ar, freq * 2, 0.1), pan, amp*2);
};

Task({
	n.do({
		|i|
		SynthDef("Help-SPE4-EnvirDef-" ++ i.asString, {
			|out|
			var sound;
			Environment.use({
				~freq = exprand(80, 600);
				~amp = 0.1 + 0.3.rand;
				~pan = 1.0.rand2;
				sound = [a, b, c].choose.valueEnvir;
			});
			sound = CombC.ar(sound, 0.2, 0.2, 3, 1, out);
			sound = sound * EnvGen.kr(
				Env.sine, doneAction: Done.freeSelf, timeScale: 1.0 + 6.0.rand, levelScale: 0.3
			);
			Out.ar(out, sound);
		}).send(s);
		0.02.wait;
	});
	loop({
		Synth("Help-SPE4-EnvirDef-" ++ n.rand.asString);
		(0.5 + 2.0.rand).wait;
	});
}).play;
)























