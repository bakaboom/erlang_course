-module(map).
-export([create/1, read/1, update/3]).

create(empty) ->
    #{};
create(any) ->
    #{12345 => "Joe Dow",
      phone => 3535,
      {office, "Деловая"} => true}.

read(#{phone := Phone, {office, "Деловая"} := Office}) ->
    {Phone, Office}.

update(Map, _, _) when is_map(Map),
		       Map == #{12345 => "Joe Dow"} ->
    Map#{12345 => "Jane Dow"};
update(Map, Phone, Office) ->
    Map#{phone := Phone, office => Office}.
