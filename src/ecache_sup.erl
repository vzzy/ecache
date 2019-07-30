%%%-------------------------------------------------------------------
%% @doc ecache top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(ecache_sup).

-behaviour(supervisor).

%% API
-export([
	start_link/0,
		
	gett/1,
	getDef/2,
	putt/2,
	delete/1
]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).
-record(ecache, {
	k = none,
	v = none			 
}).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
	ets:new(ecache,[named_table,{keypos,#ecache.k},public,set,{write_concurrency,true},{read_concurrency,true}]),
    {ok, { {one_for_all, 1000, 3600}, []} }.

%%====================================================================
%% Internal functions
%%====================================================================

%% 获取
%% 删除整个表
delete(K)->
	ets:delete(ecache,K).

%% 设置
putt(K,V)->
	ets:insert(ecache,[#ecache{
		k = K,
		v = V							 
	}]).
%% 获取
getDef(K,Def)->
	case gett(K) of
		{ok,V}->
			{ok,V};
		_->
			{ok,Def}
	end.
gett(K)->
	case catch ets:lookup(ecache,K) of
		[V]->
			{ok,V#ecache.v};
		_->
			{error,undefine}
	end.