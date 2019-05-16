%%%-------------------------------------------------------------------
%%% @author  <ishinkar@N103804>
%%% @copyright (C) 2019, 
%%% @doc
%%%
%%% @end
%%% Created : 16 May 2019 by  <ishinkar@N103804>
%%%-------------------------------------------------------------------
-module(session).

-behaviour(gen_server).

%% API
-export([start_link/0, stop/0, start_handlers/1, stop_handler/2, ping/1]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2]).

-define(SERVER, ?MODULE).
-define(HANDLER_SUP, session_handler_sup).

%%%===================================================================
%%% API
%%%===================================================================
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

stop() ->
    gen_server:cast(?SERVER, stop).

start_handlers(SessionIdList) ->
    gen_server:cast(?SERVER, {start_handlers,SessionIdList}).

-spec stop_handler(term(), 'normal'|'abnormal'|'shutdown') -> ok.
stop_handler(SessionId, Reason) -> 
    gen_server:cast(?SERVER, {stop_handler, SessionId, Reason}).

ping(SessionId) ->
    gen_server:call(?SERVER, {ping,SessionId}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================
init([]) ->
    {ok, dict:new()}.

handle_call({ping,Id}, _From, State) ->
    Pid = dict:fetch(Id, State),
    Pid ! {Id,self(),ping},
    receive
	{Id,Pid,Reply} ->
	    ok
    end,
    {reply, Reply, State}.

handle_cast(stop, State) ->
    {stop, abnormal, State};

handle_cast({start_handlers,IdList}, State) ->
    NewState = start_handlers(IdList,State),
    {noreply, NewState};
handle_cast({stop_handler, Id, Reason}, State) ->
    Pid = dict:fetch(Id, State),
    NewState = case Reason of
		   normal ->
		       Pid ! normal,
		       dict:erase(Id,State);
		   abnormal ->
		       Pid ! abnormal,
		       State;
		   shutdown ->
		       ok = supervisor:terminate_child(?HANDLER_SUP, Pid),
		       dict:erase(Id,State)
	       end,
    {noreply, NewState}.

handle_info(_Info, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any
%% necessary cleaning up. When it returns, the gen_server terminates
%% with Reason. The return value is ignored.
%% @end
%%--------------------------------------------------------------------
-spec terminate(Reason :: normal | shutdown | {shutdown, term()} | term(),
		State :: term()) -> any().
terminate(Reason, _State) ->
    io:format("Session server is terminated with ~p reason.~n", [Reason]).

%%%===================================================================
%%% Internal functions
%%%===================================================================
start_handlers([],Dict) ->
    Dict;
start_handlers([Id|T],Dict) ->
    {ok,Pid} = supervisor:start_child(?HANDLER_SUP,[Id]),
    start_handlers(T, dict:store(Id,Pid,Dict)).
