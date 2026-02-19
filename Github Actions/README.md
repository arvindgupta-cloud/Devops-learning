## What is Github Actions?
- GitHub Actions is a continuous integration and continuous  delivery (CI/CD) platform built directly into GitHub.
- Its allows you to automate various tasks within your software development workflow.

**GitHub Actions: Components:**
- Workflows: 
- Jobs
- Events
- Actions
- Runners

### Simple Workflow File

```yaml
name: My Awesome Workflow # The name of your workflow

on:
  push: # This workflow will triggger on a push event

jobs:
  build: # The name of your job within the workflow
    runs-on: ubuntu-latest # This job will run on an Ubuntu runner

    step:
    - uses: actions/checkout@v3 # Checkout the code from the repository

      # Add additional steps here to perform actions within your workflow
    - run: echo "Hello World! This is a simple Github Actions workflow." # Example step to print a message
```


### Create a first starter workflow

```text
.github/
└── workflow-templates/
    ├── ci-template.yml
    └── ci-template.properties.json
```

**ci-template.yml**
```yaml
name: Arvind Organization CI

on:
  push:
    branches: [ $default-branch ]
  pull_request:
    branches: [ $default-branch ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v5

      - name: Run a one-line script
        run: echo Welcome to the First workflow created by Arvind
```

**ci-template.properties.json**

```yaml
{
    "name": "Arvind Organization Workflow",
    "description": "Octo Organization CI workflow template.",
    "iconName": "example-icon",
    "categories": [
        "Go"
    ],
    "filePatterns": [
        "package.json$",
        "^Dockerfile",
        ".*\\.md$"
    ]
}
```
