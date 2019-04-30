-module(processes).
-export([start/1,sender/1,receiver/0]).

-define(TIMEOUT, 2*1000).

start(MsgNumber) ->
    SenderPid = spawn(?MODULE,sender,[MsgNumber]),
    io:format("~p will send to receiver.~n",[SenderPid]),
    _MonRef1 = erlang:monitor(process,sender),
    _MonRef2 = erlang:monitor(process,receiver),
    monitor_loop(2).
   
sender(Number)  ->
    process_flag(trap_exit, true),
    register(sender,self()),
    RecPid = spawn_link(?MODULE,receiver,[]),
    register(receiver,RecPid),
    sender(RecPid,Number).

sender(Pid, 0) ->
    erlang:send(Pid,die),
    %% receive
    %% 	{'EXIT',Pid,Reason} ->
    %% 	    io:format("~p is exited with ~p reason.~n",[Pid,Reason])
    %% after
    %% 	5000 ->
    %% 	    io:format("Timeout is expired.~n",[])
    %% end,
    timer:sleep(5000),
    io:format("Sender is done.~n",[]);

sender(Pid, Number) ->
    receiver ! {self(),Number},
    timer:sleep(?TIMEOUT),
    sender(Pid, Number-1).

receiver() ->
    receive
	{From,Msg} ->
	    io:format("Received ~p from ~p.~n",[Msg,From]),
	    receiver();
	die ->
	    exit(whereis(sender),kill),
	    timer:sleep(5000)
    end.

monitor_loop(0) ->
    ok;
monitor_loop(N) ->
    receive
	{'DOWN',_MonRef,process,Object,Reason} ->
	    io:format("~p is down with ~p reason.~n",[Object,Reason])
    end,
    monitor_loop(N-1).
