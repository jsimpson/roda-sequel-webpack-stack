# frozen_string_literal: true

require 'net/http'

# :nodoc:
module WebpackHelper
  WEBPACK_DEV_SERVER = 'http://localhost:8080/'

  def webpack_tag(*files)
    files +=  ['runtime.js'] unless webpack_dev_server_up?
    files.map { |file| load_tag file }.join
  end

  def load_tag(filename)
    %(<script src="#{webpack_path(filename)}" defer></script>) if filename.end_with?('.js')
  end

  def webpack_path(filename)
    if webpack_dev_server_up?
      webpack_dev_server(filename)
    else
      public_manifest_path(filename)
    end
  end

  def public_manifest_path(filename)
    file = File.read('./public/manifest.json')
    manifest = JSON.parse(file)
    manifest[filename]
  end

  def webpack_dev_server(filename)
    uri = URI(WEBPACK_DEV_SERVER + 'manifest.json')
    res = Net::HTTP.get(uri)
    manifest = JSON.parse(res)
    WEBPACK_DEV_SERVER + manifest[filename]
  end

  def webpack_dev_server_up?
    return false unless ENV['RACK_ENV'] == 'development'

    @webpack_dev_server_up ||= begin
                                 uri = URI(WEBPACK_DEV_SERVER)
                                 Net::HTTP.get(uri) != ''
                               rescue Errno::ECONNREFUSED
                                 false
                               end
  end
end
