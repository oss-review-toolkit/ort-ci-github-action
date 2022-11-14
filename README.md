# ORT for GitHub Action

## Usage

```yaml
- uses: oss-review-toolkit/ort-ci-github-action@main
  with:
    # Container image to run ORT.
    image: 'ghcr.io/alliander-opensource/ort-container:latest'

    # Name of the repository.
    sw-name: 'my-awesome-project'

    # Comma separated list of ORT tools to run.
    run: 'advisor,downloader,evaluator'

    # Name of ORT configuration dir.
    config-dir: 'ort-config'

    # Path to repository configuration file.
    config-file: '.ort.yml'

    # Path to general ORT configuration file.
    cli-config-file: 'conf.yml'

    # Path to a general ORT configuration file.
    cli-config-template: './templates/ort.conf.tmpl'

    # Reasons to fail with an non-zero exit code.
    fail-on: 'issue, violations, advisories, outdat-notice-file'

    # Connection to PostgreSQL storage backend.
    db-url: ''
    db-username: ${{ secrets.DB_USER }}
    db-password: ${{ secrets.DB_PASSWORD }}

    # If 'true', a file archive with the sources for project and/or its
    # dependencies is created. Used for license compliance and data
    # retention/business continuity
    create-source-code-bundle: false

    # Path to open source attribution document.
    notice-file-name: 'NOTICE'

    # Set to 'true' only if dynamic dependency versions are allowed (note
    # version ranges specified for dependencies may cause unstable results).
    # Applies only to package managers that support lock files, e.g. NPM
    allow-dynamic-versions: false

    # Log level: 'debug' to see additional debug output to help tracking down
    # errors. 'performance' for less logs. 'info' as default.
    log-level: 'info'

    # Extra JVM environment options when running ORT
    opts: ''

    # Comma separated list of types of ORT reports to generate.
    report-formats: 'CycloneDx,EvaluatedModel,GitLabLicenseModel,NoticeTemplate,SpdxDocument,StaticHtml,WebApp'

    # List of package managers to be used when analyzing the project.
    package-managers: 'npm,pip'

```

### Usage in a workflow

Examples of how to use this step in a workflow.

```yaml
job:
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
