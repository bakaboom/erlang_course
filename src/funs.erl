-module(funs).
-export([for/3]).

-spec for(XStart::integer(),XEnd::integer(),fun()/1) -> list().
for(XStart, XEnd, Fun(X)) ->
    
