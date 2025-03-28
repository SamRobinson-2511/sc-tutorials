//Practical considerations
(
SynthDef(\help_SPE7_BerlinB, { arg i_out=0, freq = 80, amp = 0.2, pan=0;
    var out, a, b;
    amp = Decay2.kr(Impulse.kr(0), 0.05, 8, amp);
    out = RLPF.ar(
        LFPulse.ar(freq, 0, SinOsc.kr(0.12,[0,0.5pi],0.48,0.5), amp),
        freq * SinOsc.kr(0.21,0,4,8),
        0.07
    );
    #a, b = out;
    DetectSilence.ar(a, 0.0001, doneAction: Done.freeSelf);
    Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan+1])));
}).add;

SynthDef(\help_SPE7_CFString1, {
	|i_out, freq = 360, gate = 1, pan, amp=0.1|
	var out, eg, fc, osc, a, b, w;
	fc = LinExp.kr(LFNoise1.kr(Rand(0.25, 0.4)), -1, 1, 500, 2000);
	osc = Mix.fill(8, {LFSaw.ar(freq * [Rand(0.99, 1.01), Rand(0.99, 1.01)], 0, amp)}).distort*0.2;
	eg = EnvGen.kr(Env.asr(1, 1, 1), gate, doneAction: Done.freeSelf);
	out = eg * RLPF.ar(osc, fc, 0.1);
	#a, b = out;
	Out.ar(i_out, Mix.ar(PanAz.ar(4, [a,b], [pan, pan+0.3])));
}).add;
)


(
Pbind(
	\instrument, Prand([\help_SPE7_BerlinB, \help_SPE7_CFString1], inf),
	\degree, Pseq([0, 1, 2, 4, 6, 3, 4 ,8], inf),
	\dur, 0.8,
	\octave, 3,
	\amp, 0.03
).play;
)

//Defining your own message bindings
//Store in SynthDescLib

(
SynthDef(\help_SPE4_CFString2, { arg i_out, freq = 360, gate = 1, pan, amp=0.1, dorkarg=1;
    var out, eg, fc, osc, a, b, w;
    fc = LinExp.kr(LFNoise1.kr(Rand(0.25,0.4)), -1,1,500,2000);
    osc = Mix.fill(8, { LFSaw.ar(freq * [Rand(0.99,1.01),Rand(0.99,1.01)], 0, amp * dorkarg ) }).distort * 0.2;
    eg = EnvGen.kr(Env.asr(1,1,1), gate, doneAction: Done.freeSelf);
    out = eg * RLPF.ar(osc, fc, 0.1);
    #a, b = out;
    Out.ar(i_out, Mix.ar(PanAz.ar(4, [a, b], [pan, pan+0.3])));
}).send(s);    // change .send(s) to .add
)

(
Pbind(
    \instrument, \help_SPE4_CFString2,
    \degree, Pseq([0,1,2,4,6,3,4,8],inf),
    \dur, 0.4,
    \octave, 3,
    \amp, 0.03,
    \dorkarg, Pseq([1,0,1],inf) // silence every second note - doesn't work
).play;
)


(
Pbind(
    \instrument, \help_SPE4_CFString2,
    \degree, Pseq([0,1,2,4,6,3,4,8],inf),
    \dur, 0.4,
    \octave, 3,
    \amp, 0.03,
    \dorkarg, Pseq([1,0,1],inf), // silence every second note - now works
    \msgFunc, { arg out = 0, freq = 440, amp = 0.1, pan = 0, vol = 1,
            dorkarg = 1;
        [\out, out, \freq, freq, \amp, amp, \pan, pan, \vol, vol,
            \dorkarg, dorkarg];
    }
).play;
)

//Manipulate an EventStreamPlayer in real time
(
p = Pbind(
	\degree, Pwhite(0,12),
	\dur, 0.2,
	\instrument, \help_SPE4_CFString2
);
e = p.play;
)

(
//you can change the stream at any point in time
e.stream = Pbind(
	\degree, Pseq([0, 1, 2, 4, 6, 3, 4, 8], inf),
	\dur, Prand([0.2, 0.4, 0.8], inf),
	\amp, 0.05,
	\octave, 5,
	\instrument, \help_SPE7_BerlinB,
	\ctranspose, 0
).asStream;
)

(
e.stream = Pbind(
	[\degree, \dur], Pseq(
		[
			Pseq([[0, 0.1], [2, 0.1], [3, 0.1], [4, 0.1], [5, 0.8]], 2),
			Ptuple([Pxrand([6, 7, 8, 9], 4), 0.4]),
			Ptuple([Pseq([9, 8, 7, 6, 5, 4, 3, 2]), 0.2])
		], inf
	),
	\amp, 0.05,
	\octave, 5,
	\instrument, \help_SPE7_CFString1
).asStream;
)

e.mute; //keeps playing but replaces notes with rests
e.unmute;
e.reset;
e.pause;
e.resume;
e.stop;





















