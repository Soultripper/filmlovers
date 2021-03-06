module Apple
  class Client
    class << self

      def import_videos_from(filename)
        # RemoteUnzipper.download_unzip_import_file(url) do |filename|
          AppleEpf::Parser.new(filename).process_rows {|row| Apple::Movie.import row}
        # end
      end

      def import_pricing_from(filename)
        # RemoteUnzipper.download_unzip_import_file(url) do |filename|
          AppleEpf::Parser.new(filename).process_rows {|row| Apple::Pricing.import row}
        # end
      end

      def import_genre(filename)
        AppleEpf::Parser.new(filename).process_rows {|row| Apple::Genre.import row}
      end

      def import_genre_video(filename)
        AppleEpf::Parser.new(filename).process_rows {|row| Apple::GenreVideo.import row}
      end

      def import_storefront(filename)
        AppleEpf::Parser.new(filename).process_rows {|row| Apple::Storefront.import row}
      end
    end
  end
end