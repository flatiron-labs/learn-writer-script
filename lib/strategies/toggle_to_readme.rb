class ToggleToReadme < BaseStrategy
  attr_reader :client, :repo_name, :owner_name, :secrets, :repo_content, :files, :spec_files

  def initialize(repo, secrets)
    super(repo, secrets) 
    @spec_files = []
  end
 
  def execute
    get_files
    check_for_file_presence
    delete_files
    check_for_spec_directory
    delete_specs
  end

  private

  def relevant_files
    [ "index.html", "index.js", "package.json"]
  end

  def delete_files
    relevant_files.each do |file|
      file_hash = repo_content[filename_to_sym(file)]
      if file_hash[:present]
        delete(file, file_hash[:sha])
      end
    end
  end

  def delete_specs
    spec_files.each do |file|
      delete(file[:path], file[:sha])
    end
  end

  def delete(filename, sha)
    unless filename == "spec" || filename == "test"
      client.delete_contents("#{owner_name}/#{repo_name}", "#{filename}", "deleting #{filename}", sha)
    end
  end

  def get_files
    sha = client.ref("#{owner_name}/#{repo_name}", "heads/master").object.sha
    sha_base_tree = client.commit("#{owner_name}/#{repo_name}", sha).commit.tree.sha
    @files = client.tree("#{owner_name}/#{repo_name}", sha_base_tree, :recursive => true).tree
  end

  def check_for_file_presence
    files.each do |file|
      if relevant_files.include?(file[:path])
        self.repo_content[filename_to_sym(file[:path])][:sha] = file[:sha]
        self.repo_content[filename_to_sym(file[:path])][:present] = true
      end
    end
  end

  def check_for_spec_directory
    files.each do |file|
      if file.path.include?("test") || file.path.include?("spec")
        spec_files << { path: file.path, sha: file.sha }
      end
    end
  end

end

