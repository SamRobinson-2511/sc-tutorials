//List Patterns

//Pseq
(
SynthDef(\help_SPE3_SimpleSine, {
	|out, freq=440, sustain=1.0|
	var osc;
	osc = SinOsc.ar( [freq, freq+0.05.rand], 0.5pi) *
		EnvGen.ar(Env.perc, doneAction: Done.freeSelf, levelScale: 0.3, timeScale: sustain);
	Out.ar(out, osc);
}).add;
)

(
var a, b;
a = Pseq(#[1,2,3],2);
b = a.asStream;
7.do({ b.next.postln });
)

//with offset
(
var a, b;
a = Pseq(#[1, 2, 3, 4], 3, 2);
b = a.asStream;
13.do({ b.next.postln });
)









