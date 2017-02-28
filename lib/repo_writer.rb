class OpenSource

  VALID_LICENSE = File.open(File.expand_path(File.dirname(__FILE__)) + '/fixtures/LICENSE.md')
  VALID_CONTRIBUTING = File.open(File.expand_path(File.dirname(__FILE__)) + '/fixtures/CONTRIBUTING.md')
  VALID_DOT_LEARN = File.open(File.expand_path(File.dirname(__FILE__)) + '/fixtures/VALID_DOT_LEARN.yml')
  APPLICATION_TOKENS_PATH = File.open(Dir.pwd + '/config/application.yml')

  
  attr_accessor :client, :repo_content, :repo_name, :owner_name, :secrets

  def initialize(repo, secrets)
    @secrets = secrets
    configure_client
    @repo_name = repo.name
    @owner_name = repo.owner
    @repo_content = {contributing: {sha: " ", present: false}, license: {sha: " ", present: false}, dot_learn: {sha: " ", present: false}}
  end

  def execute
    check_for_file_presence
    ["license", "dot_learn", "contributing"].each do |type|
      find_or_create(type)
    end
  end

  private

  def configure_client
    @client ||= Octokit::Client.new(:access_token => self.secrets["octo_token"])
  end

  def write_license
    license_content = File.read(VALID_LICENSE)
    client.create_contents("#{owner_name}/#{repo_name}", "LICENSE.md", "create license", license_content)
  end

  def write_contributing
    contributing_content = File.read(VALID_CONTRIBUTING)
    client.create_contents("#{owner_name}/#{repo_name}", "CONTRIBUTING.md", "create contributing", contributing_content)
  end

  def write_dot_learn
    dot_learn_content = File.read(VALID_DOT_LEARN)
    client.create_contents("#{owner_name}/#{repo_name}", ".learn", "create dot_learn", dot_learn_content)
  end

  def check_for_file_presence
    files = client.contents("#{owner_name}/#{repo_name}", path: "")
    files.each do |file|
      if file[:name] == "CONTRIBUTING.md"
        self.repo_content[:contributing][:sha] = file[:sha]
        self.repo_content[:contributing][:present] = true
      elsif file[:name] == "LICENSE.md"
        self.repo_content[:license][:sha] = file[:sha]
        self.repo_content[:license][:present] = true
      elsif file[:name] == ".learn"
        self.repo_content[:dot_learn][:sha] = file[:sha]
        self.repo_content[:dot_learn][:present] = true
      end
    end
  end

  def find_or_create(type)
    unless self.repo_content[type.to_sym][:present]
      send("write_#{type}")
    end
  end

end
