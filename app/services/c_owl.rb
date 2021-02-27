class COwl
  def self.creating_task(expression = nil)
    uri = URI.parse("http://localhost:2020/creating_task")
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.post(uri, expression.to_json)
    JSON.load(response.body)&.with_indifferent_access
  end

  def self.verify_trace_act(expression = nil)
    uri = URI.parse("http://localhost:2020/verify_trace_act")
    http = Net::HTTP.new(uri.host, uri.port)
    response = http.post(uri, expression.to_json)
    JSON.load(response.body)&.with_indifferent_access
  end
end
