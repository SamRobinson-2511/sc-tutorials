//Streams

7.next.postln;


//Stream and its subclass

//FuncStream that represents an infinite random sequence
(
var a;
a = FuncStream({#[1,2,3,4].choose});
5.do({a.next.postln});
)

//Routine
(
var a;
a = Routine({
	3.do({|i| i.yield} ) });
4.do({a.next.postln});
)

(
var a;
a = Routine({
	3.do({|i| (i + 1).do({|j| j.yield;})
	})
});
8.do({ a.next.postln ;})
)

//Math operations on streams

//applying a unary operator to a stream
(
var a, b;
a = Routine({
	10.do({|i| i.yield });
});
b = a.squared;
12.do({ b.next.postln });
)

//applying a binary operator on a stream
(
var a,b;
a = Routine({
	10.do({|i| i.yield})
});
b = a +100;
12.do({ b.next.postln});
)

//using a binary operator on two streams
(
var a, b, c;
a = Routine({
	10.do({|i| i.yield})
});
b = Routine({
	forBy (100, 280, 20, {|i| i.yield})
});
c = a + b;
12.do({ c.next.postln });
)

//Filtering operations on streams
(
var a, b;
a = Routine({
	10.do({ |i| i.yield })
});
b = a.collect({ |item| if(item.even, {item + 100}, { item })});
6.do({b.next.postln});
)

//select creates a stream that passes only items that return true
(
var a, b;
a = Routine({
	10.do({ |i| i.yield})
});
b = a.select({
	|item| item.odd
});
6.do({b.next.postln});
)

//reject does opposite of select
(
var a, b;
a = Routine({
	10.do({ |i| i.yield})
});
b = a.reject({
	|item| item.odd
});
6.do({b.next.postln});
)

//Making Music with Streams
(
s = Server.local;
SynthDef(\help_SPE1, {
	|i_out=0, freq|
	var out;
	out = RLPF.ar(
		LFSaw.ar( freq, mul: EnvGen.kr( Env.perc, levelScale: 0.3, doneAction: Done.freeSelf)),
		LFNoise1.kr(1, 36, 110).midicps,
		0.1
	);
	4.do({ out = AllpassN.ar(out, 0.05, [0.05.rand, 0.05.rand], 4)});
	Out.ar(i_out, out);
}).send(s);
)

//streams as a sequence of pitches
(
var stream, dur;
dur = 1/8;
stream = Routine({
	loop({
		if(0.5.coin, {
			24.yield;
			31.yield;
			36.yield;
			43.yield;
			48.yield;
			55.yield;
		});
		rrand(2,5).do({
			60.yield;
			#[63,65].choose.yield;
			67.yield;
			#[70, 72, 74].choose.yield;
		});
		rrand(3,9).do({ #[74, 75, 77, 79, 81].choose.yield });
	});
});
Routine({
	loop({
		Synth(\help_SPE1, [\freq, stream.next.midicps]);
		dur.wait;
	})
}).play;
)
































