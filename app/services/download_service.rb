class DownloadService

  def initialize(url, target_path)
    u = URI.parse(url)
    @host = u.host
    @post = u.port || 80
    @path = url.sub("https://#{@host}", "")
    @file_path = "#{Rails.root}/#{target_path}"
  end

  def head
    response = nil
    Net::HTTP.start(@host, @port) {|http|
      response = http.head(@path)
    }
    @filename = self.class.filename_from_content_disposition(response['content-disposition']) || "test.pdf"
  end

  def _begin
    FileUtils.mkdir_p(@file_path) unless File.exist?(@file_path)
    Net::HTTP.start(@host, @port) do |http|
      f = open("#{@file_path}/#{@filename}", "wb")
      begin
        http.request_get(@path) do |resp|
          resp.read_body do |segment|
            f.write(segment)
          end
        end
      ensure
        f.close()
      end
    end
  end

  def exec
    head
    _begin
  end

  def self.filename_from_content_disposition(content_disposition)
    content_disposition = content_disposition.to_s

    escaped_filename =
      content_disposition[/filename\*=UTF-8''(\S+)/, 1] ||
      content_disposition[/filename="([^"]*)"/, 1] ||
      content_disposition[/filename=(\S+)/, 1]

    filename = CGI.unescape(escaped_filename.to_s)

    filename unless filename.empty?
  end

  def self.filename_from_path(path)
    filename = path.split("/").last
    CGI.unescape(filename) if filename
  end

end