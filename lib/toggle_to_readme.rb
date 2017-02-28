class ToggleToReadme
  attr_reader :client, :repo_name, :owner_name, :secrets, :repo_content
 
  def initialize(repo, secrets)
    @secrets = secrets
    configure_client
    @repo_name = repo.name
    @owner_name = repo.owner
    @repo_content = generate_repo_content_hash
  end

  def execute
    check_for_file_presence
    relevant_files.each do |file|
      delete(file)
    end
  end

  private

  def generate_repo_content_hash
    relevant_files.each_with_object({}) do |file, hash|
      hash[filename_to_sym(file)] = {sha: " ", present: false}
    end
  end

  def relevant_files
    [ "index.html", "index.js", "package.json"]
    #also need to delete test directory
  end

  def configure_client
    @client ||= Octokit::Client.new(:access_token => self.secrets["octo_token"])
  end

  def delete(filename)
    if repo_content[filename_to_sym(filename)][:present]
      client.delete_contents("#{owner_name}/#{repo_name}", "#{filename}", "deleting #{filename}", repo_content[filename_to_sym(filename)][:sha])
    end
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

  def filename_to_sym(filename)
    filename.gsub(".", "_").to_sym
  end

end

