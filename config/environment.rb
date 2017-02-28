require 'octokit'
require 'pry'
require 'yaml'

# require_relative "../lib/repo.rb"
# require_relative "../lib/repo_writer.rb"
# require_relative "../fixtures/LICENSE.md"
# require_relative "../fixtures/CONTRIBUTING.md"
# require_relative "../fixtures/VALID_DOT_LEARN.yml"

Dir["./lib/*.rb"].each {|f| require f}
Dir["./fixtures/*.md"].each {|f| require f}
Dir["./fixtures/*.yml"].each {|f| require f}


