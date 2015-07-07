#!/usr/bin/env bash
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a,S[a]}'|awk "/$1/
{pirnt $2}"|awk '{print $NF}'
