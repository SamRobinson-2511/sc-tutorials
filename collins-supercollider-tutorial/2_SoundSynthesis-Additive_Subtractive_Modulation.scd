s.boot;

FreqScope.new;


//2.1: Subtractive and Additive Synthesis

//Subtractive Synthesis
{WhiteNoise.ar(0.1)}.scope;

{LPF.ar(WhiteNoise.ar(0.1), 1000)}.scope;

{LPF.ar(WhiteNoise.ar(0.1), Line.kr(10000, 1000, 10))}.scope;


//Example of plugging one source into a filter
{Resonz.ar(LFNoise0.ar(400), 1000, 0.1)}.scope;

//use Line
{Resonz.ar(LFNoise0.ar(400), Line.kr(10000, 1000, 10), 0.1)}.scope;

(
{
	var source, line, filter;

	source = LFNoise0.ar(400);
	line = Line.kr(10000, 1000, 10);
	filter = Resonz.ar(source, line, 0.1);
	filter;

}.scope;
)

//Additive Synthesis

{SinOsc.ar}.scope;

//two
{SinOsc.ar(400, 0, 0.1) + SinOsc.ar(660, 0, 0.1)}.scope;

{SinOsc.ar([440, 660], 0, 0.1)}.scope;

//Panning
{Pan2.ar(WhiteNoise.ar(0.1), MouseX.kr(-1, 1))}.scope;

//Arrays
{SinOsc.ar([400], 0, 0.1)}.scope;
{SinOsc.ar(400, 0, 0.1)}.scope;

//two channels
{SinOsc.ar([440, 660], 0, 0.1)}.scope;

{SinOsc.ar([440, 660, 870], 0, 0.1)}.scope;

//Mix UGen (make mono)
{Mix(SinOsc.ar([400, 660], 0, 0.1))}.scope;

{Pan2.ar(Mix(SinOsc.ar([400, 660], 0, 0.1)), MouseX.kr(-1, 1))}.scope;


//Sawtooth
(
{
	var n = 10;

	var wave = Mix.fill(20, {
		|i|
		var mult = ((-1)**i)*(0.5/((i+1)));
		SinOsc.ar(440 * (i +1)) * mult
	});
	Pan2.ar(wave/n, 0.0);
}.scope;
)

//Square
(
{
	var n = 10;

	var wave = Mix.fill(10, {
		|i|
		var harmonicNumber = 2*i+1;
		SinOsc.ar(440 * harmonicNumber)/harmonicNumber
	}) * 0.25;
	Pan2.ar(wave, 0.0);
}.scope;
)


//Triangle
(
{
	var n = 10;
	var wave = Mix.fill(10, {
		|i|
		var hNum = 2*i+1;
		var mult = ((-1) ** ((hNum - 1 )/2)) * (1.0/(hNum*hNum));
		SinOsc.ar(440*i)*mult})/n;
	Pan2.ar(wave, 0.0);
}.scope;
)


//Bell sound example
500 * [0.5, 1, 1.19, 1.56, 2, 2.51, 2.66, 3.01, 4.1];

//various amplitudes
{Mix.ar(SinOsc.ar(500 * [0.5, 1, 1.19, 1.56, 2, 2.51, 2.66, 3.01, 4.1], 0, 0.1 * [0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1]))}.scope;


//generalizable

(
var n = 10;
{Mix.ar(SinOsc.ar(250*(1..n), 0, 1/n))}.scope;
)

//2.2: Mul and Add

//Mul
{SinOsc.ar(mul:0.1)}.scope;
{SinOsc.ar(mul: 2.0)}.scope;
{SinOsc.ar(mul: MouseY.kr(1.0, 0.1))}.scope;

//Add
{SinOsc.ar(mul:0.1, add: MouseY.kr(0.9, -0.9))}.scope;

(
{
	var cutoff = SinOsc.ar(1, mul: MouseX.kr(0.0, 1700.0), add: 2000.0);
	LPF.ar(WhiteNoise.ar, freq: cutoff);
}.scope;
)


//shortcut for mul and add : * +
{0.1 * SinOsc.ar}.scope;
{0.1 * SinOsc.ar + 0.5}.scope;



