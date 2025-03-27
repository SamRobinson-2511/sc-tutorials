//Server tutorial
i = Server.internal;

s = Server.local;

m = Server(\myServer, NetAddr("127.0.0.1", 58009));
m.boot;
m.quit;


s.boot;

(
SynthDef(\sine, {
	|freq=800|
	var osc;
	osc = SinOsc.ar(freq, 0, 0.1);
	Out.ar(0, osc);
}).writeDefFile;
)
s.sendSynthDef(\sine);
s.sendMsg("/s_new", "sine", x = s.nextNodeID, 1, 1);
s.sendMsg("/n_free", x);
s.quit;

s.boot;
//.add;
(
SynthDef(\sine, {
	|freq=800|
	var osc;
	osc = SinOsc.ar(freq, 0, 0.1);
	Out.ar(0, osc);
}).add;
)


//write to disk and send
(
SynthDef(\sine, {
	|freq=800|
	var osc;
	osc = SinOsc.ar(freq, 0, 0.1);
	Out.ar(0, osc);
}).load(s);
)

//send without writing
(
SynthDef(\sine, {
	|freq=800|
	var osc;
	osc = SinOsc.ar(freq, 0, 0.1);
	Out.ar(0, osc);
}).send(s);
)


//Using arguments
s.boot;

(
SynthDef(\sine, {
	|freq=800|
	var osc;
	osc = SinOsc.ar(freq, 0, 0.1);
	Out.ar(0, osc);
}).add;
)

s.sendMsg("/s_new", \sine, x = s.nextNodeID, 1, 1, "freq", 900);
s.sendMsg("/n_free", x);

s.sendMsg("/s_new", \sine, y = s.nextNodeID, 1, 1, "freq", 1000);
s.sendMsg("/n_free", y);

//bundles
(
s.sendMsg("/s_new", \sine, x = s.nextNodeID, 1, 1, "freq", 800);
s.sendMsg("/s_new", \sine, y = s.nextNodeID, 1, 1, "freq", 1001);
s.sendMsg("/s_new", \sine, z = s.nextNodeID, 1, 1, "freq", 1202);
)

(
s.sendMsg("/n_free", x);
s.sendMsg("/n_free", y);
s.sendMsg("/n_free", z);
)

(
s.sendBundle(0.2,
	["/s_new", \sine, x = s.nextNodeID, 1, 1, \freq, 800],
	["/s_new", \sine, y = s.nextNodeID, 1, 1, \freq, 1001],
	["/s_new", \sine, z = s.nextNodeID, 1, 1, \freq, 1202]);
s.sendBundle(1.2, ["/n_free", x], ["/n_free", y], ["/n_free", z]);
)

//Controlling a synth

s.sendMsg("/s_new", \sine, x = s.nextNodeID, 1, 1, \freq, 900 );
s.sendMsg("/n_set", x, \freq, 800);
s.sendMsg("/n_set", x, \freq, 700);
s.sendMsg("/n_free", x);

//Adding effects dynamically

( //define a noise pulse
SynthDef(\tish, {
	|freq=1200, rate=2|
	var osc, trg;
	trg = Decay2.ar(Impulse.ar(rate, 0, 0.3), 0.01, 0.3);
	osc = {WhiteNoise.ar(trg)}.dup;
	Out.ar(0, osc);
}).add;
)

(//define an echo effect
SynthDef(\echo, {
	|delay=0.2, decay=4|
	var in;
	in = In.ar(0, 2);
	ReplaceOut.ar(0, CombN.ar(in, 0.5, delay, decay, decay, 1, in));
}).add;
)

//start the pulse
s.sendMsg("/s_new", \tish, x = s.nextNodeID, 1, 1, \freq, 200, \rate, 1.2);

//add an effect
s.sendMsg("/s_new", \echo, y = s.nextNodeID, 1, 1);

//stop the effect
s.sendMsg("n_free", y);

//add an effect
s.sendMsg("s_new", \echo, z = s.nextNodeID, 1, 1, \delay, 0.1, \decay, 4);

//stop the effect
s.sendMsg("/n_free", z);

//stop the pulse
s.sendMsg("/n_free", x);



//Mapping an argument to a control bus
(
//define a control
SynthDef(\line, {
	|i_bus=10, i_start=1000, i_end=500, i_time=1|
	ReplaceOut.kr(i_bus, Line.kr(i_start, i_end, i_time, doneAction: Done.freeSelf));
}).add;
)

s.sendMsg("/s_new", \sine, x = s.nextNodeID, 1, 1, \freq, 900);
s.sendMsg("/c_set", 10, x);
s.sendMsg("/n_map", x, \freq, 10);
s.sendMsg("/c_set", 10, 1200);
s.sendMsg("/s_new", \line, s.nextNodeID, 0, 1);
s.sendMsg("/n_free", x);

//Sequencing with Routines
(
var space, offset, timer, saw, envsaw, sampler, delay;

SynthDef(\saw, {
	|out=100, pan=0, trig=0.0, freq=500, amp=1, cutoff=10000, rezz=1|
	freq = Lag.kr(freq, 0.1);
	Out.ar(out, Pan2.ar(RLPF.ar(Saw.ar([freq, freq*2], amp), cutoff, rezz), pan));
}).add;
)

