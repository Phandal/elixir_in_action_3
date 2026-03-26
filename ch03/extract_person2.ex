defmodule Person do
  def extract(person) do
    case Enum.filter(["login", "username", "password"], &(not Map.has_key?(person, &1))) do
      [] -> %{login: person["login"], username: person["username"], password: person["password"]}
      fields -> {:error, "missing fields: #{Enum.join(fields, ",")}"}
    end
  end
end

# Person.extract(%{
#   "login" => "alice",
#   "username" => "some_email",
#   "password" => "password",
#   "other_field" => "some_value",
#   "yet_another_field" => "..."
# })
