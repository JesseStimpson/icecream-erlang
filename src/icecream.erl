-module(icecream).

-export([enable/0, disable/0, configure_output/1, expr/6]).
-define(IC_CONFIG, [
                    prefix,
                    include_context,
                    arg_to_string_function,
                    output_function
                   ]).
-define(IC_PREFIX, "ic| ").

enable() ->
    application:set_env(icecream, mode, enabled).

disable() ->
    application:set_env(icecream, mode, disabled).

configure_output(Map) ->
    Map2 = maps:with(?IC_CONFIG, Map),
    lists:foreach(
      fun({EnvK, EnvV}) ->
              application:set_env(icecream, EnvK, EnvV)
      end, maps:to_list(Map2)).

expr(Module, Line, FunctionName, FunctionArity, Expr, Arg) ->
    case application:get_env(icecream, mode, enabled) of
        disabled ->
            ok;
        enabled ->
            Prefix = application:get_env(icecream, prefix, ?IC_PREFIX),
            PrefixV = if is_function(Prefix) -> Prefix(); true -> Prefix end,

            IncludeContext = application:get_env(icecream, include_context, false),
            ArgToStringFun = application:get_env(icecream, arg_to_string_function, fun arg_to_string/1),
            OutputFun = application:get_env(icecream, output_function, fun output/1),

            ArgS = ArgToStringFun(Arg),
            OutS = out_string(IncludeContext, PrefixV, Module, Line, FunctionName, FunctionArity, Expr, ArgS),
            OutputFun(OutS)
    end.

arg_to_string(Arg) ->
    iolist_to_binary(io_lib:format("~p", [Arg])).

out_string(true, Prefix, Module, Line, FunctionName, FunctionArity, Expr, Arg) ->
    io_lib:format("~s~p:~p in ~p/~p- ~s: ~s",
              [Prefix, Module, Line, FunctionName, FunctionArity, Expr, Arg]);
out_string(false, Prefix, _Module, _Line, _FunctionName, _FunctionArity, Expr, Arg) ->
    io_lib:format("~s~s: ~s",
              [Prefix, Expr, Arg]).

output(Out) ->
    io:format("~s~n", [Out]).
