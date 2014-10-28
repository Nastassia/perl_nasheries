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
    # template 'index', {\@nasheries}
    # return \@nasheries; << THIS WORKS >>
    # template 'index', {nashery=>$psql->fetchrow_hashref};
    # while (@nasheries = $psql->fetchrow_array){
    #   @show_nasheries = @nasheries;
    # }
          # my @nasheries = ();
          # #
          # while (@nasheries = $psql->fetchrow_array){
          #
          #   push @nasheries, $_;
          # } THIS DOESN'T WORK DUE TO SCOPE.
          # return \@nasheries;

    # template 'index', {nasheries => $nasheries};
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
# true;
