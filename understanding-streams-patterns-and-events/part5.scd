//protoEvents

(
Pbind.new.play;
)

(
Pbind(\dur, 0.25).play;
)

(
Pbind(
	\dur, 0.125,
	\legato, 0.2,
	\midinote, Pseq(#[60, 62, 64, 65, 67, 69, 71, 72], inf)
).play;
)

//~finish

//The Pitch Model
(
~freq = {
	(~midinote.value + ~ctranspose).midicps
};
)

(
Pbind(
	\dur, 0.25,
	\freq, Pseq(#[300, 400, 500, 700, 900], inf)
).play;
)

(
Pbind(
	\dur, 0.25,
	\detune, -20,
	\freq, Pseq(#[300, 400, 500, 700, 900], inf)
).play;
)

//midinote
(
Pbind(
	\dur, 0.2,
	\midinote, Pseq([Pshuf(#[60, 61, 62, 63, 64, 65, 66, 67], 3)], inf)
).play;
)


(
Pbind(
	\degree, Pseq([ Pshuf(#[-7,-3,0,2,4,7], 4), Pseq([0,1,2,3,4,5,6,7]) ], inf),
	\dur, 0.15
).play;
)

(
Pbind(
    \dur, 0.15,
    \octave, 4,
    \degree, Pseq([ Pshuf(#[-7,-3,0,2,4,7], 4), Pseq([0,1,2,3,4,5,6,7]) ], inf)
).play;
)














