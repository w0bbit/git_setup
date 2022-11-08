#!/usr/bin/env perl

use v5.36;
use File::Path qw(rmtree);

=pod
This script automates all the stuff I do associated with `git clone`.
Include the SSH address of a github repo as a command-line argument for the script.
e.g.: ./git_setup.pl git@github.com:organization/repo-name.git
=cut

sub main {

  my $git_address = $ARGV[0] or die 'Git address not found';

  # Creates local clone of git repository
  system("git clone $git_address");

  # Parses out the repo name
  my ($repo_name) = $git_address =~ /.*\/(.+)\.git$/ or die 'Repo name not found';
  
  # Removes the auto generated .git file
  rmtree("$repo_name/.git");

  # Creates a local .git file, setting local branch as main
  system("git -C $repo_name init -b main");

  # Creates private github repo and sets local dir as source
  system("gh repo create $repo_name --source=./$repo_name --private");

  # Stages all local files in the repo
  system("git -C $repo_name add .");

  # Commits all local files
  system("git -C $repo_name commit -m 'initial commit'");

  # Sets local repo as origin and pushes all local files to github 
  system("git -C $repo_name push --set-upstream origin main");
 
}

main()