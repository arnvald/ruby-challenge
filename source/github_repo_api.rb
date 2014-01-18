require 'net/http'
require 'json'

class GithubRepoApi

  def initialize(repo)
    @repo = repo
  end

  def fetch_issues(number, state=nil)
    issues = []
    issues << make_request(issues_url(state: "open")) if state.nil? || state == "open"
    issues << make_request(issues_url(state: "closed")) if state.nil? || state == "closed"

    # convert strings to dates
    issues.sort_by { |a,b| a["created_at"] <=> b["created_at"] }.flatten.first(number)
  end

  def make_request(url)
    JSON.parse(Net::HTTP.get(URI(url)))
  end

  def issues_url(filter_params={})
    base_api_url + issues_path + "?" + filter_params.map {|k,v| "#{k}=#{v}" }.join("&")
  end

  def base_api_url
    "https://api.github.com/repos/"
  end

  def issues_path
    "#{@repo}/issues"
  end

end
