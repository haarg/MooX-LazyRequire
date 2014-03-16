use strictures 1;
use Test::More;
use Test::Fatal;

{
  package MooLazyRequire;
  use Moo;
  use MooX::LazyRequire;

  has one => (is => 'rw');
  has two => (is => 'rw', lazy_required => 1);
}

{
  package MooLazyRequireRole;
  use Moo::Role;
  use MooX::LazyRequire;

  has one => (is => 'rw');
  has two => (is => 'rw', lazy_required => 1);
}

{
  package MooLazyRequireFromRole;
  use Moo;
  with 'MooLazyRequireRole';
}

if (!caller) {
  test_object(MooLazyRequire->new);
  test_object(MooLazyRequireFromRole->new);
  done_testing;
}

sub test_object {
  my $o = shift;
  is exception {
    $o->one;
  }, undef, "LazyRequire doesn't apply unless specified";

  like exception {
    $o->two;
  }, qr/must be provided before calling reader/, "accessor fails if not provided a value";

  is exception {
    $o->two(1);
    $o->two;
  }, undef, "accessor works if provided a value";
}
