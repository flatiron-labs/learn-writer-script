class BaseStrategy
  VALID_STRATEGIES = ["OpenSource", "ToggleToReadme"]

  def initialize(repo, secrets)
    @secrets = secrets
    configure_client
    @repo_name = repo.name
    @owner_name = repo.owner
    @repo_content = generate_repo_content_hash
  end

  def configure_client
    @client ||= Octokit::Client.new(:access_token => self.secrets["octo_token"])
  end

  def generate_repo_content_hash
    relevant_files.each_with_object({}) do |file, hash|
      hash[filename_to_sym(file)] = {sha: " ", present: false}
    end
  end

  def filename_to_sym(filename)
    filename.gsub(".", "_").to_sym
  end

end
