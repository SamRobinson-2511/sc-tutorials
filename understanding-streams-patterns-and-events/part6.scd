//Parallel Patterns
//Ppar

(
Ppar([
	Pbind(\dur, 0.2, \midinote, Pseq([62, 65, 69, 72], inf)),
	Pbind(\dur, 0.4, \midinote, Pseq([[50, 45], inf]))
]).play;
)

//Nested Ppars

(
Ppar([
	Pbind(
		\dur, Prand([0.2, 0.4, 0.6], inf),
		\midinote, Prand([72, 74, 76, 77, 79, 81], inf),
		\db, -26,
		\legato, 1.1
	),
	Pseq([
		Pbind(\dur, 3.2, \freq, Pseq([\rest])),
		Prand([
			Ppar([
				Pbind(\dur, 0.2, \pan, 0.5, \midinote, Pseq([60, 64, 67, 64])),
				Pbind(\dur, 0.4, \pan, -0.5, \midinote, Pseq([48, 43]))
			]),
			Ppar([
				Pbind(\dur, 0.2, \pan, 0.5, \midinote, Pseq([62, 65, 69, 65])),
				Pbind(\dur, 0.4, \pan, -0.5, \midinote, Pseq([50, 45]))
			]),
			Ppar([
				Pbind(\dur, 0.2, \pan, 0.5, \midinote, Pseq([64, 67, 71, 67])),
				Pbind(\dur, 0.4, \pan, -0.5, \midinote, Pseq([52, 47]))
			])
		], 12)
	], inf)
], inf).play;
)

//Ppar: start all subpatterns at the same time
//Ptpar:

(
var makePattern, durpat;

durpat = Pseq([ Pgeom(0.05, 1.1, 24), Pgeom(0.5, 0.909, 24)], 2);

makePattern = {
	|note, db, pan|
	Pbind(\dur, durpat, \db, db, \pan, pan, \midinote, Pseq([note, note-4], inf))
};
Ptpar([
	0.0, makePattern.value(53, -20, -0.9),
	2.0, makePattern.value(60, -23, -0.3),
	4.0, makePattern.value(67, -26, 0.3),
	6.0, makePattern.value(74, -29, 0.9)
], inf).play;
)

//FilterPatterns and transformation
//Padd, Pmul, Pset, Pstretch

(
var pattern;

pattern = Pbind(
	\dur, 0.15,
	\degree, Pseq([ Pshuf(#[-7, -3, 0, 2, 4, 7], 4), Pseq([0, 1, 2, 3, 4, 5, 6, 7])], 1)
);

Pseq([
	pattern,
	Padd(\mtranspose, 1, pattern),
	Padd(\mtranspose, 2, pattern)
], inf).play;
)

//Pmul
(
var pattern;

pattern = Pbind(
	\dur, 0.15,
	\degree, Pseq([ Pshuf(#[-7, -3, 0, 2, 4, 7], 4), Pseq([0, 1, 2, 3, 4, 5, 6, 7])], 1)
);

Pseq([
	pattern,
	Pstretch(0.5, pattern),
	Pstretch(2.0, pattern)
], inf).play;
)
//Paddp, Pmulp, Psetp, Pstretchp
(
var pattern;

pattern = Pbind(
	\dur, 0.15,
	\degree, Pseq([ Pshuf(#[-7, -3, 0, 2, 4, 7], 4), Pseq([0, 1, 2, 3, 4, 5, 6, 7])], 1)
);

Paddp(
	\mtranspose,
	Pseq([0, 1, 2], inf),
	pattern
).play;
)

//Nested modifications
(
var pat1, pat2;

pat1 = Pbind(
	\dur, 0.15,
	\degree, Pseq([ Pshuf(#[-7, -3, 0, 2, 4, 7], 4), Pseq([0, 1, 2, 3, 4, 5, 6, 7])], 1)
);

pat2 = Paddp(
	\mtranspose,
	Pseq([0,1,2]),
	Ppar([
		pat1,
		Padd(\mtranspose, -3, pat1),
		Padd(\mtranspose, 2, pat1)
	])
);

Pseq([
	pat1,
	pat2,
	Pstretch(1.5, pat2)
], inf).play
)

//Another example using Paddp

(
var chord;
chord = Prand([[53, 58, 64], [53, 60, 64], [57, 60, 65]]);
Paddp(\ctranspose, Prand([-1, 0, 2, 4, 5], inf),
	Ppar([
		Pbind(
			\dur, Prand([0.2, 0.4, 0.6], inf),
			\midinote, Pxrand([71, 72, 74, 76, 77, 79], 10),
			\db, -26,
			\legato, 1.1
		),
		Pbind(
			\pan, -0.4,
			\dur, 0.4,
			\midinote, Pseq([38, 45, 38, 36], 4)
		)
	])
).play;
)

(
var pattern;

pattern = Pbind(
	\dur, 0.1,
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7])
);

Paddp(
	\ctranspose,
	Pseries(0, 1, 12),
	pattern
).play;
)

//beat time-stretching
(
var pattern;

pattern = Pbind(
	\dur, 0.1,
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7])
);

Pstretchp(
	Pseq([1,2,3], inf),
	pattern
).play;
)

//Pbindf
(
var pattern;
pattern = Pbind(\midinote, Pseq(#[60 ,62, 64, 65, 67, 69, 71, 72]));

Pseq([
	Pbindf(pattern, \legato, 0.1, \dur, 0.2),
	Pbindf(pattern, \legato, 1.0, \dur, 0.125),
	Pbindf(pattern, \legato, 2.0, \dur, 0.3)
], inf).play;
)

(
var pattern;
pattern = Pbind(\midinote, Pseq(#[60, 62, 64, 67, 69, 71, 74, 76, 77, 79]));

Pseq([
	Pbindf(pattern, \legato, 0.1, \dur, Pgeom(0.3, 0.85, inf)),
	Pbindf(pattern, \legato, 1.0, \dur, Pgeom([0.3, 0.15], inf)),
	Pbindf(pattern, \legato, 2.0, \dur, Pgeom([0.2, 0.2, 0.4],inf)),
], inf).play;
)
















