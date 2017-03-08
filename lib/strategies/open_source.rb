class OpenSource < BaseStrategy

  VALID_LICENSE      = File.open(File.expand_path(File.dirname(File.dirname(__FILE__))) + '/fixtures/LICENSE.md')
  VALID_CONTRIBUTING = File.open(File.expand_path(File.dirname(File.dirname(__FILE__))) + '/fixtures/CONTRIBUTING.md')
  VALID_DOT_LEARN    = File.open(File.expand_path(File.dirname(File.dirname(__FILE__))) + '/fixtures/VALID_DOT_LEARN.yml')
  APPLICATION_TOKENS_PATH = File.open(Dir.pwd + '/config/application.yml')

  attr_accessor :client, :repo_content, :repo_name, :owner_name, :secrets

  def execute
    check_for_file_presence
    write_to_repo
  end

  private

  def relevant_files
    ["LICENSE.md", "CONTRIBUTING.md", ".learn"]
  end

  def write_licensemd
    license_content = File.read(VALID_LICENSE)
    client.create_contents("#{owner_name}/#{repo_name}", "LICENSE.md", "create license", license_content)
  end

  def write_contributingmd
    contributing_content = File.read(VALID_CONTRIBUTING)
    client.create_contents("#{owner_name}/#{repo_name}", "CONTRIBUTING.md", "create contributing", contributing_content)
  end

  def write_learn
    dot_learn_content = File.read(VALID_DOT_LEARN)
    client.create_contents("#{owner_name}/#{repo_name}", ".learn", "create dot_learn", dot_learn_content)
  end

  def check_for_file_presence
    files = client.contents("#{owner_name}/#{repo_name}", path: "")
    files.each do |file|
      if relevant_files.include?(file[:name])
        self.repo_content[filename_to_sym(file[:name])][:sha] = file[:sha]
        self.repo_content[filename_to_sym(file[:name])][:present] = true
      end
    end
  end

  def find_or_create(file)
    unless self.repo_content[filename_to_sym(file)][:present]
      send("write_#{file.gsub(".", "").downcase}")
    end
  end

  def write_to_repo
    relevant_files.each do |file|
      find_or_create(file)
    end
  end
end
