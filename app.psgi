use strict;
use warnings;

use lib './lib';

use Hastu;

my $app = Hastu->apply_default_middlewares(Hastu->psgi_app);
$app;

