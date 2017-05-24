# Input: Pass 3 args, mode, initials, score.
# Output: updates the file scores.txt
# We have one text file with 9 scores in it.
# one line per difficulty, easy, mod, then hard, e.g.
# dpf,10;rps,8;ttw,8

my $filename = "scores.txt";
open (my $FH, '<', $filename)
    or die "Failed: [Does $filename exist?]\n $!";
chomp(my @LINES = <$FH>);	# SLURP
close $FH;

sub UpdateScores {
    my ($mode, $NewLine) = @_;
    my $OUTPUT;
    if ($mode eq 'easy') {
	$OUTPUT = $NewLine."\n".$LINES[1]."\n".$LINES[2]."\n";
    } elsif ($mode eq 'mod') {
	$OUTPUT = $LINES[0]."\n".$NewLine."\n".$LINES[2]."\n";
    } elsif ($mode eq 'hard') {
	$OUTPUT = $LINES[0]."\n".$LINES[1]."\n".$NewLine."\n";
    }
    print "\t scores.txt will now say:\n";
    print $OUTPUT, "\n";
    
    open (my $FILE, '>', $filename);
    print $FILE $OUTPUT;
    close $FILE;
}
sub HighScore {
    my ($mode, $nick, $NewScore) = @_;
    my (@nick, @PrvScore, @name_score_chunk);

    # Get names/scores on the right line.
    if ($mode eq 'easy') {
	@name_score_chunk = split /;/, $LINES[0];
    } elsif ($mode eq 'mod') {
	@name_score_chunk = split /;/, $LINES[1];
    } elsif ($mode eq 'hard') {
	@name_score_chunk = split /;/, $LINES[2];
    }

    # print " These are the current records for $mode mode:\t";
    for my $j (0..$#name_score_chunk) {
	($nick[$j], $PrvScore[$j]) = split(',', $name_score_chunk[$j]);
	# print $nick[$j], ", ", $PrvScore[$j], "; ";
    }
    print "\n";

    my $NewLine = $nick.",".$NewScore.";";
    
    if ($NewScore > $PrvScore[0]) {
	print "\t\t You have beaten an old high score!\n";
	$NewLine = $NewLine.$name_score_chunk[0].";".$name_score_chunk[1];
	UpdateScores($mode, $NewLine);
    } elsif ($NewScore > $PrvScore[1]) {
	print "\t\t You have beaten an old high score!\n";
	$NewLine = $name_score_chunk[0].";".$NewLine.$name_score_chunk[1];
	UpdateScores($mode, $NewLine);
    } elsif ($NewScore > $PrvScore[2]) {
	print "\t\t You have beaten an old high score!\n";
	$NewLine = $name_score_chunk[0].";".$name_score_chunk[1].";".$NewLine;
	UpdateScores($mode, $NewLine);
    } else {
	print "\nSorry... that is not a high score.\n";
    }
}

my ($mode, $nick, $score);
if ( (scalar @ARGV) != 3 ) {
    ($mode, $nick, $score) = ('easy','---','0');
} else {
    ($mode, $nick, $score) = @ARGV;
}

# For formatting reasons, only accept first 3 chars,
# And demolish anything containing , or ;
$nick = substr($nick, 0, 3);
if (($nick =~ /,/) or ($nick =~ /;/)) {
    $nick = "   ";
}

print "\nEntering user: $nick in $mode mode with $score...\n\n";

HighScore(($mode, $nick, $score));

print "\n";
