module SamfundetPaths
  def gem_paths(project_root = Dir.pwd)
    ruby_v = Gem::ConfigMap[:ruby_version]

    {
        :gem_home => File.expand_path("vendor/ruby/#{ruby_v}", project_root),
        :gem_path => File.expand_path("vendor/ruby/#{ruby_v}", project_root),
        :gem_bin  => File.expand_path("vendor/ruby/#{ruby_v}/bin", project_root)
    }
  end
end
