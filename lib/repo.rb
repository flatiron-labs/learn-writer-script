class Repo
  attr_accessor :name, :owner

  def initialize(url)
    @name = get_repo_name(url)
    @owner = get_owner_name(url)
  end

  def get_repo_name(url)
    url.split("/").last
  end

  def get_owner_name(url)
    url.split("/")[-2]
  end

end