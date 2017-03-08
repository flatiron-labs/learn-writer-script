# Learn Curriculum Batch Update Script

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


