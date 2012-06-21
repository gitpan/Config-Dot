# Pragmas.
use strict;
use warnings;

# Modules.
use Config::Dot;
use English qw(-no_match_vars);
use Test::More 'tests' => 5;

# Test.
my $c = Config::Dot->new;
my $ret = $c->parse(<<'END');

# comment
=value
key=value
END
is_deeply(
	$ret, 
	{
		'key' => 'value',
	},
	'Parse simple key, value pair.',
);

# Test.
$c->reset;
$ret = $c->parse(['key1=value1', 'key2=value2']);
is_deeply(
	$ret,
	{
		'key1' => 'value1',
		'key2' => 'value2',
	},
	'Parse key, value pairs from array reference.',
);

# Test.
$c->reset;
eval {
	$c->parse(';=');
};
is($EVAL_ERROR, "Bad key ';' in string ';=' at line '1'.\n",
	'Bad key.');

# Test.
$c->reset;
my $conflict = <<'END';
key=value
key=value
END
eval {
	$c->parse($conflict);
};
is($EVAL_ERROR, "Conflict in 'key'.\n",
	'Conflict in key \'key\', \'set_conflict\' = 1.');

# Test.
$c = Config::Dot->new(
	'set_conflicts' => 0,
);
is_deeply(
	$c->parse($conflict),
	{
		'key' => 'value',
	},
	'Conflict in key \'key\', \'set_conflict\' = 0.',
);

