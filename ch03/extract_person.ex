defmodule ExtractPerson do
  def extract_person(person) do
    with {:ok, login} <- extract_login(person),
         {:ok, username} <- extract_username(person),
         {:ok, password} <- extract_password(person) do
      %{login: login, username: username, password: password}
    end
  end

  defp extract_login(%{"login" => login}), do: {:ok, login}
  defp extract_login(_), do: {:error, "missing login"}

  defp extract_username(%{"username" => username}), do: {:ok, username}
  defp extract_username(_), do: {:error, "missing username"}

  defp extract_password(%{"password" => password}), do: {:ok, password}
  defp extract_password(_), do: {:error, "missing password"}
end

# ExtractPerson.extract_person(%{
#   "login" => "alice",
#   "email" => "some_email",
#   "password" => "password",
#   "other_field" => "some_value",
#   "yet_another_field" => "..."
# })
