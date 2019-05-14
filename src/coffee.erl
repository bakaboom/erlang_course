%%%-------------------------------------------------------------------
%%% @author  <ishinkar@N103804>
%%% @copyright (C) 2019, 
%%% @doc
%%%
%%% @end
%%% Created : 14 May 2019 by  <ishinkar@N103804>
%%%-------------------------------------------------------------------
-module(coffee).

-behaviour(gen_statem).

%% API
-export([start/0, stop/0, tea/0, espresso/0, capuccino/0, americano/0, pay/1, cancel/0]).

%% gen_statem callbacks
-export([callback_mode/0, init/1, terminate/3, code_change/4, handle_common/3]).
-export([selection/3, payment/3, return_change/3, preparing_drink/3]).

-define(SERVER, ?MODULE).

-define(MENU, [{tea,100},
	       {espresso, 120},
	       {cappuccino, 150},
	       {americano, 150}]).

-record(data, {drink_type,
	       price,
	       paid = 0,
	       change,
	       client}).

%%%===================================================================
%%% API
%%%===================================================================
start() ->
    gen_statem:start({local, ?SERVER}, ?MODULE, [], []).

stop() ->
    gen_statem:stop(?SERVER).

tea() ->
    gen_statem:call(?SERVER, {select, tea}).

espresso() ->
    gen_statem:call(?SERVER, {select, espresso}).

capuccino() ->
    gen_statem:call(?SERVER, {select, capuccino}).

americano() ->
    gen_statem:call(?SERVER, {select, americano}).

pay(Coin) ->
    gen_statem:call(?SERVER, {pay, Coin}).

cancel() ->
    gen_statem:cast(?SERVER, cancel).


%%%===================================================================
%%% gen_statem callbacks
%%%===================================================================
callback_mode() -> state_functions.

init([]) ->
    {ok, selection, #data{}}.

selection(enter, _State, _Data) ->
    io:format("Make your choise"),
    keep_state_and_data;
selection({call,Caller}, {select, DrinkType}, Data) ->
    {DrinkType, Price} = lists:keyfind(DrinkType, 1, ?MENU),
    {next_state, payment, Data#data{drink_type = DrinkType, price = Price},
     {reply, Caller, please_pay(Price)}};
selection({call,Caller}, {pay, Coin}, Data) ->
    {next_state, return_change, Data#data{change = Coin, client = Caller}}.

payment({call,Caller}, {pay, Coin}, #data{price = Price, paid = Paid} = Data) when Coin+Paid < Price ->
    {keep_state, Data#data{paid = Coin+Paid}, {reply, Caller, please_pay(Price-Paid-Coin)}};
payment({call,Caller}, {pay, Coin}, #data{price = Price, paid = Paid} = Data) ->
    {next_state, return_change, Data#data{change = Coin+Paid-Price, client = Caller},
     {next_event, internal, make_return}}.

return_change(internal, make_return, Data) ->
    gen_statem:reply(Data#data.client, take_change(Data#data.change)),
    {next_state, preparing_drink, Data#data{change = 0}, {next_event, internal, make_drink}}.
%% return_change('enter', _State, Data) ->
%%     gen_statem:reply(Data#data.client, take_change(Data#data.change)),
%%     {next_state, selection, Data#data{change = 0}}.

preparing_drink(internal, make_drink, Data) ->
    io:format("Preparing ~p... ~n", [Data#data.drink_type]),
    timer:sleep(3000),
    io:format("Take your ~p... ~n", [Data#data.drink_type]),
    {next_state, selection, #data{}}.

handle_common(cast, cancel, Data) ->
    {next_state, return_change, Data}.


%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_statem when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_statem terminates with
%% Reason. The return value is ignored.
%% @end
%%--------------------------------------------------------------------
-spec terminate(Reason :: term(), State :: term(), Data :: term()) ->
		       any().
terminate(_Reason, _State, _Data) ->
    void.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Convert process state when code is changed
%% @end
%%--------------------------------------------------------------------
-spec code_change(
	OldVsn :: term() | {down,term()},
	State :: term(), Data :: term(), Extra :: term()) ->
			 {ok, NewState :: term(), NewData :: term()} |
			 (Reason :: term()).
code_change(_OldVsn, State, Data, _Extra) ->
    {ok, State, Data}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
please_pay(Price) ->
    "Please pay "++integer_to_list(Price)++" coins".

take_change(Change) ->
    "Please take your change "++integer_to_list(Change)++" coins".
