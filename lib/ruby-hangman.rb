dictionary = Array.new()
input = File.open('./google-10000-english-no-swears.txt', 'r') do |file|
    while line = file.gets
        if (line.chomp.length > 5 && line.chomp.length < 12)
            dictionary.push(line.chomp)
        end
    end
end

def word_picker
    dictionary[rand(0..dictionary.length)]
end