(
SynthDef(\envsaw, {
	|out=100, pan=0, sustain=0.5, freq=500, amp=1, cutoff=10000, rezz=1|
	var env;
	env = EnvGen.kr(Env.perc(0.01, sustain, 0.2), doneAction: Done.none, gate: amp);
	Out.ar(out, Pan2.ar(RLPF.ar(Saw.ar(Lag.kr(freq, 0.1), env), cutoff, rezz) * amp, pan));
}).add;
)

(
SynthDef(\delay, {
	|out=0, delay=0.4, decay=14|
	var in;
	in = In.ar(out, 2);
	Out.ar(out, CombN.ar(in, 0.5, delay, decay, 1, in));
}).add;
)

(
SynthDef(\sampler, {
	|sample, trig=1, rate=1.0, out=0, bufnum=0, pan=0, amp=1, sustain=0.25|
	var env;
	env = EnvGen.kr(Env.perc(0.001, sustain, 0.001), doneAction: Done.freeSelf);
	Out.ar(out,
		Pan2.ar(
			PlayBuf.ar(1, bufnum, rate, InTrig.kr(trig), 0, 0) * amp, pan
		);
	)
}).add;

Tempo.bpm = 120;
timer = BeatSched.new;
offset = Tempo.tempo.reciprocal;

space = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

saw = Synth("saw");
delay = Synth.after(saw,"delay", [\decay, 20]);

timer.sched(0,{
    var r;
    r = Routine({ var wait, freq, cutoff,rezz;
        wait = Pseq([2],inf).asStream;
        freq = Pseq([30,40,42,40],inf).asStream;
        cutoff = Pfunc({500.rand2+1000}).asStream;
        rezz = 0.5;
        inf.do({
            saw.set("freq", freq.next.midicps, "cutoff", cutoff.next, "rezz", rezz, "amp", 0.1, "out", 0);
            (wait.next*offset).wait
        });
    });
    timer.sched(0, r);
});

timer.sched(0,{
    var r;
    r=Routine({ var wait, rate;
        wait = Pseq([0.25],inf).asStream;
        rate = Pfunc({0.5.rand}).asStream;
        inf.do({
            Synth.before(delay, "sampler", [\bufnum, space, \trig, 1, \amp,0.1, \rate, rate.next, \sustain,         wait.next]);
            (wait.next*offset).wait});});
        timer.sched(0,r);
});

)

(
TempoClock.beats = 120;
SynthDef(\patternefx_Ex, {
	|out, in|
	var audio, efx;
	audio = In.ar([20, 21], 2);
	efx = CombN.ar(audio, 0.5, [0.24, 0.4], 2, 1);
	Out.ar([0,1], audio+efx);
}).add;
Synth(\patternefx_Ex);

SynthDef(\pattern_Ex, {
	|out, freq=1000, gate=1, pan=0, cut=4000, rez=0.8, amp=1|
	Out.ar(out,
		Pan2.ar(
			RLPF.ar(
				Pulse.ar(freq, 0.05),
				cut, rez),
			pan) * EnvGen.kr(Env.linen(0.01, 1, 0.3), gate, amp, doneAction: Done.freeSelf);
	)
}).add;

SynthDef(\bass_Ex, {
	|out, freq=1000, gate =1, pan=0, cut=4000, rez=0.8, amp=1|
	Out.ar(out,
		Pan2.ar(
			RLPF.ar(
				SinOsc.ar(freq, 0.05),
				cut, rez),
			pan) * EnvGen.kr(Env.linen(0.01, 1, 0.3), gate, amp, doneAction: Done.freeSelf);
	)
}).add;

SynthDescLib.global.read;

Pseq([

Ptpar([
0,Pbind(\instrument,\pattern_Ex, \out, 20, \dur,Pseq([2],16), \root,[-24,-17], \degree,Pseq([0,3,5,7,9,11,5,1],2),     \pan,1,\cut,Pxrand([1000,500,2000,300],16), \rez,Pfunc({0.7.rand +0.3}), \amp,0.12),

0.5,Pbind(\instrument,\pattern_Ex, \out, 20, \dur,Pseq([Pseq([2],15),1.5],1), \root,-12, \degree,Pseq([0,3,5,7,9,11,5,1],2), \pan,-1,\cut,2000, \rez,0.6, \amp,0.1);
]),

Ptpar([
0,Pbind(\instrument,\pattern_Ex, \out, 20, \dur,2, \root,[-24,-17], \degree,Pseq([0,3,5,7,9,11,5,1],inf),     \pan,1,\cut,Pxrand([1000,500,2000,300],inf), \rez,Pfunc({0.7.rand +0.3}), \amp,0.12),

0,Pbind(\instrument,\bass_Ex, \dur,1, \root,-24, \degree,Pseq([0],inf), \pan,0, \cut,128, \rez,0.1, \amp,0.3),

0.5,Pbind(\instrument,\pattern_Ex, \out, 20, \dur,2, \root,-12, \degree,Pseq([0,3,5,7,9,11,5,1],inf), \pan,-1,\cut,2000, \rez,0.6, \amp,0.1);
]);


]).play;

)





















































































