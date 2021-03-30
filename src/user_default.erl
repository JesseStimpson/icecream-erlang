-module(user_default).

-export([ic_io/1]).

-include_lib("icecream/include/ic.hrl").

ic_io(X) ->
    ?ic(X).
