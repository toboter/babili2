require "image_processing/mini_magick"

class AvatarUploader < Shrine
  plugin :processing
  plugin :determine_mime_type
  plugin :versions   # enable Shrine to handle a hash of files
  plugin :delete_raw # delete processed files after uploading
  
  process(:store) do |io, context|
    versions = { original: io } # retain original
  
    io.download do |original|
      pipeline = ImageProcessing::MiniMagick.source(original)
      versions[:thumb]        = pipeline.resize_to_fill!(100, 100)
      versions[:small_thumb]  = pipeline.resize_to_fill!(50, 50)
    end
  
    versions
  end

end