use strict;
use warnings;

use Hastu;

my $app = Hastu->apply_default_middlewares(Hastu->psgi_app);
$app;

