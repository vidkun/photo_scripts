#
# Author: vidkun
# Date: 20150421
#
# This script will pull the exif data image files in the directory specified, 
# check for a subjects tag, and add the name of all subjects to the end of
# the image's filename
#
# Must install the mini_exiftool gem first: gem install mini_exiftool
#
# Usage: add_people_to_image_name.rb "/the/path/to/my/target/directory"
#
require 'mini_exiftool'

IMAGE_EXTENSIONS = [ '.jpg', '.jpeg', '.gif', '.bmp', '.png', '.tiff' ]
# Get command line options to pull in target dir
target_directory = ARGV[0]

# Get all files in directory
files = Dir["#{target_directory}/*"]

# Iterate through each one
files.each do |file|
  # get current filename and extension
  current_name = File.basename(file, ".*")
  current_extension = File.extname(file).downcase

  # check that file is an image
  if IMAGE_EXTENSIONS.include? current_extension
    
    # pull exif data from image
    photo = MiniExiftool.new file

    # print out the photo's subjects for testing purposes
    puts photo.subject unless photo.subject.nil? || photo.subject.size == 0

    # ensure the photo has a subject tag with people listed in it
    if !photo.subject.nil? && photo.subject.size != 0
      # begin new filename with current_name
      new_name = current_name + "_"

      # iterate through each subject for this photo
      # format their name without spaces
      # add their name to string for new filename
      photo.subject.each do |person|
        persons_name = person.split.join('')
        new_name << persons_name
      end

      # rename file with new_name
      File.rename(file, target_directory + "/" + new_name + current_extension)
    end
  end
end