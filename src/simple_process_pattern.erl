-module(simple_process_pattern).

start() ->
    %Start process instance
    spawn(?MODULE,init,[]).

init() ->
    %Initialize process
    register(..),
    loop().

loop() ->
    receive
	Pattern1 ->
	    do_smth(),
	    loop();
	Pattern2 ->
	    do_anth(),
	    loop();
	Pattern3 ->
	    exit(abnormal)
    end.
