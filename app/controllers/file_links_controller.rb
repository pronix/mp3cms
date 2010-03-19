class FileLinksController < ApplicationController

  before_filter :find_user

  def generate
    @track = Track.find params[:track_id]
    @file_link = build_link @user, @track
    if !@user.file_link_of(@track) && @file_link.save
      flash[:notice] = 'Ссылка успешно создана'
      redirect_to track_path @track
    else
      flash[:notice] = 'Невозможно сгенерировать ссылку'
      redirect_to track_path @track
    end
  end

  def download
    #@file_link = FileLink.find_by_link params[:file_link]
    #@format = params[:format]
    #if @file_link
      #if @format == "mp3"
      #  @file = @file_link.file_path
      #else
      #  @file = @file_link.file_path.split(".")[0] + "." + @format
      #end
    #  send_file @file_link.file_path
              #"#{RAILS_ROOT}/data" + @track.data.url,
              #  :disposition => 'attachment',
              #  :encoding => 'utf8',
              #  :type => @track.data_content_type
              #  :type => "application/x-rar-compressed"
              #  :x_sendfile => false
              #  :filename => URI.encode(@asset.name))
              #  :filename => @track.title)
    #else
    #  flash[:notice] = 'Такой ссылки нет в базе'
    #end
  end

  def build_link(user, track)
    return nil unless user && track
    secret_string = Array.new(100){['0'..'9','a'..'z','A'..'Z'].map{|r| r.to_a}.flatten[rand(['0'..'9','a'..'z','A'..'Z'].map{|r| r.to_a}.flatten.size)]}.to_s
    ip = request.remote_ip
    generate_link = Digest::MD5.hexdigest [ip, Time.now.to_i, secret_string].join
    file_link = user.file_links.build :track_id => track.id,
                          :file_name => track.data_file_name,
                          :file_path => track.data.path,
                          :file_size => track.data_file_size,
                          :content_type => track.data_content_type,
                          :link => generate_link,
                          :ip => ip,
                          :expire => 1.week.from_now
    file_link
  end

end

