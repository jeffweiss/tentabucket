defmodule Tentabucket.Webhooks do
  import Tentabucket
  alias Tentabucket.Client

  @doc """
    List webhooks for a repository

    ## Examples
      Tentabucket.Repositories.list_hooks("duksis", "tentacat", client)

    More info at: https://developer.github.com/v3/repos/#list-your-repositories
  """
  @spec list_hooks(binary, binary, Client.t, Keyword.t) :: Tentabucket.response
  def list_hooks(owner, repo, client \\ Client.new, opts \\ []) do
    get "repositories/#{owner}/#{repo}/hooks", client, opts
  end

  @spec create_hook(binary, binary, map, Client.t, Keyword.t) :: Tentabucket.response
  def create_hook(owner, repo, hook, client \\ Client.new, opts \\ []) do
    post "repositories/#{owner}/#{repo}/hooks", hook, client, opts
  end

  @spec delete_hook(binary, binary, map|binary, Client.t, Keyword.t) :: Tentabucket.response
  def delete_hook(owner, repo, hook_or_id, client \\ Client.new, opts \\ [])
  def delete_hook(_owner, _repo, %{"link" => %{"self" => %{"href" => link}}}, client, opts) do
    delete link, client, opts
  end
  def delete_hook(owner, repo, %{"uuid" => id}, client, opts) do
    delete_hook owner, repo, id, client, opts
  end
  def delete_hook(owner, repo, hook = <<"{", _>>, client, opts) when is_binary(hook) do
    delete_hook(owner, repo, URI.encode(hook), client, opts)
  end
  def delete_hook(owner, repo, hook, client, opts) when is_binary(hook) do
    delete "repositories/#{owner}/#{repo}/hooks/#{hook}", client, opts
  end

  @spec update_hook(binary, binary, map, Client.t, Keyword.t) :: Tentabucket.response
  def update_hook(owner, repo, hook, client \\ Client.new, opts \\ [])
  def update_hook(_owner, _repo, hook = %{"link" => %{"self" => %{"href" => link}}}, client, opts) do
    put link, hook, client, opts
  end
  def update_hook(owner, repo, hook = %{"uuid" => id = <<"{",_>>}, client, opts) do
    put "repositories/#{owner}/#{repo}/hooks/#{URI.encode(id)}", hook, client, opts
  end
  def update_hook(owner, repo, hook = %{"uuid" => id}, client, opts) do
    put "repositories/#{owner}/#{repo}/hooks/#{id}", hook, client, opts
  end
end

