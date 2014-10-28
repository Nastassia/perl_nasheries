package MyApp;
use Dancer2;
use File::Slurp;
use Dancer2::Plugin::Database;
# use Dancer ':syntax';
use Dancer::Plugin::Ajax;
set serializer => 'JSON';
set plugins => { Database => { driver => "Pg", database => "nashery"}};
# set template => 'template_toolkit';

our $VERSION = '0.1';

get '/' => sub {
    my $t = engine 'template';
    my $sql = "select * from nasheries";
    my $psql = database->prepare($sql);
    $psql->execute();
    # my @nasheries = database->fetchall_arrayref({});

    # template 'index', {nashery=>$psql->fetchrow_hashref};
    my @nasheries => $psql->fetchall_arrayref({});
    template 'index', {nasheries => @nasheries};
    # template 'index', { nasheries => $psql };
};

get '/hello/:name' => sub {
  return "Hello ".param('name');
};

get '/nashery' => sub {
  template 'nashery';
  # my $nashed = read_file('./ogden.txt');
  # $nashed;
};

post '/nashed' => sub {
  my $poem = param "nashed";
  database->quick_insert('nasheries', {poem => $poem});
  # return "<h2>". $poem . "</h2>"
};
true;
