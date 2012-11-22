# Gem Version Checker

Check gem dependencies of ruby apps and generate report.

At XING we use this gem in combination with jenkins to automatically check on gem versions across our many projects.

## Installation

    gem install gem_version_check

## Usage

Use the Github project name:

    gem_version_check fdietz/team_dashboard

Use any url to a Gemfile.lock:

    gem_version_check https://raw.github.com/fdietz/team_dashboard/raw/master/Gemfile.lock

## Configuration

Use --host option if you use Enterprise Github:

    gem_version_check fdietz/team_dashboard --host github.mycompany.com

Use --only option if you want to specify the list of gems

    gem_version_check fdietz/team_dashboard --only activesupport,rspec

Use --output-format if you want different formats

    gem_version_check fdietz/team_dashboard --output-format=json

## Example Report

### Pretty Print

Example command: gem_version_check fdietz/team_dashboard --only activesupport,rspec

Output:

    Project: fdietz/team_dashboard
     * activesupport:  != 3.2.8
     * rspec:  != 2.11.0

