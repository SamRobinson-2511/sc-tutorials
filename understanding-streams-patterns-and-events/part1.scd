//Streams

7.next.postln;


//Stream and its subclass

//FuncStream that represents an infinite random sequence
(
var a;
a = FuncStream({#[1,2,3,4].choose});
5.do({a.next.postln});
)

//Routine
(
var a;
a = Routine({
	3.do({|i| i.yield} ) });
4.do({a.next.postln});
)

(
var a;
a = Routine({
	3.do({|i| (i + 1).do({|j| j.yield;})
	})
});
8.do({ a.next.postln ;})
)

//Math operations on streams

//applying a unary operator to a stream
(
var a, b;
a = Routine({
	10.do({|i| i.yield });
});
b = a.squared;
12.do({ b.next.postln });
)

//applying a binary operator on a stream
(
var a,b;
a = Routine({
	10.do({|i| i.yield})
});
b = a +100;
12.do({ b.next.postln});
)

//using a binary operator on two streams
(
var a, b, c;
a = Routine({
	10.do({|i| i.yield})
});
b = Routine({
	forBy (100, 280, 20, {|i| i.yield})
});
c = a + b;
12.do({ c.next.postln });
)

//Filtering operations on streams
(
var a, b;
a = Routine({
	10.do({ |i| i.yield })
});
b = a.collect({ |item| if(item.even, {item + 100}, { item })});
6.do({b.next.postln});
)





































