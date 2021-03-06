#!/bin/sh 
test_local_variables(){
  foo="bar"

  assertEquals "bar" $foo
}

test_get_the_first_arg(){
  assertEquals "foo bar" "`./args.sh -f "foo bar" baz`"
}

test_get_the_args_count(){
  assertEquals 2 "`./args.sh -c "foo bar" baz`"
}

test_get_all_args(){
  assertEquals "-a foo bar baz" "`./args.sh -a "foo bar" baz`"
}

test_get_arg_dynamically(){
  assertEquals "baz" "`./args.sh 2 "foo bar" baz`"
}

test_get_script_name(){
  assertEquals "./args.sh" "`./args.sh -n`"
}

test_get_exit_status(){
  assertEquals 0 "`./args.sh -s`"
}

test_get_hostname(){
  assertTrue '[ $HOSTNAME ]'
}

test_get_username(){
  assertTrue '[ $USER ]'
}

test_get_random_number(){
  assertTrue '[ $RANDOM != $RANDOM ]'
}

test_process_id(){
  assertTrue '[ $$ ]'
}

test_enclose_content_with_quotes(){
  foo="foo bar"
  fuzz='fuzz buzz'

  assertEquals "foo bar" "$foo"
  assertEquals "fuzz buzz" "$fuzz"
}

test_single_quote_treat_all_as_literal(){
  foo="bar"

  actual='$foo'

  assertEquals "\$foo" $actual
}

test_double_quote_can_do_substitution(){
  foo="bar"

  actual="$foo"

  assertEquals $foo $actual
}


test_command_substitution(){
  words_count=$(echo hello world | wc --words)

  assertEquals 2 $words_count
}

test_export_variables(){
  key="bar"
  assertEquals "bar" $key

  source ./args.sh -e key value
  assertEquals "value" "$key"
}

test_assign_local_variable_after_will_does_not_change_the_global_variables(){
  global="GLOBAL"
  scoped="SCOPED"

  change(){
    local global=""
    scoped="LOCAL"
    global="LOCAL"
  }

  change

  assertEquals "GLOBAL" $global
  assertEquals "LOCAL" $scoped
}

test_eval_function_will_does_not_change_the_global_variables(){
  global="GLOBAL"
  scoped="SCOPED"

  change(){
    local global=""
    scoped="LOCAL"
    global="LOCAL"
    echo $global
  }

  local=$(change) 

  assertEquals "LOCAL" $local
  assertEquals "GLOBAL" $global
  assertEquals "SCOPED" $scoped
}

test_append_value_to_parameters(){
  set -- 12345
  assertEquals '12345' $@
  assertEquals '1' $#

  set -- 1 2 3 4 5
  assertEquals '1' "$@"
  assertEquals '1' $1
  assertEquals '2' $2
  assertEquals '5' $5
  assertEquals 5 $#
}



source ../$shunit2/src/shell/shunit2
