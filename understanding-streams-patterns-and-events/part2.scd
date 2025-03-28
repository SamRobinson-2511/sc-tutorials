//Patterns
(
a  = 7.asStream;
a.postln;
a.next.postln;
)

//Pattern and its subclasses

//Pfunc returns a FuncStream
(
var a, b;
a = Pfunc({ #[1,2,3,4].choose});
b = a.asStream;
5.do({ b. next.postln });
)

//Prout returns a routine
(
var a, b, c;
a = Prout({
	3.do({
		|i|
		3.rand.yield
	})
});
b = a.asStream;
c = a.asStream;
4.do({ b.next.postln });
4.do({ c.next.postln });
)

//Pseries generates arithmetic series
(
var a, b;
a = Pseries(10, 3, 8);
b = a.asStream;
9.do({b.next.postln});
)

//Pgeom generates geometric series
(
var a, b;
a = Pgeom(10, 3, 8);
b = a.asStream;
9.do({b.next.postln});
)


//Math operations on patterns

//applying a unary operator on a pattern
(
var a, b, c;
a = Pseries(0, 1, 10);
b = a.squared;
c = b.asStream;
12.do({c.next.postln});
)

//applying binary operators on patterns
(
var a, b, c;
a = Pseries(0, 1, 10);
b = a + 100;
c = b.asStream;
12.do({ c.next.postln });
)


//Filtering operations on patterns
(
var a, b, c;
a = Pseries(0, 1, 10);
b = a.collect({ |item| if(item.even, {item + 100}, {item })
});
c = b.asStream;
6.do({ c.next.postln });
)

//select creates a pattern whose stream passes only items that return true
(
var a, b, c;
a = Pseries(0, 1, 10);
b = a.select({ |item| item.odd });
c = b.asStream;
6.do({ c.next.postln });
)

//reject does opposite of select
(
var a, b, c;
a = Pseries(0, 1, 10);
b = a.reject({ |item| item.odd });
c = b.asStream;
6.do({ c.next.postln });
)

(
s = Server.local;
SynthDef(\help_SPE2, {
	|i_out=0, sustain=1, freq|
	var out;
	out = RLPF.ar(
		LFSaw.ar( freq ),
		LFNoise1.kr(1, 36, 110).midicps,
		0.1
	) * EnvGen.kr(Env.perc, levelScale: 0.3, timeScale: sustain, doneAction: Done.freeSelf);
	4.do({out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4)});
	Out.ar(i_out, out);
}).send(s);
)

(
//streams as sequences of pitches
var pattern, streams, dur, durDiff;
dur = 1/7;
durDiff = 3;
pattern = Prout({
	loop({
		if (0.5.coin, {
			#[ 24, 31, 36, 43, 48, 55].do({ |fifth| fifth.yield });
		});
		rrand(2, 5).do({
			60.yield;
			#[63, 65].choose.yield;
			67.yield;
			#[70, 72, 74].choose.yield;
		});
		rrand(3, 9).do({ #[74, 75, 77, 79, 81].choose.yield })
	});
});
streams = [
	(pattern - Pfunc({#[12, 7, 7, 0].choose })).midicps.asStream,
	pattern.midicps.asStream
];
Routine({
	loop({
		Synth(\help_SPE2, [\freq, streams.at(0).next, \sustain, dur * durDiff ]);
		durDiff.do({
			Synth(\help_SPE2, [\freq, streams.at(1).next, \sustain, dur ]);
			dur.wait;
		});
	});
}).play;
)






















//Making music with patterns

















