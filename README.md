# ORT for GitHub Action

## Usage

Please check the [action.yml](action.yml) for the parameters in greater detail.

```yaml
- uses: oss-review-toolkit/ort-ci-github-action@main
  with:
    # Container image to run ORT.
    image: 'ghcr.io/alliander-opensource/ort-container:latest'

    # Name of the repository.
    sw-name: 'my-awesome-project'

    # Comma separated list of ORT tools to run.
    run: 'advisor,downloader,evaluator'

    # Comma separated list of types of ORT reports to generate.
    report-formats: 'CycloneDx,EvaluatedModel,GitLabLicenseModel,NoticeTemplate,SpdxDocument,StaticHtml,WebApp'

    # List of package managers to be used when analyzing the project.
    package-managers: 'npm,pip'

```

### Usage in a workflow

Examples of how to use this step in a workflow.

```yaml
jobs:
  ort:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Checkout central ORT config of the organisation
        uses: actions/checkout@v3
        with:
          repository: my-organisation/ort-config
          path: '.ort/config'
          fetch-depth: 1
      - uses: oss-review-toolkit/ort-ci-github-action@main
        with:
          sw-name: 'My Project'
```

### Scanning multiple repositories

There are many ways to scan multiple repositories.
One option is to scan them from a single GitHub repository using a matrix.
This can work well for a smaller amount of repositories to scan.

```yaml
jobs:
  ort:
    strategy:
      matrix:
        include:
          - repository: myorg/alpha
            sw-name: alpha
          - repository: myorg/beta
            sw-name: beta
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          repository: ${{ matrix.repository }}
      - uses: oss-review-toolkit/ort-ci-github-action@main
        with:
          sw-name: ${{ matrix.sw-name }}
```

## Development

### Pre-commit hooks

Commit hooks are provided using the [pre-commit framework](https://pre-commit.com/).
Example of setting it up:

```shell
$ pipx install pre-commit
$ pre-commit install-hooks
```

After installation you can also trigger it manually running `pre-commit run --all-files`

# License

Copyright (C) 2020-2022 [The ORT Project Authors](./NOTICE).

See the [LICENSE](./LICENSE) file in the root of this project for license details.

OSS Review Toolkit (ORT) is a [Linux Foundation project](https://www.linuxfoundation.org) and part of [ACT](https://automatecompliance.org/).
