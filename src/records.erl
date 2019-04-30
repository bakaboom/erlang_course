-module(records).
-export([create/1, read/1, update/3]).

-record(person, {name              :: string(),
		 phone             :: integer(),
		 office = delovaya :: atom()}).

create(empty) ->
    #person{};
create(any) ->
    #person{name = "Joe Dow", phone = 3535}.

read(#person{name = Name} = Psn) ->
    {Name, Psn#person.phone, Psn#person.office}.

update(Psn, _, _) when is_record(Psn,person),
		       Psn == #person{name = undefined} ->
    Psn#person{name = defined};
update(Psn, Phone, Office) ->
    Psn#person{phone = Phone, office = Office}.

%Example: https://github.com/2600hz/kazoo/blob/91ca9c277aa0af6019b210e1d7124736fe4ec068/applications/callflow/src/module/cf_temporal_route.hrl
