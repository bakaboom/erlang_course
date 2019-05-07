-module(funs).
-export([multiply/1,for/4,for_gen/1,triple/3]).

-define(TRIPLE, fun(X,List) -> [X*3|List] end).


double(X) ->
    X*2.

multiply(List) ->
    multiply(fun(X) -> X*2 end,List,[]).

multiply(_,[],Output) ->
    lists:reverse(Output);
multiply(Fun,[X|Tail],Output) ->
    multiply(Fun,Tail,[Fun(X)|Output]).

%%% ------------------
%%% Custome 'for' loop
%%% ------------------
-spec for(First::integer(),Last::integer(),
	  Statement::fun(),InitState::term()) -> term().
for(X, X, Fun, State) ->
    Fun(X, State);
for(X, Y, Fun, State) ->
    for(X+1, Y, Fun, Fun(X,State)).

-spec for_gen(fun()) -> fun().
for_gen(Statement) ->    
    fun For(X,X,State) ->
	    Statement(X,State);
	For(X,Y,State) when X<Y ->
	    For(X+1,Y,Statement(X,State));
	For(X,Y,State) ->
	    For(X-1,Y,Statement(X,State))
    end.

triple(First, Last, Init) ->
    TripleFor = for_gen(?TRIPLE),
    TripleFor(First, Last, Init).
    