//filter example rewritten
(
{
	var cutoff = SinOsc.ar(1) * 1700.0 + 2000.0;
	LPF.ar(WhiteNoise.ar, freq: cutoff);
}.scope;
)


//addressing arguments
{SinOsc.ar(440, 0.0, 0.1, 0.0)}.scope;

{SinOsc.ar(MouseX.kr(440, 880), 0.0, 0.1, 0.0)}.scope;

{SinOsc.ar(MouseX.kr(440, 880), mul: 0.1)}.scope;


//same things
{SinOsc.ar(440, 0.0, 0.1)}.scope;
{SinOsc.ar(mul: 0.1)}.scope;
{0.1*SinOsc.ar}.scope;
{SinOsc.ar(440, mul: -20.dbamp)}.scope;


//a note on modulation
{SinOsc.ar(SinOsc.ar(3, mul: 40, add: 440), 0, 0.1)}.scope;


//2.3: Controlling Synths
a = {SinOsc.ar(440)*0.1}.play;
a.run(false);
a.run;
a.free;

//Arguments
a  = {arg freq =440, amp = 0.1; SinOsc.ar(freq)* amp}.play;
a.set(\freq, rrand(220, 440), \amp, rrand(0.05, 0.2));
a.free;


//2.3: Modulation Synthesis

//Ring Modulation
(
{
	var carrier, modulator, carrfreq, modfreq;

	carrfreq = MouseX.kr(440, 5000, 'exponential');
	modfreq = MouseY.kr(1, 5000, 'exponential');

	carrier = SinOsc.ar(carrfreq, 0, 0.5);
	modulator = SinOsc.ar(modfreq, 0, 0.5);

	carrier * modulator;

}.scope;
)


//Amplitude Modulation
(
{
	var carrier, modulator, carrfreq, modfreq;

	carrfreq = MouseX.kr(440, 5000, 'exponential');
	modfreq = MouseY.kr(1, 5000, 'exponential');

	carrier = SinOsc.ar(carrfreq, 0, 0.5);
	modulator = SinOsc.ar(modfreq, 0, 0.25, 0.25);

	carrier * modulator;
}.scope;
)

//Frequency Modulation
(
var w, carrfreqslider, modfreqslider, moddepthslider, synth;

w = Window("frequency modulation", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

synth = {
	|carrfreq=440, modfreq=1, moddepth=0.01|
	SinOsc.ar(carrfreq + (moddepth*SinOsc.ar(modfreq)), 0, 0.25)
}.scope;

carrfreqslider = EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {
	|ez|
	synth.set(\carrfreq, ez.value)
});
w.view.decorator.nextLine;

modfreqslider = EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {
	|ez|
	synth.set(\modfreq, ez.value)
});
w.view.decorator.nextLine;

moddepthslider = EZSlider(w, 300@50, "moddepth", ControlSpec(0.01, 5000, 'exponential', 0.01, 0.01), {
	|ez|
	synth.set(\moddepth, ez.value)
});

w.front;
)


(
var w, carrfreqslider, modfreqslider, modindexslider, synth;

w = Window("frequency modulation vs. modulation index", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

synth = {
	|carrfreq = 440, modfreq = 1, modindex = 0|
	SinOsc.ar(carrfreq + (modindex*modfreq*SinOsc.ar(modfreq)), 0, 0.25)
}.scope;

carrfreqslider = EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {
	|ez|
	synth.set(\modfreq, ez.value)
});
w.view.decorator.nextLine;

modfreqslider = EZSlider(w, 300@50, "modfreq", ControlSpec(20, 5000, 'exponential', 1, 1), {
	|ez|
	synth.set(\modfreq, ez.value)
});
w.view.decorator.nextLine;

modindexslider = EZSlider(w, 300@50, "modindex", ControlSpec(0.0, 1.0, 'linear', 0.01, 0.0), {
	|ez|
	synth.set(\modindex, ez.value)
});

w.front;
)


//via mouse
(
{
	var modfreq, modindex;

	modfreq = MouseX.kr(1, 440, 'exponential');
	modindex = MouseY.kr(0.0, 10.0);

	SinOsc.ar(SinOsc.ar(modfreq, 0, modfreq * modindex, 440), 0, 0.25)
}.scope;
)

