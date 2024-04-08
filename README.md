# GitHub Action for ORT

Run licensing, security and best practices checks and generate reports/SBOMs using [ORT][ort].

## Usage

See [action.yml](action.yml)

### Basic

```yaml
jobs:
  ort:
    runs-on: ubuntu-latest
    steps:
      - name: Use HTTPS instead of SSH for Git cloning
        run: git config --global url.https://github.com/.insteadOf ssh://git@github.com/
      - name: Checkout project
        uses: actions/checkout@v3
      - name: Run GitHub Action for ORT
        uses: oss-review-toolkit/ort-ci-github-action@v1
```

Alternatively, you can also use ORT to download the project sources using Git, Git-repo, Mercurial or Subversion.

```yaml
jobs:
  ort:
    runs-on: ubuntu-latest
    steps:
      - name: Use HTTPS instead of SSH for Git cloning
        run: git config --global url.https://github.com/.insteadOf ssh://git@github.com/
      - name: Run GitHub Action for ORT
        uses: oss-review-toolkit/ort-ci-github-action@v1
        with:
          vcs-url: 'https://github.com/jshttp/mime-types.git'
```

### Scenarios

- [Run ORT and analyze only specified package managers](#Run-ORT-and-analyze-only-specified-package-managers)
- [Run ORT with labels](#Run-ORT-with-labels)
- [Run ORT and fail job on policy violations or security issues](#Run-ORT-and-fail-job-on-policy-violations-or-security-issues)
- [Run ORT on private repositories](#Run-ORT-on-private-repositories)
- [Run ORT on multiple repositories using a matrix](#Run-ORT-on-multiple-repositories-using-a-matrix)
- [Run ORT with a custom global configuration](#Run-ORT-with-a-custom-global-configuration)
- [Run ORT with a custom Docker image](#Run-ORT-with-a-custom-Docker-image)
- [Run ORT with PostgreSQL database](#Run-ORT-with-PostgreSQL-database)
- [Run only parts of the GitHub Action for ORT](#Run-only-parts-of-the-GitHub-Action-for-ORT)

#### Run ORT and analyze only specified package managers

```yaml
jobs:
  ort:
    runs-on: ubuntu-latest
    steps:
      - name: Use HTTPS instead of SSH for Git cloning
        run: git config --global url.https://github.com/.insteadOf ssh://git@github.com/
      - name: Checkout project
        uses: actions/checkout@v3
        with:
          repository: 'jshttp/mime-types'
      - name: Run GitHub Action for ORT
        uses: oss-review-toolkit/ort-ci-github-action@v1
        with:
          allow-dynamic-versions: 'true'
          ort-cli-args: '-P ort.analyzer.enabledPackageManagers=NPM,Yarn,Yarn2'
```

#### Run ORT with labels

Use labels to track scan related info or execute policy rules for specific product, delivery or organization.

```yaml
jobs:
  ort:
    runs-on: ubuntu-latest
    steps:
      - name: Use HTTPS instead of SSH for Git cloning
        run: git config --global url.https://github.com/.insteadOf ssh://git@github.com/
      - name: Checkout project
        uses: actions/checkout@v3
        with:
          repository: 'jshttp/mime-types'
      - name: Run GitHub Action for ORT
        uses: oss-review-toolkit/ort-ci-github-action@v1
        with:
          allow-dynamic-versions: 'true'
          ort-cli-analyze-args: >
            -l project=oss-project
            -l dist=external
            -l org=engineering-sdk-xyz-team-germany-berlin
```

### Run ORT and fail job on policy violations or security issues

Set `fail-on` to fail the action if:
- policy violations reported by Evaluator exceed the `severeRuleViolationThreshold` level.
- security issues reported by the Advisor exceed the `severeIssueThreshold` level.

By default `severeRuleViolationThreshold` and `severeIssueThreshold` are set to `WARNING` 
but you can change this to for example `ERROR` in your [config.yml][ort-config-yml].

```yaml
jobs:
  ort:
    runs-on: ubuntu-latest
    steps:
      - name: Use HTTPS instead of SSH for Git cloning
        run: git config --global url.https://github.com/.insteadOf ssh://git@github.com/
      - name: Checkout project
        uses: actions/checkout@v3
        with:
          repository: 'jshttp/mime-types'
      - name: Run GitHub Action for ORT
        uses: oss-review-toolkit/ort-ci-github-action@v1
        with:
          allow-dynamic-versions: 'true'
          fail-on: 'violations'
```

#### Run ORT on private repositories

To run ORT on private Git repositories, we recommend to:
- Set up an account with read-only access rights
- Use a .netrc file, SSH keys or [GitHub tokens][gh-tokens] for authentication.

```yaml
jobs:
  ort:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout project
        uses: actions/checkout@v3
        with:
          repository: 'jshttp/mime-types'
      - name: Add .netrc
        run: >
          default
          login ${{ secrets.NETRC_LOGIN }}
          password ${{ secrets.NETRC_PASSWORD }}" > ~/.netrc
      - name: Add SSH key
        run: |
          mkdir -p ~/.ssh
          echo "${{ secrets.SSH_KEY }}" > ~/.ssh/id_github
          echo "${{ secrets.SSH_PUBLIC_KEY }}" > ~/.ssh/id_github.pub
          chmod 600 ~/.ssh/id_github*
          cat >>~/.ssh/config <<END
          Host github.com
            HostName ssh.github.com
            User git
            Port 443
            IdentityFile ~/.ssh/id_github
            StrictHostKeyChecking no
          END
      - name: Run GitHub Action for ORT
        uses: oss-review-toolkit/ort-ci-github-action@v1
        with:
          allow-dynamic-versions: 'true'
```

```yaml
jobs:
  ort:
    runs-on: [self-hosted, linux]
    name: Run ORT

    steps:
      - name: Configure proxy server
        run: |
          https_proxy="http://proxy.example.com:3128/"
          http_proxy="http://proxy.example.com:3128/"
          printenv >> "$GITHUB_ENV"
      - name: Use HTTPS with personal token always for Git cloning
        run: |
          git config --global url."https://oauth2:${{ secrets.PERSONAL_TOKEN_1 }}@github.com/".insteadOf "ssh://git@github.com/"
          git config --global url."https://oauth2:${{ secrets.PERSONAL_TOKEN_2 }}@git.example.com/".insteadOf "ssh://git@git.example.com/"
          git config --global url."https://oauth2:${{ secrets.PERSONAL_TOKEN_2 }}@git.example.com/".insteadOf "https://git.example.com/"
      - name: Checkout project
        uses: actions/checkout@v3
        with:
          repository: 'example-org/alpha'
          ref: 'master'
          github-server-url: 'https://git.example.com'
          token: ${{ secrets.PERSONAL_TOKEN_2 }}
      - name: Run GitHub action for ORT
        uses: oss-review-toolkit/ort-ci-github-action@v1
        with:
          ort-config-repository: 'https://oauth2:${{ secrets.PERSONAL_TOKEN_2 }}@git.example.com/ort-project/ort-config.git'
          run: >
            cache-dependencies,
            metadata-labels,
            analyzer,
            advisor,
            reporter,
            upload-results
```

#### Run ORT on multiple repositories using a matrix

```yaml
jobs:
  ort:
    strategy:
      fail-fast: false
      matrix:
        include:
          - repository: example-org/alpha
            sw-name: alpha
          - repository: example-org/beta
            sw-name: beta
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          repository: ${{ matrix.repository }}
      - uses: oss-review-toolkit/ort-ci-github-action@v1
        with:
          sw-name: ${{ matrix.sw-name }}
```

### Run ORT with a custom global configuration

Use `ort-config-repository` to specify the location of your ORT global configuration repository.
If `ort-config-revision` is not automatically latest state of configuration repository will be used.

Alternatively, you can also place your ORT global configuration files in `~/.ort/config` 
prior to running GitHub Action for ORT.

```yaml
jobs:
  ort:
    runs-on: ubuntu-latest
    steps:
      - name: Use HTTPS instead of SSH for Git cloning
        run: git config --global url.https://github.com/.insteadOf ssh://git@github.com/
      - name: Checkout project
        uses: actions/checkout@v3
        with:
          repository: 'jshttp/mime-types'
      - name: Run GitHub Action for ORT
        uses: oss-review-toolkit/ort-ci-github-action@v1
        with:
          ort-config-repository: 'https://github.com/oss-review-toolkit/ort-config'
          ort-config-revision: 'e4ae8f0a2d0415e35d80df0f48dd95c90a992514'
```

### Run ORT with a custom Docker image

```yaml
jobs:
  ort:
    runs-on: ubuntu-latest
    steps:
      - name: Use HTTPS instead of SSH for Git cloning
        run: git config --global url.https://github.com/.insteadOf ssh://git@github.com/
      - name: Checkout project
        uses: actions/checkout@v3
      - name: Run GitHub Action for ORT
        uses: oss-review-toolkit/ort-ci-github-action@v1
        with:
          image: 'my-org/ort-images/ort:latest'
```

### Run ORT with PostgreSQL database

ORT supports using a PostgreSQL database to caching scan data to speed-up scans.

Use the following [action secrets at GitHub org or repository level][gh-action-secrets] to specified the database to use:
- `POSTGRES_URL`: 'jdbc:postgresql://ort-db.example.com:5432/ort'
- `POSTGRES_USERNAME`: 'ort-db-username'
- `POSTGRES_PASSWORD`: 'ort-db-password'

Next, pass these secrets to GitHub Action for ORT:

```yaml
jobs:
  ort:
    runs-on: ubuntu-latest
    steps:
      - name: Use HTTPS instead of SSH for Git cloning
        run: git config --global url.https://github.com/.insteadOf ssh://git@github.com/
      - name: Checkout project
        uses: actions/checkout@v3
        with:
          repository: 'jshttp/mime-types'
          ref: '2.1.35'
      - name: Run GitHub Action for ORT
        uses: oss-review-toolkit/ort-ci-github-action@v1
        with:
          db-url: ${{ secrets.POSTGRES_URL }}
          db-username: ${{ secrets.POSTGRES_USERNAME }}
          db-password: ${{ secrets.POSTGRES_PASSWORD }}
          run: 'cache-dependencies,analyzer,scanner,evaluator,advisor,reporter,upload-results'
          sw-name: 'Mime Types'
          sw-version: '2.1.35'
```

### Run only parts of the GitHub Action for ORT

```yaml
jobs:
  ort:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout project
        uses: actions/checkout@v3
      - name: Run GitHub Action for ORT
        uses: oss-review-toolkit/ort-ci-github-action@v1
        with:
          run: >
            cache-dependencies,
            metadata-labels,
            analyzer,
            advisor,
            reporter,
            upload-results,
            upload-evaluation-result
```

# Want to Help or have Questions?

All contributions are welcome. If you are interested in contributing, please read our
[contributing guide][ort-contributing-md], and to get quick answers
to any of your questions we recommend you [join our Slack community][ort-slack].

# License

Copyright (C) 2020-2022 [The ORT Project Authors](./NOTICE).

See the [LICENSE](./LICENSE) file in the root of this project for license details.

OSS Review Toolkit (ORT) is a [Linux Foundation project][lf] and part of [ACT][act].

[act]: https://automatecompliance.org/
[gh-action-secrets]: https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository
[gh-tokens]: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token
[ort]: https://github.com/oss-review-toolkit/ort
[ort-config-yml]: https://github.com/oss-review-toolkit/ort/blob/main/model/src/main/resources/reference.yml
[ort-contributing-md]: https://github.com/oss-review-toolkit/.github/blob/main/CONTRIBUTING.md
[ort-slack]: http://slack.oss-review-toolkit.org
[lf]: https://www.linuxfoundation.org
