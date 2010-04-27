module Paperclip
  class Attachment
    # What gets called when you call instance.attachment = File. It clears
    # errors, assigns attributes, processes the file, and runs validations. It
    # also queues up the previous file for deletion, to be flushed away on
    # #save of its host.  In addition to form uploads, you can also assign
    # another Paperclip attachment:
    #   new_user.avatar = old_user.avatar
    # If the file that is assigned is not valid, the processing (i.e.
    # thumbnailing, etc) will NOT be run.
    def assign uploaded_file
      ensure_required_accessors!

      orig_file = uploaded_file

      if uploaded_file.is_a?(Paperclip::Attachment)
        orig_file = orig_file.to_file(:original)
        uploaded_file = uploaded_file.to_file(:original)
        close_uploaded_file = uploaded_file.respond_to?(:close)
      end

      return nil unless valid_assignment?(uploaded_file)
      return nil unless ['application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3'].include?(uploaded_file.content_type.to_s)

      uploaded_file.binmode if uploaded_file.respond_to? :binmode
      orig_file.binmode if orig_file.respond_to? :binmode
      orig_file = orig_file.to_tempfile

      self.clear

      return nil if uploaded_file.nil?

      @queued_for_write[:original]   = uploaded_file.to_tempfile
      instance_write(:file_name,       uploaded_file.original_filename.strip)
      instance_write(:content_type,    uploaded_file.content_type.to_s.strip)
      instance_write(:file_size,       uploaded_file.size.to_i)
      instance_write(:updated_at,      Time.now)

      # Перед сохранением файла записывает его мд5
      if instance.respond_to?("check_sum=")
        instance.send("check_sum=", Digest::MD5.hexdigest(@queued_for_write[:original].read))
      end

      # Делаем распаковку mp3 tag
      if options[:extract_mp3tag]
        Mp3Info.open(File.expand_path(orig_file.path)) do |mp3|
          instance.send("title=",   mp3.tag.title.try(:to_utf8) ) if instance.title.blank?
          instance.send("author=",  mp3.tag.artist.try(:to_utf8)) if instance.author.blank?
          instance.send("bitrate=", mp3.bitrate)
          instance.send("length=", mp3.length)
        end

      end

      @dirty = true

      post_process if valid?

      # Reset the file size if the original file was reprocessed.
      instance_write(:file_size, @queued_for_write[:original].size.to_i)


    ensure
      uploaded_file.close if close_uploaded_file

      validate
    end
  end
end

