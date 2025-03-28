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


        \dur, 0.15,
        \ctranspose, 0,
        \degree, notes
    ),
    Pbind(
        \dur, 0.15,
        \ctranspose, 3,
        \degree, notes
    ),
    Pbind(
        \dur, 0.15,
        \ctranspose, -3,
        \degree, notes
    )
], inf).play
)


(
// frequency detuning
var notes;
notes = Pseq([ Pshuf(#[-7,-3,0,2,4,7], 4), Pseq([0,1,2,3,4,5,6,7]) ], 1);
Pseq([
    Pbind(
        \dur, 0.15,
        \detune, 0,
        \degree, notes
    ),
    Pbind(
        \dur, 0.15,
        \detune, 20,
        \degree, notes
    ),
    Pbind(
        \dur, 0.15,
        \detune, 40,
        \degree, notes
    )
], inf).play
)


(
// chords. If an Array of pitches is returned by a Stream for pitch, then a chord
// will be played.
Pbind(
    \dur, 0.15,
    \degree, Pseq([
        Pshuf(#[-7,-3,0,2,4,7], 4)+[0,4],
        Pseq( [0,1,2,3,4,5,6,7] )+[0,2]
    ], inf)
).play
)


(
// composing in non 12 equal temperaments. 72 tone equal temp.
Pbind(
    \stepsPerOctave, 72,
    \note, Pseq([
            // 1/1, 7/6, 3/2, 7/4, 9/8
        Pseq([ [0,16,42,58,84], Pseq([ 0, 16, 42, 58, 72, 84 ], 2), [0,16,42,58,84] ], 1),
            // 1/1, 6/5, 3/2, 9/5, 9/8
        Pseq([ [0,19,42,61,84], Pseq([ 0, 19, 42, 61, 72, 84 ], 2), [0,19,42,61,84] ], 1),
            // 1/1, 5/4, 3/2, 15/8, 9/8
        Pseq([ [0,23,42,65,84], Pseq([ 0, 23, 42, 65, 72, 84 ], 2), [0,23,42,65,84] ], 1),
            // 1/1, 9/7, 3/2, 27/14, 9/8
        Pseq([ [0,26,42,68,84], Pseq([ 0, 26, 42, 68, 72, 84 ], 2), [0,26,42,68,84] ], 1)
        ], inf),
    \dur, Pseq([ 1.2, Pseq([0.15], 12), 1.2], inf)
).play
)


//The Duration Model

(
Pbind(
	\dur, Pseq([ Pgeom(0.05, 1.1, 24), Pgeom(0.5, 0.909, 24)], inf),
	\midinote, Pseq(#[60 ,58], inf)
).play;
)


(
Pbind(
	\dur, 0.2,
	\legato, Pseq([ Pseries(0.05, 0.05, 40), Pseries(2.05, -0.05, 40)], inf),
	\midinote, Pseq(#[48, 51, 55, 58, 60, 58, 55, 51], inf)
).play;
)






