%%%-------------------------------------------------------------------
%% @doc session top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(session_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: #{id => Id, start => {M, F, A}}
%% Optional keys are restart, shutdown, type, modules.
%% Before OTP 18 tuples must be used to specify a child. e.g.
%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
-spec init(Args :: term()) ->
		  {ok, {SupFlags :: supervisor:sup_flags(),
			[ChildSpec :: supervisor:child_spec()]}} |
		  ignore.
init([]) ->
    SupFlags = #{strategy => rest_for_one, % one_for_one | one_for_all | rest_for_one | simple_one_for_one
		 intensity => 2,           % Max number of restarts in the last 'period' seconds
		 period => 10},            % Restart interval

    ChildSpecs = [#{id => session_server,               % any term
		    start => {session, start_link, []}, % {M,F,A}
		    restart => permanent,               % permanent | transient | temporary
		    shutdown => 3000,                   % milliseconds | infinity | brutall_kill
		    type => worker,                     % worker | supervisor
		    modules => [session]},              % process - module references

		  #{id => session_handler_sup,
		    start => {session_handler_sup, start_link, []},
		    type => supervisor}
		 ],
    {ok, {SupFlags, ChildSpecs}}.
