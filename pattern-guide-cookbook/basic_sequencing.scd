//Playing a predefined note sequence
s.boot;
Server.default.options("")
//1. brute force
(
TempoClock.default.tempo = 84/60;

p = Pbind(
	\scale, #[0, 2, 3, 5, 7, 8, 10],
	\root, 2,
	\degree, Pseq(#[rest, 4, 3, 4, 2, 4, 1, 4, 0 , 4, -0.9, 4, 0, 4, 1, 4, 2, 4, -3, 4, -1.9, 4, -0.9, 4, 0, 4, -0.9, 4, 0, 4, 1, 4, 2], 1),
	\dur, 0.25
).play;
)

//2. Recognize pedal point
(
p = Pbind(
	\scale, #[0, 2, 3, 5, 7,  8, 10],
	\root, 2,
	\degree, Place([#[rest, 3, 2, 1, 0, -0.9, 0, 1, 2, -3, -1.9, -0.9, 0, -0.9, 0, 1, 2],
		(4 ! 16) ++ \rest], 17),
	\dur, 0.25
).play;
)
s.boot;

//3. Recognize pedal point
(
p = Pbind(
    \scale, #[0, 2, 3, 5, 7, 8, 10],
    \root, 2,
    \degree, Ppatlace([Pseq(#[rest, 3, 2, 1, 0, -0.9, 0, 1, 2, -3, -1.9, -0.9, 0, -0.9, 0, 1, 2], 1),
        Pn(4, 16)], inf),
    \dur, 0.25
).play;
)

//"Multichannel"" expansion

(
p = Pbind(
	\degree, Pseries(7, Pwhite(1, 3, inf) * Prand(#[-1,1], inf), inf).fold(0, 14) +
	Prand(#[[0, -2, -4], [0, -3, -5], [0, -2, -5], [0, -1, -4]], inf),
	\dur, Pwrand(#[1, 0.5], #[0.8, 0.2], inf)
).play;
)
p.stop;

//Using custom SynthDefs (including unpitched SynthDefs)
(
b = Buffer.read(s, )
)
b.play;
