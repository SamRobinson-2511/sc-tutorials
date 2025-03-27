s.boot;

FreqScope.new;

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





