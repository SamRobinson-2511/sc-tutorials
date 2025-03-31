
Server.killAll;
s.boot;
s.scope;
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
Ndef(\q3)[2] = \filter -> {
	|in, pitchy=0.5, pitchdispersion=0.1, timedispersion=0.1|
	PitchShift.ar(in, 0.25, pitchy, pitchdispersion, timedispersion)
}
)

Ndef(\q3).xset(\wet2, 0.0);
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




























