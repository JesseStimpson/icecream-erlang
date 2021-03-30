%%%-------------------------------------------------------------------
%% @doc icecream public API
%% @end
%%%-------------------------------------------------------------------

-module(icecream_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    icecream_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
