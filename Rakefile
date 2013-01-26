require 'rubygems'
require 'bundler/setup' # Releasy requires require that your application uses bundler.
require 'releasy'

#<<<
Releasy::Project.new do
  name "LimaGameJam"
  version "0.0.1"
  verbose # Can be removed if you don't want to see all build messages.

  executable "Main.rb"
  files [ "game_objects/*.rb", "levels/*.rb", "lib/**/*.rb", "config/**/*.yml", "media/**/*.*"]
  # exposed_files ["Main.rb"]
  add_link "http://github.com/xenda/limagamejam", "GitHub"
  exclude_encoding # Applications that don't use advanced encoding (e.g. Japanese characters) can save build size with this.

  # Create a variety of releases, for all platforms.
  # add_build :osx_app do
  #   url "com.github.my_application"
  #   wrapper "wrappers/gosu-mac-wrapper-0.7.41.tar.gz" # Assuming this is where you downloaded this file.
  #   icon "media/icon.icns"
  #   add_package :tar_gz
  # end

  # add_build :source do
  #   add_package :"7z"
  # end

  # If building on a Windows machine, :windows_folder and/or :windows_installer are recommended.
  # add_build :windows_folder do
  #   icon "media/icon.ico"
  #   executable_type :windows # Assuming you don't want it to run with a console window.
  #   add_package :exe # Windows self-extracting archive.
  # end

  # add_build :windows_installer do
  #   icon "media/icon.ico"
  #   start_menu_group "Spooner Games"
  #   readme "README.html" # User asked if they want to view readme after install.
  #   license "LICENSE.txt" # User asked to read this and confirm before installing.
  #   executable_type :windows # Assuming you don't want it to run with a console window.
  #   add_package :zip
  # end

  # If unable to build on a Windows machine, :windows_wrapped is the only choice.
  add_build :windows_wrapped do
    wrapper "ruby-1.9.3-p0-i386-mingw32.7z" # Assuming this is where you downloaded this file.
    executable_type :windows # Assuming you don't want it to run with a console window.
    exclude_tcl_tk # Assuming application doesn't use Tcl/Tk, then it can save a lot of size by using this.
    add_package :zip
  end

   add_build :source do
    add_package :"7z"
  end


  # add_deploy :github # Upload to a github project.
end
#>>>