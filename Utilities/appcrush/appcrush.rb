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
#
# Copyright (c) 2011 Peter Boctor
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE
#

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
    
    # Iterate through all jpg images
    Dir.glob(File.join(expanded_dir, 'Payload', "*.app", '*.jpg')).each do |jpg_file|
      # and move each to the destination directory
      system "mv '#{jpg_file}' '#{images_dir_path}'"
    end
    
    # Cleanup. Delete the expanded dir
    system "rm -drf '#{expanded_dir}'"
  end
end