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

