require 'zlib'
require 'base64'
require 'chunky_png'

src_code = File.read(ARGV[0])
comp_code = Base64.encode64(Zlib::Deflate.deflate(src_code)).gsub(/(\r\n?|\n)/,"")
# puts comp_code
# puts comp_code.size

# 画像の読み込み
image_filename = ARGV[1]
image = ChunkyPNG::Image.from_file(image_filename)

# リサイズ処理を実行する
new_width = 120
threshold = 0
scale_factor = new_width.to_f / image.width
new_height = (image.height * scale_factor / 2).round
resize_image = image.resample_bilinear(new_width, new_height)

str = ''
count = 0
while count < comp_code.size do
  # 2値化処理を実行する
  count = 0
  str = ''
  (0...resize_image.height).each do |y|
    row = ''
    (0...resize_image.width).each do |x|
      pixel = ChunkyPNG::Color.to_grayscale_bytes(resize_image[x, y]).first
      # output_image[x, y] = pixel < threshold ? ChunkyPNG::Color::BLACK : ChunkyPNG::Color::WHITE
      if (pixel < threshold) then
        next if comp_code.size < count
        row += comp_code[count].to_s
        count += 1
      else
        row += ' '
      end
    end
    str += row + "\n"
  end
  threshold += 1
end

dist = "require'zlib';eval(Zlib::Inflate.inflate(\"\n" + str.gsub!(/^[\s]*\n/, "").chomp + "\".unpack('m')[0]))"
puts dist
puts "threthold is #{threshold}. size is #{count}."
File.write('dist.rb', dist)