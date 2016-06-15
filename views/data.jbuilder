json.status @status
json.data do
  json.array!(Array(@data_array))
end