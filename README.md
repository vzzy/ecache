ecache
=====

An OTP application

Build
-----

	$ rebar3 compile
	$ erl -pa _build/default/lib/*/ebin -pa _build/default/lib/*/priv -s ecache
	> ecache:put(<<"a">>,1).
	> ecache:get(<<"a">>).
	> ecache:getDef(<<"b">>,99).
	> ecache:delete(<<"b">>).
	
    