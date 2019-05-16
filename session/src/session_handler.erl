-module(session_handler).
-export([start_link/1]).

start_link(Id) ->
    Pid = spawn_link(fun() -> init(Id) end),
    {ok, Pid}.

init(Id) ->
    process_flag(trap_exit, true),
    loop(Id).

loop(Id) ->
    receive
	{Id,From,ping} ->
	    From ! {Id,self(),pong},
	    loop(Id);
	normal ->
	    ok;
	abnormal ->
	    exit(abnormal);
	{'EXIT',From,Reason} ->
	    io:format("Session ~p handler have got EXIT with ~p reason from ~p.~n",
		      [Id,Reason,From]),
	    loop(Id)
    end.
