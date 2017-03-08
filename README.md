# Learn Curriculum Batch Update Script

## Setup
You'll need a [personal access token from GitHub](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/) in order to use this script.

We also recommend using the [`figaro`](https://github.com/laserlemon/figaro) gem to manage hiding your key.

Your `config/application.yml` file should look something like this:

```
octo_token: INSERT_YOUR_TOKEN_HERE
```

## Usage
This script enables the batch updating of curriculum. To use, gather a list
of repos you want to update and put them in a spreadsheet. Grab the
absolute path to the CSV.

From the command line, run `bin/run STRATEGY path/to/csv`, where `STRATEGY`
represents what you want to do the curriculum and `path/to/csv` represents
the path to the CSV of repos.

Valid strategies are defined in `BaseStrategy`. Currently they include
"OpenSource" and "ToggleToReadme".


## Toggle To Readme

Sometimes people use lab templates to create readmes. This script will
remove the test files and package.json if they exist. Learn will flag
content with a package.json and test directories as a lab.


## Open Source

All public-facing content on Learn Verified must have valid `.learn`, `CONTRIBUTING.md` and `LICENSE.md` files. Never write those files yourself again because boring. 


