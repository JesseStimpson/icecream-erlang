-ifdef(IC).
-define(ic(X), begin
                   M__ = ?MODULE,
                   L__ = ?LINE,
                   F__ = ?FUNCTION_NAME,
                   A__ = ?FUNCTION_ARITY,
                   X__ = ??X,
                   R__ = ((X)),
                   icecream:expr(M__, L__, F__, A__, X__, R__),
                   R__
               end).
-else.
-define(ic(X), ((X)) ).
-endif.
