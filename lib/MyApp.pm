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
    my $sql = "select * from nasheries";
    my $psql = database->prepare($sql);
    $psql->execute();
    my @nasheries = $psql->fetchall_arrayref({});
    template 'index', {nasheries => \@nasheries };

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
  my $title = param "title";
  my $poem = param "nashed";
  database->quick_insert('nasheries', {title => $title, poem => $poem});
  redirect '/';
  # return "<h2>". $poem . "</h2>"
};

get '/nashery/:id' => sub {
  my $nashery = database->quick_select('nasheries', {id => param "id"});
  template 'nashed', {nashery => $nashery};
};

post '/nashery/:id' => sub {
  my $title = param "title";
  my $poem = param "poem";
  database->quick_update('nasheries', {id => param "id"}, {title => $title, poem => $poem});
  redirect '/';
};
true;
