-module(guards).
-compile(export_all).

factorial_1(0) ->
    1;
factorial_1(N) ->
    N*factorial_1(N-1).

factorial_2(0) ->
    1;
factorial_2(N) when N>0 ->
    N*factorial_2(N-1).

factorial_3(N) when N>0, is_integer(N) ->
    N*factorial_3(N-1);
factorial_3(0) ->
    1;
factorial_3(_) ->
    unexpected_value.

