#!/usr/bin/perl -w
# This script can be used to list the ENV variable 'path' on Windows

print join "\n", split(';', `path`);
