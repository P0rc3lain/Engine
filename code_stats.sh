#!/usr/bin/env bash
cloc . --exclude-lang=JSON,XML,YAML --force-lang="C++",metal
