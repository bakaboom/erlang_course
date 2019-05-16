%%%-------------------------------------------------------------------
%%% @author  <ishinkar@N103804>
%%% @copyright (C) 2019, 
%%% @doc
%%%
%%% @end
%%% Created : 16 May 2019 by  <ishinkar@N103804>
%%%-------------------------------------------------------------------
-module(session_handler_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%%===================================================================
%%% API functions
%%%===================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%%===================================================================
%%% Supervisor callbacks
%%%===================================================================

-spec init(Args :: term()) ->
		  {ok, {SupFlags :: supervisor:sup_flags(),
			[ChildSpec :: supervisor:child_spec()]}} |
		  ignore.
init([]) ->

    SupFlags = #{strategy => simple_one_for_one,
		 intensity => 1,
		 period => 5},

    Child = #{id => session_handler,
	      start => {session_handler, start_link, []},
	      restart => transient,
	      shutdown => 3000,
	      type => worker},

    {ok, {SupFlags, [Child]}}.
