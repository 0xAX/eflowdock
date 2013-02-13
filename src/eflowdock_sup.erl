-module(eflowdock_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_flowdock_client/5]).

%% Supervisor callbacks
-export([init/1]).


%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).
    
%% @doc Start new flowdock client
%% @end
-spec start_flowdock_client(CallbackModule :: atom() | pid(), 
                            FlowDockOrg :: binary(), 
                            Flow :: binary(), 
                            Login :: binary(), 
                            Password :: binary())
                       -> {ok, Pid :: pid()} | {error, Reason :: term()}.
start_flowdock_client(CallbackModule, FlowDockOrg, Flow, Login, Password) ->
    % run new flowdock client
    supervisor:start_child(?MODULE, [CallbackModule, FlowDockOrg, Flow, Login, Password]).

init([]) ->
    % flowdock client
    ChildSpec = [

        % start flowdock client
        {eflowdock_client, 
            {eflowdock_client, start_link, []},
             temporary, 2000, worker, []
        }
    ],

    % init
    {ok,{{simple_one_for_one, 10, 60}, ChildSpec}}.
