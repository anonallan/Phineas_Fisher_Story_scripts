#!/usr/bin/perl
use strict;
use warnings;
use File::Path qw(make_path);
use File::Basename;
use Cwd 'abs_path';

print qq{
    Downloader v0.1 - Automatic file handler demo
    Translated to Perl for study purposes
};

# Check arguments
if (@ARGV < 4) {
    print qq{
    Incorrect parameters:

    ./downloader.pl [COMMAND ARGS] [output-folder] [root-path] [first-file]

    Example:
    ./downloader.pl "-u http://server/test" prueba "/var/www/web" "/var/www/web/index.php"
    };
    exit;
}

my ($cmd_args, $dirw, $droot, $files_str) = @ARGV;
my @files = split(/\s+/, $files_str);

sub download_file {
    my ($f) = @_;

    # Example of running external command
    my $cmd = "echo Simulating external tool with $cmd_args --file-read=$f";
    my $ret = `$cmd`;
    my $status = $? >> 8;

    # Regex example (dummy pattern)
    if ($ret =~ /Simulating.*file-read=(.*)/) {
        my $found = $1;

        my ($p, $a) = fileparse($f);
        my $dest = "output/$dirw/$a";

        # Simulate moving file
        print "[+] Would move $found to $dest\n";
        return $dest;
    }
    return;
}

print "[*] Starting download\n";

# Ensure directories exist
unless (-d "output") {
    make_path("output");
    print "[+] Directory /output created\n";
}
unless (-d "output/$dirw") {
    make_path("output/$dirw");
    print "[+] Directory /output/$dirw created\n";
}

while (@files) {
    my $nf = download_file(pop @files);
    if ($nf) {
        # File reading example
        if (open my $fh, '<', $nf) {
            my $fc = do { local $/; <$fh> };
            close $fh;

            # Regex to find linked files (dummy pattern)
            while ($fc =~ /(href=['"]([^'"]+\.php))/g) {
                my $i = $2;
                my $dr = abs_path(dirname($nf)) . "/$i";
                my $dn = "$droot/" . dirname($nf) . "/$i";

                unless (-f $dr) {
                    push @files, $dn;
                    my $df = dirname($i);
                    if ($df) {
                        make_path(dirname($dr));
                    }
                    print "[-] Added $dn to queue...\n";
                }
            }
        } else {
            print "[*] Error: cannot open file $nf\n";
        }
    }
}

print "[*] Finished processing in /output/$dirw\n";

