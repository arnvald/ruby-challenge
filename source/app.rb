require 'sinatra'
require 'pry'
require_relative './github_repo_api'

get '/' do
  github_repo_api = GithubRepoApi.new("sinatra/sinatra")
  @issues = split_by_status(github_repo_api.fetch_issues(50))

  erb :index, issues: @issues
end

def split_by_status(issues)
  grouped_issues = {backlog: [], doing: [], done: []}

  issues.each do |issue|
    group = if issue["state"] == "closed" 
              :done
            elsif issue["pull_request"] && issue["pull_request"]["html_url"]
              :doing
            else
              :backlog
            end

    grouped_issues[group] << issue
  end

  grouped_issues
end
