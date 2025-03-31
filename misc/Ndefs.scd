
Server.killAll;
s.boot.scope;
s.scope;
FreqScope.new;
NodeProxy


Ndef(\a).play;
Ndef(\a).fadeTime = 2;
Ndef(\a, { SinOsc.ar([350, 351.3], 0, 0.2)});
Ndef(\a, { Pulse.ar([350, 351.30] , 4, 0.4, 0.2)});
Ndef(\a, Pbind(\dur, 0.03, \freq, Pbrown(0, 1, 0.1, inf).linexp(0, 1, 200, 350)));
Ndef(\a, { Ringz.ar(Ndef.ar(\b), [350, 351.3] * 2, 0.15)});
Ndef(\b, { Impulse.ar([5, 7]/2, [0, 0.5], 0.15)});
Ndef.clear(3);


//https://www.youtube.com/watch?v=PJdyTTZERYs
(
Ndef(\q3, {
	|freq=440, pan=0|
	/*SinOsc.ar(freq)!2 * 0.25*/
	var sig = LFTri.ar(freq);
	sig = Pan2.ar(sig, pan);
	sig * 0.25
}).play;
)
Ndef(\q3).fadeTime = 2;
Ndef(\q3).clear;
Ndef(\q3).set(\freq, 400);
Ndef(\q3).fadeTime = 2;
Ndef(\q3).set(\freq, rrand(80, 220)); //abrupt change in frequency
Ndef(\q3).xset(\freq, rrand(80, 520), \pan, rrand(-1.0, 1.0));//less abrupt change offrequency
Ndef(\q3).fadeTime = 10;

//add efx
(
Ndef(\q3)[1] = \filter -> {
	|in, freqshiftfreq=1|
	FreqShift.ar(in, freqshiftfreq)
}
)
(
Ndef(\q3)[1] = \filter -> {
	|in, pitchy=0.5, pitchdispersion=0.1, timedispersion=0.1|
	PitchShift.ar(in, 0.25, pitchy, pitchdispersion, timedispersion)
}
)

Ndef(\q3).xset(\wet2, 1.0);
Ndef(\q3).gui;

//Maybe a method from JITLibExtensions quark
Ndef(\q3).addSpec(/*.....*/);

//NodeProxy roles help file

//change the range of the pitch argument from 0.25 to 10.0
(
Spec.specs[\freq]; //the default specification for the frequency parameter
Spec.add(\pitchy, [0.25, 10.0, \lin, 0.0, 0.5, "piiiii"]);
Spec.specs[\pitchy];
)

//make a copy of \q3 and call it \q4
Ndef(\q3).play;
Ndef(\q3).copy(\q4);
Ndef(\q4).xset(\freq, rrand(250, 500), \pan, rrand(-1.0, 1.0)).play;
Ndef(\q3).stop;
Ndef(\q3).xset(\freq, 80, \wet2, 0.9, \pitchy, 9);

//NodeProxy roles
s.boot;
s.scope;
FreqScope();
Ndef(\q3).play;

(
Ndef(\q3)[999] = \pset -> Pbind(
	\dur, 4,
	\freq, Pwhite(100, 500)
)
)

Ndef(\q3).fadeTime = 10;
(
Ndef(\q3)[999] = \xset -> Pbind(
	\dur, Pseq([4,7, 5, 8], inf),
	\freq, Pwhite(100, 500),
	\timedispersion, 0.0,
	\pitchdispersion, 0.0,
	\pitchy, Prand([0.5, 2,5, 1.0, 0.75], inf),
	\pan, Pwhite(-1.0, 1.0)
)
)

//LFOs and mappings
Ndef(\q4).play;

Ndef(\squank, {|lfofreq=0.1| LFSaw.kr(lfofreq)});
Ndef(\squank2, {|lfofreq=5.1| LFSaw.kr(lfofreq).linlin(-1.0, 1.0, 40, 2500)});
Ndef(\squank2).map(\lfofreq, Ndef(\squank));
(
Ndef(\squank)[999] = \xset -> Pbind(
	\dur, Pwhite(1.0, 8.0),
	\lfofreq, Pwhite(0.001, 10.0)
);
)
Ndef(\squank).copy(\squankthethird);

Ndef(\q4).xmap(\pan, Ndef(\squankthethird));


Ndef(\squank).copy(\squank2);

Ndef(\q3).gui
Ndef(\q4).gui

Ndef(\q4).map(\timedispersion, nil, \pitchy, Ndef(\squank), \freq, Ndef(\squank2));
Ndef(\q4).set(\wet1, 0.85);
Ndef(\q4).set(\wet2, 0.85);


















































