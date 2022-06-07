<!--
SPDX-FileCopyrightText: 2022 Josef Andersson

SPDX-License-Identifier: CC0-1.0
-->

# ORT CI Action

A GitHub Action or a template for helping you using the powerful [ORT (OSS Review Toolkit)](https://github.com/oss-review-toolkit/ort) to Analyse, Scan, Evaluate and Advise your code with ORT, with quite a lot of configuration options.

As an SBOM (Software-Bill-Of-Materials)-generator it might just work for you right anyway, as ORT supports many package managers and output formats.

As a deep code license scanner, you might need to configure more powerful runners.

Related siblings projects are:

- [ORT CI Base](https://github.com/janderssonse/ort-ci-base) - Containts base logic (scripts etc.) for running ORT in CI
- [ORT CI GitLab](https://github.com/janderssonse/ort-ci-gitlab) - GitLab CI templates for running ORT in GitLab environments.
- [ORT CI Tekton] - To-Do


## Table of Contents

- [Usage](#usage)
- [Contributing](#contributing)
- [Maintainers](#maintainers)
- [License](#license)

## Usage


### Analyse and output reports with CI Action - SBOM and more

```yaml
name: ORT CI Action
on: [push]

jobs:
  ort_report_job:
    runs-on: ubuntu-latest
    name: Analyse with ORT

    steps:

      - name: Checkout
        uses: actions/checkout@v3
        with:
          path: project

      - name: ORT CI Action run
        id: ort-ci-action
        uses: YOUR_ORG/ort-ci-action@84fb404388a78fa8a2059470c6c38bec98c648f4
        with:
          ort_disable_scanner: true
          ort_disable_downloader: true
          ort_disable_evaluator: true
          ort_disable_advisor: false
          ort_cli_config_tmpl: "ort.conf.github.tmpl"
          ort_config_file: ''
          ort_log_level: info
          ort_opts: -Xmx5120m //this is roughly current free GitHub runners level
        
       
      - name: ort-action-artifacts
        uses: actions/upload-artifact@v3
        with:
            name: analysis
            path: ./project/ort-results
```

For further configuration options, see [the variables configuration doc](https://github.com/janderssonse/ort-ci-base/blob/main/docs/variables.adoc) or, the [action.yml](action.yml) itself.

In the given example we are using a few other actions:

* [`checkout`](https://github.com/actions/checkout) - will checkout the current repo and put in under '$GITHUB_WORKSPACE/project' (the default expected repo location if nothing else configured).


* [`upload-artifact`](https://github.com/actions/upload-artifact) - to make the analysed results become available after the CI pipeline has finished.

### Where can the results be found?

At the bottom of the workflow summary page, there is a dedicated section for artifacts. Here's a screenshot of something you might see:

<img src="https://user-images.githubusercontent.com/37870813/164996952-e1a6c353-fe52-4a43-a578-e9a9c3b1f861.png" width="700" height="300">

## Requirements

### Scenario: I want to scan my pipelines with the GitHub Action

Currently there is *no* official ORT Image (it will most likely be in the future).
So until that - clone this repo and build your own:

1) See the ort-ci-action/.github/workflows/ort-image-build.yml for how to build or just use as is.2) In action.yml: replace uses: docker://ghcr.io/janderssonse/ort-ci-action:latest to your builded image.

GitHub Actions does not support a private image here yet.

### Scenario: I want to scan my pipelines with a regular Actions workflow yaml, maybe with a private image

Currently there is no official ORT Image available (it will most likely be in the future).
So until that - build your own:

1) See the 'ort-ci-action/.github/workflows/ort-image-build.yml' for how to build or just use as is.

2) Have a look at the example in the 'ci-templates/ort-scan-flow.yml' and adjust it under your own workflow.

## Development

TO-DO

### Project linters

The project is using a few hygiene linters:

- [MegaLinter](https://megalinter.github.io/latest/) - for shell, markdown etc check.
- [Repolinter](https://github.com/todogroup/repolinter) - for overall repostructre.
- [commitlint](https://github.com/conventional-changelog/commitlint) - for conventional commit check.
- [REUSE Compliance Check](https://github.com/fsfe/reuse-action) - for reuse specification compliance.

Before commiting a PR, please have run with this linters to avoid red checks. If forking on GitHub, you can adjust them to work for fork in the .github/workflow-files.

## Contributing

ORT CI Action follows the [Contributor Covenant](http://contributor-covenant.org) Code of Conduct.  
Please also see the [Contributor Guide](docs/CONTRIBUTING.adoc)

## Maintainers

[Josef Andersson](https://github.com/janderssonse).

## License

The Action is using ORT to run it's actions, which is under Apache Licenses and:

Copyright (C) 2020-2022 HERE Europe B.V.

ORT CI Action itself is is under

[MIT](LICENSE)

See .reuse/dep5 and file headers for further information.
Most "scrap" files, textfiles etc are under CC0-1.0, essentially Public Domain.

## Credits

Thanks to the [ORT (OSS Review Toolkit) Project](https://github.com/oss-review-toolkit/ort), for developing such a powerful tool. It fills a void in SCA-toolspace.

## F.A.Q

* TO-DO

>>>>>>> c598bc2 (chore: initial commit)

