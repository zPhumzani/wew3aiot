require "wew3aiot/version"

module Wew3aiot
  class Application
    def call(env)
      @req = Rack::Request.new(env)
      path = @req.path_info
      request_method = @req.request_method.downcase
      return [500, {}, []] if path == "/favicon.ico"
      controller, action = fetch_controller_and_action(path, request_method)
      response = controller.new.send(action)
      [200, {"Content-Type" => "text/html"}, [response]]
    end

    def fetch_controller_action(path, verb)
      _, controller, action, others = path.split("/", 4)
      require "#{controller.downcase}_controller.rb"
      controller = Object.const_get(controller.capitalize! + "Controller")
      action = action.nil? ? verb : "#{verb}_#{action}"
      [controller, action]
    end
  end
end
