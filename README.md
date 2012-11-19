# XING Gem Version Checker

Check gem dependencies of rails apps and generate report. It is executed automatically on jenkins:

[https://jenkins.dc.xing.com/jenkins/view/gems/job/gem_version_check/](https://jenkins.dc.xing.com/jenkins/view/gems/job/gem_version_check/)

Here is the last builds output:

[https://jenkins.dc.xing.com/jenkins/view/gems/job/gem_version_check/lastBuild/console](https://jenkins.dc.xing.com/jenkins/view/gems/job/gem_version_check/lastBuild/console)

## Installation

    gem install gem_version_check

## Usage

Commandline Usage

    gem_version_check

## Configuration

### Projects

Projects are listed in `projects.json`:

    {
      "projects": [
        { "name": "Jobs", "repository": "jobs-team/jobs" },
        { "name": "Events", "repository": "events-team/events" },
        { "name": "Companies", "repository": "companies/companies" }
      ]
    }

### Version Checks

Checks are listed in `checks.json`:

    {
      "rails_core_tools": "2.7.4",
      "rails_templates": "3.2.0",
      "rest_cake": "0.8.15",
      "rails": "3.2.9"
    }

## Example Report

### Pretty Print
puts GemVersionCheck::PrettyPrintReport.new(report)

    Project: Jobs
     * rails_core_tools: 2.7.4 ✓
     * rails_templates: 3.2.0 ✓
     * rest_cake: 0.8.15 ✓
     * rails: 3.2.9 != 3.2.8
     * logjam_agent: 0.5.9 ✓
     * legacy_perl_backend: 1.1.0 != 1.1.4
     * omniture_tracking: 0.1.9 ✓
     * passenger: 3.0.11 ✓
     * text_resources: 0.2.16 != 0.2.15
     * xing_urn: 0.1.4 ✓

    Project: Events
     * rails_core_tools: 2.7.4 != 2.6.2
     * rails_templates: 3.2.0 != 3.1.1
     * rest_cake: 0.8.15 ✓
     * rails: 3.2.9 ✓
     * logjam_agent: 0.5.9 != 0.5.7
     * legacy_perl_backend: 1.1.0 != 1.1.3
     * omniture_tracking: 0.1.9 != 0.1.7
     * passenger: 3.0.11 ✓
     * text_resources: 0.2.16 != 0.1.3
     * xing_urn: 0.1.4 ✓

### JSON Format
puts GemVersionCheck::JSONReport.new(report).to_json

    [
        {
            "name": "Jobs",
            "dependencies": [
                {
                    "name": "rails_core_tools",
                    "expected_version": "2.7.4",
                    "version": "2.7.4",
                    "used": true,
                    "valid": true
                },
                {
                    "name": "rails_templates",
                    "expected_version": "3.2.0",
                    "version": "3.2.0",
                    "used": true,
                    "valid": true
                },
                {
                    "name": "rest_cake",
                    "expected_version": "0.8.15",
                    "version": "0.8.15",
                    "used": true,
                    "valid": true
                },
                {
                    "name": "rails",
                    "expected_version": "3.2.9",
                    "version": "3.2.8",
                    "used": true,
                    "valid": false
                },
                {
                    "name": "logjam_agent",
                    "expected_version": "0.5.9",
                    "version": "0.5.9",
                    "used": true,
                    "valid": true
                },
                {
                    "name": "legacy_perl_backend",
                    "expected_version": "1.1.0",
                    "version": "1.1.4",
                    "used": true,
                    "valid": false
                },
                {
                    "name": "omniture_tracking",
                    "expected_version": "0.1.9",
                    "version": "0.1.9",
                    "used": true,
                    "valid": true
                },
                {
                    "name": "passenger",
                    "expected_version": "3.0.11",
                    "version": "3.0.11",
                    "used": true,
                    "valid": true
                },
                {
                    "name": "text_resources",
                    "expected_version": "0.2.16",
                    "version": "0.2.15",
                    "used": true,
                    "valid": false
                },
                {
                    "name": "xing_urn",
                    "expected_version": "0.1.4",
                    "version": "0.1.4",
                    "used": true,
                    "valid": true
                }
            ]
        }
      ]
