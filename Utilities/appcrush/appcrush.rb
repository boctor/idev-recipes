#!/usr/bin/ruby -rubygems
#
# Point appcrush at an .ipa file from the iTunes AppStore and it
# - expands the zip file
# - finds all the images
# - runs pngcrush with the revert-iphone-optimizations option on each image
#
# Requirements Xcode with iOS SDK 3.2 or higher
#
# Usage: appcrush '/Users/boctor/Music/iTunes/Mobile Applications/iBooks.ipa'
#
# Author: Peter Boctor
# http://idevrecipes.com
# https://github.com/boctor/idev-recipes/Utilities/appcrush
# Version 1.0

# Only pngcrush in 3.2 and above supports revert-iphone-optimizations
# See http://developer.apple.com/library/ios/#qa/qa2010/qa1681.html
pngcrush = '/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/pngcrush'

destination = File.join(ENV['HOME'], 'Desktop')

ARGV.each do |ipa|
  if File.extname(ipa) == '.ipa'
    # Get the app name by stripping out the extension from the file name
    app_name = File.basename(ipa, ".*")
    
    # Get the expanded dir by stripping out the extension from the file path
    expanded_dir = ipa.sub(File.extname(ipa), '')

    # In case the dir is already there, try and remove it
    system "rm -drf '#{expanded_dir}'"

    # Extract .ipa zip file
    system "unzip -q '#{ipa}' -d '#{expanded_dir}'"
    
    images_dir_path = File.join(destination, "#{app_name} Images")

    # In case the destination directory is already there, try and remove it
    system "rm -drf '#{images_dir_path}'"

    # Create the destination directory
    Dir.mkdir(images_dir_path)
    
    # Iterate through all png images
    Dir.glob(File.join(expanded_dir, 'Payload', "*.app", '*.png')).each do |png_file|
      # and revert the iphone optimizations
      system "#{pngcrush} -q -revert-iphone-optimizations -d '#{images_dir_path}' '#{png_file}'"
    end
    
    # Cleanup. Delete the expanded dir
    system "rm -drf '#{expanded_dir}'"
  end
end