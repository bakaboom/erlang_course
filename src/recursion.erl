-module(recursion).
-compile(export_all).

-spec sum([number()]) -> Sum::number().
sum([H|T]) ->
    H+sum(T);
sum([]) ->
    0.

-spec member(term(), list()) -> boolean().
member(Elem, [Elem|_]) ->
    true;
member(Elem, [_|T]) ->
    member(Elem, T);
member(_, []) ->
    false.

%%% --------------
%%% Tail recursion
%%% --------------
sum_tail(List) ->
    sum_tail(List,0).

sum_tail([H|T], Acc) ->
    sum_tail(T, H+Acc);
sum_tail([], Acc) ->
    Acc.

%%% -------------------------------
%%% Compare Body and Tail recursion
%%% -------------------------------
fib(0) -> 0;
fib(1) -> 1;
fib(N) -> fib(N-1) + fib(N-2).

fib_tail(N) ->
    fib_tail(N, 0, 1).

fib_tail(0, Result, _) ->
    Result;
fib_tail(Iter, Result, Next) ->
    fib_tail(Iter-1, Next, Result+Next).

compare_fib(N) ->
    {TailTime,Result} = timer:tc(?MODULE,fib_tail,[N]),
    {BodyTime,Result} = timer:tc(?MODULE,fib,[N]),
    {{body,BodyTime},{tail,TailTime}}.

compare_sum(List) ->
    {TailTime,Result} = timer:tc(?MODULE,sum_tail,[List]),
    {BodyTime,Result} = timer:tc(?MODULE,sum,[List]),
    {{body,BodyTime},{tail,TailTime}}.

