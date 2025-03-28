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
