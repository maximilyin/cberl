REBAR=`which rebar`
DIALYZER=dialyzer

all: get-deps compile

get-deps:
	@$(REBAR) get-deps

compile:
	@$(REBAR) compile

clean:
	@$(REBAR) clean

eunit:
	@$(REBAR) skip_deps=true eunit

ct:
	@$(REBAR) skip_deps=true ct

tests: eunit ct

rel: deps compile
	@$(REBAR) generate

relclean:
	@rm -rf rel/cberl

build-plt:
	@$(DIALYZER) --build_plt --output_plt .cberl_dialyzer.plt \
		--apps kernel stdlib sasl

dialyze:
	@$(DIALYZER) --src src --plt .cberl_dialyzer.plt -Werror_handling \
		-Wrace_conditions -Wunmatched_returns # -Wunderspecs

docs:
	@$(REBAR) skip_deps=true doc
