module SamfundetPaths
  def gem_paths
    ruby_v = Gem::ConfigMap[:ruby_version]

    {
        :gem_home => File.expand_path("vendor/ruby/#{ruby_v}", __FILE__),
        :gem_path => File.expand_path("vendor/ruby/#{ruby_v}", __FILE__),
        :gem_bin  => File.expand_path("vendor/ruby/#{ruby_v}/bin", __FILE__)
    }
  end
end
