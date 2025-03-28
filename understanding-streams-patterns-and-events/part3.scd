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


//pass a function for the repeats variable that gets evaluated when the stream is created
(
var a, b;
a = Pseq(#[1, 2], { rrand(1, 3) });
b = a.asStream;
7.do({ b.next.postln });
)

//repeats indefinitely  when inf for repeats variable
(
var a, b;
a = Pseq(#[1, 2, 3], inf);
b = a.asStream;
10.do({ b.next.postln });
)


//Pseq as pitches, math operations like midicps can be used on streams
(
var a, d;
a = Pseq(#[60, 61, 63, 65, 67, 63], inf).asStream.midicps;
d = 0.3;
Task({
	12.do({
		Synth(\help_SPE3_SimpleSine, [\freq, a.next, \sustain, d]);
		d.wait;
	});
}).play;
)


//Pser
(
var a, b;
a = Pser(#[1, 2, 3], 5);
b = a.asStream;
6.do({ b.next.postln });
)


(
var a, b;
a = Prand(#[1, 2, 3, 4, 5], 6);
b = a.asStream;
7.do({ b.next.postln });
)

//Prand used as a series of pitches
(
var a, d;
a = Prand(#[60, 61, 63, 65], inf).midicps.asStream;
d = 0.3;
Task({
	12.do({
		Synth(\help_SPE3_SimpleSine, [\freq, a.next]);
		d.wait;
	});
}).play;
)

//Pxrand

(
var a, b;
a = Pxrand(#[60, 61, 63, 65], inf).midicps.asStream;
d = 0.8;
Task({
	12.do({
		Synth(\help_SPE3_SimpleSine, [\freq, a.next]);
		d.wait;
	});
}).play;
)


//Pshuf scrambles
(
var a, b;
a = Pshuf(#[1, 2, 3, 4], 3);
b = a.asStream;
13.do({ b.next.postln });
)

//Pshuf with pitches
(
var a, b;
a = Pshuf(#[60, 61, 65, 67], inf).midicps.asStream;
Task({
	12.do({
		Synth(\help_SPE3_SimpleSine, [\freq, a.next]);
		0.5.wait;
	});
}).play;
)

//Nesting patterns
(
var a, b;
a = Pseq([1, Pseq([100, 200], 2), 3], 3);
b = a.asStream;
19.do({b.next.postln});
)

//Pseqs nested in a Prand
(
var a, b;
a = Prand([
	Pseq([1, 2], 2),
	Pseq([3, 4], 2),
	Pseq([5, 6], 2)
], 3);
b = a.asStream;
13.do({b.next.postln});
)


//Nested sequences of pitches
(
var a;
a = Prand([
	Pseq(#[60, 61, 63, 65, 67, 63]),
	Pseq(#[72, 73, 75, 77, 79], 6),
	Pseq(#[48, 53, 55, 58], 2),
], inf).midicps.asStream;
Task({
	loop({
		Synth(\help_SPE3_SimpleSine, [\freq, a.next]);
		0.3.wait;
	});
}).play;
)

//Math operations with ListPatterns
(
var a, b;
a = Pseq(#[60 ,62, 63, 65, 67, 63]);
b = Pseq([a, a + 7, a + 5], inf).asStream;
Task({
	24.do({
		Synth(\help_SPE3_SimpleSine, [\freq, b.next.midicps ]);
		0.3.wait;
	});
}).play;
)

//Adding two patterns together, the second pattern transposes each fifth note down an octave
(
var a;
a = Pseq(#[60, 62, 63, 65, 67, 63], inf) + Pseq(#[0, 0, 0, 0, -12], inf);
a = a.asStream.midicps;
Task({
	25.do({
		Synth(\help_SPE3_SimpleSine, [\freq, a.next]);
		0.3.wait;
	});
}).play;
)


//Making Music with ListPatterns
(
SynthDef(\help_SPE3_Allpass6, {
	|freq|
	var out, env;
	out = RLPF.ar(
		LFSaw.ar( freq, mul: EnvGen.kr(Env.perc, levelScale: 0.3, doneAction: Done.freeSelf)),
		LFNoise1.kr(1, 36, 110).midicps,
		0.1
	);
	6.do({ out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4)});
	Out.ar(0, out);
}).add;
)

(
var freqStream;
freqStream = Pseq([
	Prand([
		nil,
		Pseq(#[24, 31, 36, 43, 48, 55]);
	]),
	Pseq([60, Prand(#[63, 65]), 67, Prand(#[70 ,72, 74])], {rrand(2, 5)}),
	Prand(#[74, 75, 77, 79, 81], {rrand(3, 9)})
], inf).asStream.midicps;

Task({
	loop({
		Synth(\help_SPE3_Allpass6, [\freq, freqStream.next]);
		0.13.wait;
	});
}).play;
)

//Rhythmic solo

(
SynthDef(\help_SPE3_Mridangam, {
	|out, t_amp|
	var sound;

	sound = Resonz.ar(
		WhiteNoise.ar(70) * Decay2.kr(t_amp, 0.002, 0.1),
		60.midicps,
		0.02,
		4
	).distort * 0.4;

	Out.ar(out, sound);
	DetectSilence.ar(sound, doneAction: Done.freeSelf);
}).add;

SynthDef(\help_SPE3_Drone, {
	|out|
	var sound;
	sound = LPF.ar(
		Saw.ar([60, 60.04].midicps)
		+
		Saw.ar([67, 67.04].midicps),
		108.midicps,
		0.007
	);
	Out.ar(out, sound);
}).add;
)

//percussion solo in 10/8

(
var stream, pat, amp;

pat = Pseq([
	Pseq(#[0.0], 10),

	//intro
	Pseq(#[0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0], 2),
    Pseq(#[0.9, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 0.2, 0.0, 0.0], 2),
    Pseq(#[0.9, 0.0, 0.0, 0.2, 0.0, 0.2, 0.0, 0.2, 0.0, 0.0], 2),
    Pseq(#[0.9, 0.0, 0.0, 0.2, 0.0, 0.0, 0.0, 0.2, 0.0, 0.2], 2),

	//solo
	Prand([
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.2, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.2]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.0, 0.2, 0.2, 0.7, 0.2, 0.0]),
        Pseq(#[0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.2, 0.2]),
        Pseq(#[0.9, 0.2, 0.2, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.2, 0.2, 0.2, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0, 0.4, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.4, 0.0, 0.0, 0.4, 0.2, 0.4, 0.2]),
        Pseq(#[0.9, 0.0, 0.2, 0.7, 0.0, 0.2, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.7, 0.0, 0.0, 0.0, 0.7, 0.0, 0.0]),
        Pseq(#[0.9, 0.7, 0.7, 0.0, 0.0, 0.2, 0.2, 0.2, 0.0, 0.0]),
        Pseq(#[0.9, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0])
    ], 30),

	Pseq(#[2.0, 0.0, 0.2, 0.5, 0.0, 0.2, 0.9,
        1.5, 0.0, 0.2, 0.5, 0.0, 0.2, 0.9,
        1.5, 0.0, 0.2, 0.5, 0.0, 0.2], 3),
    Pseq(#[5], 1),    // sam

    Pseq(#[0.0], inf)
]);

stream = pat.asStream;

Task({
	Synth(\help_SPE3_Drone);
	loop({
		if(( amp = stream.next ) > 0,
			{Synth(\help_SPE3_Mridangam, [\t_amp, amp ])}
		);
		(1/8).wait;
	});
}).play;
)













































































