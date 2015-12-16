# Learn Open-Sourcing Script

All public-facing content on Learn Verified must have valid `.learn`, `CONTRIBUTING.md` and `LICENSE.md` files. Never write those files yourself again because boring. 

Grab all of the urls of the repos you want to open source and create and set `repos` equal to an array of those urls in `bin/run`. Then, run `ruby bin/run` from the command line. Script will run to write any of the above files and commit them to the repos, provided they do not already exist. 

`lib/repo_writer.rb` class uses Octokit to create and commit files to a repo. 