//Moore: Elements of Computer Music
(
{
	var carrfreq, modfreq, harmonicity, modindex;
	carrfreq = 440;
	harmonicity = MouseX.kr(0, 10).round(1);
	modindex = MouseY.kr(0.0, 10.0);

	modfreq = carrfreq * harmonicity;

	SinOsc.ar(carrfreq + (SinOsc.ar(modfreq) * modfreq * modindex), 0.0, 0.1);

}.scope;
)


//Phase modulation
(
var w, carrfreqslider, modfreqslider, modindexslider, synth;
var conversion = 2pi/(s.sampleRate);

w = Window("phase modulation via modulation index", Rect(100, 400, 400, 300));
w.view.decorator = FlowLayout(w.view.bounds);

synth = {
	|carrfreq=440, modfreq=1, modindex=0|
	SinOsc.ar(carrfreq, ((modfreq*modindex)*conversion*SinOsc.ar(modfreq)), 0.25)
}.scope;

carrfreqslider = EZSlider(w, 300@50, "carrfreq", ControlSpec(20, 5000, 'exponential', 10, 440), {
	|ez|
	synth.set(\carrfreq, ez.value)
});
w.view.decorator.nextLine;

modfreqslider = EZSlider(w, 300@50, "modfreq", ControlSpec(1, 5000, 'exponential', 1, 1), {
	|ez|
	synth.set(\modfreq, ez.value)
});
w.view.decorator.nextLine;

modindexslider = EZSlider(w, 300@50, "modindex", ControlSpec(0.0, 100.0, 'linear', 0.01, 0.0), {
	|ez|
	synth.set(\modindex, ez.value)
});

w.front;
)

//PM via mouse control

(
{
	var modfreq, modindex, conversion;

	modfreq = MouseX.kr(1, 1000, 'exponential');
	modindex = MouseY.kr(0.0, 100.0);
	conversion = 2pi/(s.sampleRate);

	SinOsc.ar(0, Phasor.ar(0,440*conversion,0,2pi)+( (modfreq*modindex)*conversion*SinOsc.ar(modfreq)), 0.25)


}.scope
)

//2.5: More Synthesis

//Fat Chorus
{Mix(Saw.ar([440, 443, 437], 0.1))}.scope;

(
{
	Mix(
		Resonz.ar(
			Saw.ar([440, 443, 437] + SinOsc.ar(100, 0, 100)),
			XLine.kr(10000, 10, 10),
			Line.kr(1, 0.05, 10),
			mul: LFSaw.kr(Line.kr(3, 17, 3), 0, 0.5, 0.5) * Line.kr(1, 0, 10)
		)
	)
}.scope;
)

//Sample playback rate modulation

(
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
)

(
{
	var modfreq, modindex, modulator;

	modfreq = MouseX.kr(1, 4400, 'exponential');
	modindex = MouseY.kr(0.0, 10.0, 'linear');

	modulator = SinOsc.ar(modfreq, 0, modfreq*modindex, 440);

	PlayBuf.ar(1, b, BufRateScale.kr(b)*(modulator/440), 1, 0, 1)
}.scope;
)


//richer bell patch

(

var numpartials, spectrum, amplitudes, modfreqs1, modfreqs2, decaytimes;



spectrum = [0.5,1,1.19,1.56,2,2.51,2.66,3.01,4.1];



amplitudes= [0.25,1,0.8,0.5,0.9,0.4,0.3,0.6,0.1];



numpartials = spectrum.size;



modfreqs1 = Array.rand(numpartials, 1, 5.0); //vibrato rates from 1 to 5 Hz



modfreqs2 = Array.rand(numpartials, 0.1, 3.0); //tremolo rates from 0.1 to 3 Hz



decaytimes = Array.fill(numpartials,{|i|  rrand(2.5,2.5+(5*(1.0-(i/numpartials))))}); //decay from 2.5 to 7.5 seconds, lower partials longer decay

{

Mix.fill(spectrum.size, {arg i;

	var amp, freq;



	freq= (spectrum[i]+(SinOsc.kr(modfreqs1[i],0,0.005)))*500;

	amp= 0.1* Line.kr(1,0,decaytimes[i])*(SinOsc.ar(modfreqs2[i],0,0.1,0.9)* amplitudes[i]);



	Pan2.ar(SinOsc.ar(freq, 0, amp),1.0.rand2)});

}.scope



)