class DownloadService

  def initialize(url, target_path)
    @url = url
    u = URI.parse(@url)
    @host = u.host
    @post = u.port || 80
    @file_path = "#{Rails.root}/#{target_path}"
  end

  def _begin
    FileUtils.mkdir_p(@file_path) unless File.exist?(@file_path)
    open(@url,
        "User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.120 Safari/537.36",
        "Referer" => "https://jiaoshi.izhikang.com/sixtteacher/home/home!newIndex.action?modelTab=1")do |response|
      @filename = self.class.filename_from_content_disposition(response.meta['content-disposition'])
      raise Exception.new("pdf file not found") if @filename.blank?
      response.set_encoding('UTF-8')
      open("#{@file_path}/#{@filename}", 'w') { |f|
        f.write(response.read)
      }
    end

  end

  def exec
    _begin
    @filename
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