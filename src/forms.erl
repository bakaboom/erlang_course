-module(forms).
-compile(export_all).

reply_handling(Reply) ->
    Value = case Reply of
		{ok,Result} when is_number(Result) ->
		    Result;
		{error, Error} ->
		    logger:error("~p",[Error]),
		    error
	    end.

number_sign(X) ->
    if
	X > 0 ->
	    positive;
	X < 0 ->
	    negative;
	true ->
	    it_is_zero
    end.
