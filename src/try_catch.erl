-module(try_catch).
-export([handler/1,error_gen/1]).

handler(Arg) ->
    try error_gen(Arg) of
	{ok, Result} ->
	    io:format("Successful result '~p'.~n",[Result]);
	{false, Result} ->
	    io:format("Unsuccessful result '~p'.~n",[Result])
    catch
	Error:Reason ->
	    io:format("We've got '~p' class exception with '~p' reason.~n",
		      [Error,Reason])
    after
     	io:format("Final case is done.~n")
    end.


error_gen(ok) ->
    {ok, done};
error_gen(false) ->
    {false, nothing};
error_gen(final) ->
    ok;
error_gen({badarg,Arg}) ->
    list_to_atom(Arg);
error_gen(throw) ->
    throw(try_to_catch_this_error);
error_gen(error) ->
    error(my_exception);
error_gen(exit) ->
    exit(abnormal).
