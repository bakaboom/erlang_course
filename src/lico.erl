-module(lico).
-export([map/2,filter/2,all_keys/1,triangle/1]).

-spec map(fun(), list()) -> list().
map(Fun, List) ->
    [Fun(X) || X <- List].

-spec filter(fun(), list()) -> list().
filter(Fun, List) ->
    [X || X <- List, Fun(X)].

-spec all_keys([{Key::term(),Value::term()}]) -> [Key::term()].
all_keys(KVList) ->
    [K || {K,_} <- KVList].

-spec triangle(Perimeter::integer()) ->
		      [{integer(),integer(),integer()}].
triangle(N) ->
    [{A,B,C} || A <- lists:seq(1,N),
		B <- lists:seq(1,N),
		C <- lists:seq(1,N),
		A+B+C == N,
		A+B > C,
		A*A+B*B == C*C].
