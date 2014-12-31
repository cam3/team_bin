json.array!(@users) do |x|
  json.username x.username
  json.email x.email
end
