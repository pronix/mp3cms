require 'digest/md5'
require 'net/http'
require 'uri'

run Proc.new {|env|
    koza = 'http://mp3koza.com/api/get'
    if env["PATH_INFO"] =~ /download/
      url = env["PATH_INFO"].split('/download/')
      puts "url = #{url}"
      rip = env['REMOTE_ADDR']
      puts "rip = #{rip}"
      secret = '123456'
      hash = Digest::MD5.digest("#{url}#{rip}#{secret}")
      url2 = URI.parse(koza)
      res = Net::HTTP.post_form(url2,{'uri' => url, 'ip' => rip, 'data' => hash})
      if res.code.to_i == 200
        file_path = res.body.gsub('ok!!! ','')
        puts file_path
        @headers = {
            'X-Accel-Redirect' => "/intern/#{file_path}",
            'Content-Type'              =>  "application/mp3",
            'Content-Disposition'       =>  "attachment; filename=#{file_path.split('/').last.gsub(' ','_')}",
            "Content-Transfer-Encoding" => 'binary'
        }
        [200, @headers, "ok!"]
      else
        [403, {"Content-Type" => "text/html"  }, "you can't !!!"]
      end
    else
        [301, {'Location' =>  koza, "Content-Type" => "text/html" }, ['See Ya!']]
    end

}
